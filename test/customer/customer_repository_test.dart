import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/utils/clock.dart';
import 'package:sistem_manajemen_laundry/features/customer/data/customer_repository.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment_method.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

void main() {
  late AppDatabase db;
  late CustomerRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = CustomerRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> insertOrder({
    required int customerId,
    required String nomorNota,
    required String qrToken,
    required int total,
    bool deleted = false,
  }) {
    return db
        .into(db.orders)
        .insert(
          OrdersCompanion.insert(
            nomorNota: nomorNota,
            qrToken: qrToken,
            customerId: customerId,
            tanggalMasuk: nowUtc(),
            total: total,
            dihapusPada: Value(deleted ? nowUtc() : null),
          ),
        );
  }

  test('menyimpan pelanggan dengan nomor ternormalisasi', () async {
    final id = await repository.create(
      nama: '  Ibu Sari ',
      telepon: '0812-3456-7890',
      alamat: 'Jalan Melati 3',
    );

    final customer = await repository.getById(id);
    expect(customer, isNotNull);
    expect(customer!.nama, 'Ibu Sari');
    expect(customer.telepon, '6281234567890');
    expect(customer.alamat, 'Jalan Melati 3');
    expect(customer.catatan, isNull);
  });

  test('mengubah data pelanggan', () async {
    final id = await repository.create(
      nama: 'Ibu Sari',
      telepon: '081234567890',
    );

    await repository.update(
      id: id,
      nama: 'Ibu Sari Wulandari',
      telepon: '081298765432',
      catatan: 'Langganan mingguan',
    );

    final customer = await repository.getById(id);
    expect(customer!.nama, 'Ibu Sari Wulandari');
    expect(customer.telepon, '6281298765432');
    expect(customer.catatan, 'Langganan mingguan');
  });

  test('pencarian nama tidak peduli huruf besar/kecil', () async {
    await repository.create(nama: 'Budi Santoso', telepon: '081211112222');
    await repository.create(nama: 'Sari Dewi', telepon: '081233334444');

    expect((await repository.list(query: 'budi')).single.nama, 'Budi Santoso');
    expect((await repository.list(query: 'SARI')).single.nama, 'Sari Dewi');
    expect(await repository.list(query: 'tidak ada'), isEmpty);
  });

  test('pencarian telepon menerima 08, 62, atau tanpa awalan', () async {
    await repository.create(nama: 'Budi', telepon: '081211112222');

    expect(await repository.list(query: '0812'), hasLength(1));
    expect(await repository.list(query: '62812'), hasLength(1));
    expect(await repository.list(query: '8121111'), hasLength(1));
    expect(await repository.list(query: '0812999'), isEmpty);
  });

  test('findByPhone menemukan nomor yang sama dalam format berbeda', () async {
    final id = await repository.create(nama: 'Budi', telepon: '081211112222');

    expect(await repository.findByPhone('+62 812-1111-2222'), isNotNull);
    expect(await repository.findByPhone('081211112222', exceptId: id), isNull);
    expect(await repository.findByPhone('081299999999'), isNull);
  });

  test('ringkasan menghitung order, belanja, dan piutang', () async {
    final customerId = await repository.create(
      nama: 'Ibu Sari',
      telepon: '081234567890',
    );
    await db
        .into(db.services)
        .insert(
          ServicesCompanion.insert(
            nama: 'Cuci Kering',
            satuan: ServiceUnit.kg,
            harga: 7000,
          ),
        );

    final orderId = await insertOrder(
      customerId: customerId,
      nomorNota: 'LDR-20261027-001',
      qrToken: 'TOKEN00001',
      total: 50000,
    );

    await db
        .into(db.payments)
        .insert(
          PaymentsCompanion.insert(
            orderId: orderId,
            jumlah: 20000,
            metode: PaymentMethod.tunai,
            tanggal: nowUtc(),
          ),
        );

    final summary = await repository.summary(customerId);
    expect(summary.orderCount, 1);
    expect(summary.totalBelanja, 50000);
    expect(summary.piutang, 30000);

    // Order yang dibatalkan tidak boleh ikut dihitung.
    await insertOrder(
      customerId: customerId,
      nomorNota: 'LDR-20261027-002',
      qrToken: 'TOKEN00002',
      total: 15000,
      deleted: true,
    );

    final afterCancel = await repository.summary(customerId);
    expect(afterCancel.orderCount, 1);
    expect(afterCancel.totalBelanja, 50000);
  });

  test('ringkasan pelanggan tanpa order bernilai nol', () async {
    final id = await repository.create(
      nama: 'Pelanggan Baru',
      telepon: '081200000000',
    );

    final summary = await repository.summary(id);
    expect(summary.orderCount, 0);
    expect(summary.totalBelanja, 0);
    expect(summary.piutang, 0);
  });
}
