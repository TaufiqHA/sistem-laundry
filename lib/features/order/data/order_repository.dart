import 'dart:math';

import 'package:drift/drift.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/utils/clock.dart';
import 'package:sistem_manajemen_laundry/core/utils/phone_number.dart';
import 'package:sistem_manajemen_laundry/core/utils/qr_token.dart';
import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';
import 'package:sistem_manajemen_laundry/core/utils/tanggal.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_status.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/status_change_source.dart';
import 'package:sistem_manajemen_laundry/features/settings/data/settings_repository.dart';

class OrderRepository {
  OrderRepository(this._db);

  final AppDatabase _db;
  final _random = Random.secure();

  /// Membuat order beserta item dan riwayat status dalam satu transaksi.
  /// Nomor nota diambil dari counter tanggal yang sama, sehingga tidak
  /// mungkin kembar walau dua order disimpan berurutan.
  Future<int> create({
    required int customerId,
    required List<NewOrderItem> items,
    required DateTime estimasiSelesai,
    String? catatan,
    int diskon = 0,
  }) {
    _validateItems(items);

    return _db.transaction(() async {
      final settings = await SettingsRepository(_db).load();
      final tanggalMasuk = nowUtc();
      final nomorNota = await _nextNotaNumber(
        tanggalMasuk,
        settings.notaFormat,
      );
      final total = _total(items, diskon);

      final orderId = await _db
          .into(_db.orders)
          .insert(
            OrdersCompanion.insert(
              nomorNota: nomorNota,
              qrToken: await _newQrToken(),
              customerId: customerId,
              tanggalMasuk: tanggalMasuk,
              estimasiSelesai: Value(estimasiSelesai.toUtc()),
              diskon: Value(diskon),
              total: total,
              catatan: Value(_nullIfEmpty(catatan)),
            ),
          );

      await _insertItems(orderId, items);
      await _db
          .into(_db.orderStatusHistory)
          .insert(
            OrderStatusHistoryCompanion.insert(
              orderId: orderId,
              statusBaru: OrderStatus.diterima,
              sumber: StatusChangeSource.manual,
            ),
          );

      return orderId;
    });
  }

  Future<List<LaundryOrder>> list({
    OrderFilter filter = OrderFilter.hariIni,
    String query = '',
  }) async {
    final builder = _joinedOrders();
    builder.where(_db.orders.dihapusPada.isNull());

    if (filter == OrderFilter.hariIni) {
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day);
      builder.where(
        _db.orders.tanggalMasuk.isBiggerOrEqualValue(start) &
            _db.orders.tanggalMasuk.isSmallerThanValue(
              start.add(const Duration(days: 1)),
            ),
      );
    } else if (filter.status != null) {
      builder.where(_db.orders.status.equalsValue(filter.status!));
    }

    final search = query.trim();
    if (search.isNotEmpty) {
      final digits = search.replaceAll(RegExp(r'[^0-9]'), '');
      final byText =
          _db.orders.nomorNota.like('%$search%') |
          _db.customers.nama.like('%$search%');
      builder.where(
        digits.isEmpty
            ? byText
            : byText |
                  _db.customers.telepon.like(
                    '%${PhoneNumber.normalize(digits)}%',
                  ),
      );
    }

    builder.orderBy([
      OrderingTerm.desc(_db.orders.tanggalMasuk),
      OrderingTerm.desc(_db.orders.id),
    ]);

