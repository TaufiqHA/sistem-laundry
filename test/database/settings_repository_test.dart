import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/features/settings/data/settings_repository.dart';

void main() {
  late AppDatabase db;
  late SettingsRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = SettingsRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('menyimpan dan membaca teks', () async {
    await repository.set(SettingKeys.businessName, 'Laundry Bersih');
    expect(await repository.get(SettingKeys.businessName), 'Laundry Bersih');
    expect(await repository.get(SettingKeys.businessPhone), isNull);
  });

  test('menimpa nilai lama tanpa membuat baris ganda', () async {
    await repository.set(SettingKeys.overdueDays, '7');
    await repository.set(SettingKeys.overdueDays, '10');

    expect(await repository.getInt(SettingKeys.overdueDays), 10);
    final rows = await db.select(db.settings).get();
    expect(rows, hasLength(1));
  });

  test('menyimpan tanggal sebagai UTC dan membaca sebagai lokal', () async {
    final local = DateTime(2026, 10, 27, 14, 30);
    await repository.setDateTime(SettingKeys.lastBackupAt, local);

    final read = await repository.getDateTime(SettingKeys.lastBackupAt);
    expect(read, isNotNull);
    expect(read!.isAtSameMomentAs(local), isTrue);
  });

  test('membaca semua pengaturan sekaligus', () async {
    await repository.set(SettingKeys.businessName, 'Laundry Bersih');
    await repository.set(SettingKeys.businessPhone, '628123456789');

    final all = await repository.all();
    expect(all, hasLength(2));
    expect(all[SettingKeys.businessName], 'Laundry Bersih');
  });
}
