import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:sistem_manajemen_laundry/core/database/tables/customers.dart';
import 'package:sistem_manajemen_laundry/core/database/tables/expenses.dart';
import 'package:sistem_manajemen_laundry/core/database/tables/licenses.dart';
import 'package:sistem_manajemen_laundry/core/database/tables/nota_counters.dart';
import 'package:sistem_manajemen_laundry/core/database/tables/order_items.dart';
import 'package:sistem_manajemen_laundry/core/database/tables/order_status_history.dart';
import 'package:sistem_manajemen_laundry/core/database/tables/orders.dart';
import 'package:sistem_manajemen_laundry/core/database/tables/payments.dart';
import 'package:sistem_manajemen_laundry/core/database/tables/services.dart';
import 'package:sistem_manajemen_laundry/core/database/tables/settings.dart';
import 'package:sistem_manajemen_laundry/core/utils/clock.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_status.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment_method.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/status_change_source.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Customers,
    Services,
    Orders,
    OrderItems,
    Payments,
    OrderStatusHistory,
    Expenses,
    Settings,
    Licenses,
    NotaCounters,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Untuk unit test: `AppDatabase.forTesting(NativeDatabase.memory())`.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      beforeOpen: (details) async {
        // SQLite mematikan foreign key per koneksi; harus dinyalakan
        // setiap kali database dibuka.
        await customStatement('PRAGMA foreign_keys = ON');
        await customStatement('PRAGMA journal_mode = WAL');
      },
    );
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'laundry',
    native: const DriftNativeOptions(shareAcrossIsolates: true),
  );
}