    final rows = await builder.get();
    return rows.map(_mapJoined).toList(growable: false);
  }

  Future<List<LaundryOrder>> listByCustomer(int customerId) async {
    final builder = _joinedOrders();
    builder
      ..where(_db.orders.dihapusPada.isNull())
      ..where(_db.orders.customerId.equals(customerId))
      ..orderBy([
        OrderingTerm.desc(_db.orders.tanggalMasuk),
        OrderingTerm.desc(_db.orders.id),
      ]);
    final rows = await builder.get();
    return rows.map(_mapJoined).toList(growable: false);
  }

  Future<OrderDetail?> getDetail(int id) async {
    final row =
        await (_joinedOrders()
              ..where(_db.orders.id.equals(id))
              ..limit(1))
            .getSingleOrNull();
    if (row == null) {
      return null;
    }
    final order = _mapJoined(row);

    final itemRows = await (_db.select(_db.orderItems).join([
      leftOuterJoin(
        _db.services,
        _db.services.id.equalsExp(_db.orderItems.serviceId),
      ),
    ])..where(_db.orderItems.orderId.equals(id))).get();

    final historyRows = await (_db.select(
      _db.orderStatusHistory,
    )..where((table) => table.orderId.equals(id))).get();

    final paidRow = await _db
        .customSelect(
          'SELECT COALESCE(SUM(jumlah), 0) AS dibayar FROM payments '
          'WHERE order_id = ? AND dihapus_pada IS NULL',
          variables: [Variable.withInt(id)],
          readsFrom: {_db.payments},
        )
        .getSingle();

    return OrderDetail(
      order: order,
      items: itemRows
          .map(
            (itemRow) => OrderLine(
              id: itemRow.readTable(_db.orderItems).id,
              serviceId: itemRow.readTable(_db.orderItems).serviceId,
              namaLayanan: itemRow.readTable(_db.orderItems).namaLayanan,
              qtyMilli: itemRow.readTable(_db.orderItems).qtyMilli,
              hargaSatuan: itemRow.readTable(_db.orderItems).hargaSatuan,
              subtotal: itemRow.readTable(_db.orderItems).subtotal,
              satuan: itemRow.readTableOrNull(_db.services)?.satuan,
            ),
          )
          .toList(growable: false),
      history: historyRows
          .map(
            (entry) => StatusChange(
              statusLama: entry.statusLama,
              statusBaru: entry.statusBaru,
              sumber: entry.sumber,
              waktu: entry.diubahPada,
            ),
          )
          .toList(growable: false),
      dibayar: paidRow.read<int>('dibayar'),
    );
  }

  /// Mengubah item dan data order. Nomor nota dan token tidak berubah.
  /// Perubahan ditolak kalau total baru lebih kecil dari yang sudah dibayar.
  Future<void> update({
    required int id,
    required int customerId,
    required List<NewOrderItem> items,
    required DateTime estimasiSelesai,
    String? catatan,
    int diskon = 0,
  }) {
    _validateItems(items);

    return _db.transaction(() async {
      final dibayar = await _paidAmount(id);
      final total = _total(items, diskon);
      if (total < dibayar) {
        throw OrderException(
          'Total baru ${Rupiah.format(total)} lebih kecil dari pembayaran '
          '${Rupiah.format(dibayar)}.',
        );
      }

      await (_db.delete(
        _db.orderItems,
      )..where((table) => table.orderId.equals(id))).go();
      await _insertItems(id, items);

      await (_db.update(
        _db.orders,
      )..where((table) => table.id.equals(id))).write(
        OrdersCompanion(
          customerId: Value(customerId),
          estimasiSelesai: Value(estimasiSelesai.toUtc()),
          diskon: Value(diskon),
          total: Value(total),
          catatan: Value(_nullIfEmpty(catatan)),
          diubahPada: Value(nowUtc()),
        ),
      );
    });
  }

  /// Soft delete. Order yang sudah menerima pembayaran harus dibersihkan
  /// pembayarannya dulu agar uang tidak hilang dari laporan.
  Future<void> cancel(int id) {
    return _db.transaction(() async {
      final dibayar = await _paidAmount(id);
      if (dibayar > 0) {
        throw OrderException(
          'Order sudah menerima pembayaran ${Rupiah.format(dibayar)}. '
          'Hapus pembayaran dulu sebelum membatalkan order.',
        );
      }
      final now = nowUtc();
      await (_db.update(
        _db.orders,
      )..where((table) => table.id.equals(id))).write(
        OrdersCompanion(dihapusPada: Value(now), diubahPada: Value(now)),
      );
    });
  }

  /// Memajukan status tepat satu tahap dan menulis riwayat.
  Future<OrderStatus> advanceStatus(
    int id, {
    StatusChangeSource source = StatusChangeSource.manual,
  }) {
    return _db.transaction(() async {
      final order = await (_db.select(
        _db.orders,
      )..where((table) => table.id.equals(id))).getSingleOrNull();
      if (order == null || order.dihapusPada != null) {
        throw OrderException('Order tidak ditemukan atau sudah dibatalkan.');
      }

      final next = order.status.next;
      if (next == null) {
        throw OrderException('Status sudah Diambil dan tidak bisa dimajukan.');
      }

      final now = nowUtc();
      await (_db.update(_db.orders)..where((table) => table.id.equals(id)))
          .write(OrdersCompanion(status: Value(next), diubahPada: Value(now)));
      await _db
          .into(_db.orderStatusHistory)
          .insert(
            OrderStatusHistoryCompanion.insert(
              orderId: id,
              statusLama: Value(order.status),
              statusBaru: next,
              sumber: source,
              diubahPada: Value(now),
            ),
          );
      return next;
    });
  }

  /// Mengembalikan status ke tahap sebelumnya. Hanya berlaku untuk satu
  /// perubahan terakhir dan menulis baris riwayat baru.
  Future<OrderStatus> undoLastStatus(int id) {
    return _db.transaction(() async {
      final order = await (_db.select(
        _db.orders,
      )..where((table) => table.id.equals(id))).getSingleOrNull();
      if (order == null || order.dihapusPada != null) {
        throw OrderException('Order tidak ditemukan atau sudah dibatalkan.');
      }

      final last =
          await (_db.select(_db.orderStatusHistory)
                ..where((table) => table.orderId.equals(id))
                ..orderBy([(table) => OrderingTerm.desc(table.id)])
                ..limit(1))
              .getSingleOrNull();

      if (last == null || last.statusLama == null) {
        throw OrderException('Belum ada perubahan status untuk diurungkan.');
      }
      if (last.sumber == StatusChangeSource.urungkan) {
        throw OrderException('Perubahan terakhir sudah diurungkan.');
      }
      if (last.statusBaru != order.status) {
        throw OrderException(
          'Status sudah berubah. Muat ulang halaman lalu coba lagi.',
        );
      }

      final previous = last.statusLama!;
      final now = nowUtc();
      await (_db.update(
        _db.orders,
      )..where((table) => table.id.equals(id))).write(
        OrdersCompanion(status: Value(previous), diubahPada: Value(now)),
      );
      await _db
          .into(_db.orderStatusHistory)
          .insert(
            OrderStatusHistoryCompanion.insert(
              orderId: id,
              statusLama: Value(order.status),
              statusBaru: previous,
              sumber: StatusChangeSource.urungkan,
              diubahPada: Value(now),
            ),
          );
      return previous;
    });
  }

  JoinedSelectStatement<HasResultSet, dynamic> _joinedOrders() {
    return _db.select(_db.orders).join([
      innerJoin(
        _db.customers,
        _db.customers.id.equalsExp(_db.orders.customerId),
      ),
    ]);
  }

  Future<String> _nextNotaNumber(DateTime tanggal, String format) async {
    final key = tanggalKey(tanggal);
    final existing = await (_db.select(
      _db.notaCounters,
    )..where((table) => table.tanggal.equals(key))).getSingleOrNull();
    final urutan = (existing?.urutan ?? 0) + 1;

    await _db
        .into(_db.notaCounters)
        .insertOnConflictUpdate(
          NotaCountersCompanion.insert(tanggal: key, urutan: urutan),
        );

    final local = tanggal.toLocal();
    final tanggalTeks =
        '${local.year}${local.month.toString().padLeft(2, '0')}'
        '${local.day.toString().padLeft(2, '0')}';
    return format
        .replaceAll('{tanggal}', tanggalTeks)
        .replaceAll('{urut}', urutan.toString().padLeft(3, '0'));
  }

  Future<String> _newQrToken() async {
    for (var attempt = 0; attempt < 5; attempt++) {
      final token = QrToken.generate(random: _random);
      final existing = await (_db.select(
        _db.orders,
      )..where((table) => table.qrToken.equals(token))).getSingleOrNull();
      if (existing == null) {
        return token;
      }
    }
    throw OrderException('Gagal membuat token unik. Coba lagi.');
  }

  Future<void> _insertItems(int orderId, List<NewOrderItem> items) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.orderItems,
        items
            .map(
              (item) => OrderItemsCompanion.insert(
                orderId: orderId,
                serviceId: item.serviceId,
                namaLayanan: item.namaLayanan,
                qtyMilli: item.qtyMilli,
                hargaSatuan: item.hargaSatuan,
                subtotal: item.subtotal,
              ),
            )
            .toList(growable: false),
      );
    });
  }

  Future<int> _paidAmount(int orderId) async {
    final row = await _db
        .customSelect(
          'SELECT COALESCE(SUM(jumlah), 0) AS dibayar FROM payments '
          'WHERE order_id = ? AND dihapus_pada IS NULL',
          variables: [Variable.withInt(orderId)],
          readsFrom: {_db.payments},
        )
        .getSingle();
    return row.read<int>('dibayar');
  }

  static int _total(List<NewOrderItem> items, int diskon) {
    final subtotal = items.fold(0, (sum, item) => sum + item.subtotal);
    final total = subtotal - diskon;
    return total < 0 ? 0 : total;
  }

  static void _validateItems(List<NewOrderItem> items) {
    if (items.isEmpty) {
      throw OrderException('Order harus punya minimal satu layanan.');
    }
    for (final item in items) {
      if (item.qtyMilli <= 0) {
        throw OrderException('Jumlah ${item.namaLayanan} harus lebih dari 0.');
      }
      if (item.hargaSatuan < 0) {
        throw OrderException('Harga ${item.namaLayanan} tidak valid.');
      }
    }
  }

  LaundryOrder _mapJoined(TypedResult row) {
    final order = row.readTable(_db.orders);
    final customer = row.readTable(_db.customers);
    return LaundryOrder(
      id: order.id,
      nomorNota: order.nomorNota,
      qrToken: order.qrToken,
      customerId: customer.id,
      customerNama: customer.nama,
      customerTelepon: customer.telepon,
      tanggalMasuk: order.tanggalMasuk,
      estimasiSelesai: order.estimasiSelesai,
      status: order.status,
      total: order.total,
      diskon: order.diskon,
      catatan: order.catatan,
    );
  }

  static String? _nullIfEmpty(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
