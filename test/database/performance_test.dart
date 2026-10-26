import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/core/database/dev_seeder.dart';

/// Uji performa tidak dijalankan pada `flutter test` biasa karena
/// menyiapkan 50.000 order. Jalankan dengan `make perf`.
const _runPerf = bool.fromEnvironment('RUN_PERF');

void main() {
  test(
    '50.000 order: seed, pencarian nota, pencarian telepon, ringkasan',
    () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      final seeder = DevSeeder(db);
      final seedWatch = Stopwatch()..start();
      await seeder.seedOrders(
        count: 50000,
        customerCount: 500,
        withPayments: false,
        withHistory: false,
      );
      seedWatch.stop();
      stdout.writeln('seed 50.000 order: ${seedWatch.elapsedMilliseconds} ms');

      final orders = await db.select(db.orders).get();
      expect(orders, hasLength(50000));

      // Pemanasan supaya pengukuran tidak menghitung kompilasi query.
      await (db.select(db.orders)..limit(1)).get();

      final byNotaWatch = Stopwatch()..start();
      final byNota =
          await (db.select(db.orders)..where(
                (table) => table.nomorNota.equals(orders.first.nomorNota),
              ))
              .get();
      byNotaWatch.stop();
      stdout.writeln('cari nomor nota: ${byNotaWatch.elapsedMilliseconds} ms');
      expect(byNota, hasLength(1));
      expect(byNotaWatch.elapsedMilliseconds, lessThan(300));

      final byPhoneWatch = Stopwatch()..start();
      final byPhone = await db
          .customSelect(
            'SELECT o.id FROM orders o '
            'JOIN customers c ON c.id = o.customer_id '
            'WHERE c.telepon = ? LIMIT 20',
            variables: [Variable.withString('6281210000000')],
          )
          .get();
      byPhoneWatch.stop();
      stdout.writeln(
        'cari telepon pelanggan: ${byPhoneWatch.elapsedMilliseconds} ms',
      );
      expect(byPhone, isNotEmpty);
      expect(byPhoneWatch.elapsedMilliseconds, lessThan(300));

      final summaryWatch = Stopwatch()..start();
      final summary = await db
          .customSelect(
            'SELECT COUNT(*) AS jumlah, COALESCE(SUM(total), 0) AS omzet '
            'FROM orders WHERE tanggal_masuk >= ? AND dihapus_pada IS NULL',
            variables: [
              Variable.withDateTime(
                DateTime.now().toUtc().subtract(const Duration(days: 1)),
              ),
            ],
          )
          .getSingle();
      summaryWatch.stop();
      stdout.writeln(
        'ringkasan harian: ${summaryWatch.elapsedMilliseconds} ms',
      );
      expect(summary.read<int>('jumlah'), greaterThan(0));
      expect(summaryWatch.elapsedMilliseconds, lessThan(300));
    },
    skip: _runPerf ? false : 'jalankan dengan: make perf',
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
