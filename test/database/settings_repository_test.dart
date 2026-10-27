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

  test('load memakai nilai bawaan saat database masih kosong', () async {
    final settings = await repository.load();

    expect(settings.businessName, isEmpty);
    expect(settings.notaFormat, 'LDR-{tanggal}-{urut}');
    expect(settings.labelSize, '58x40');
    expect(settings.overdueDays, 7);
    expect(settings.onboardingDone, isFalse);
    expect(settings.hasBusinessName, isFalse);
  });

  test('menyimpan profil usaha dan membacanya lewat load', () async {
    await repository.saveBusiness(
      name: '  Laundry Bersih  ',
      phone: '08123456789',
      address: 'Jalan Melati 3',
      receiptFooter: 'Terima kasih',
    );

    final settings = await repository.load();
    expect(settings.businessName, 'Laundry Bersih');
    expect(settings.businessPhone, '08123456789');
    expect(settings.businessAddress, 'Jalan Melati 3');
    expect(settings.receiptFooter, 'Terima kasih');
    expect(settings.displayName, 'Laundry Bersih');
    expect(settings.hasBusinessName, isTrue);
  });

  test('format nota, ukuran label, dan batas hari tersimpan', () async {
    await repository.setNotaFormat('INV-{tanggal}-{urut}');
    await repository.setLabelSize('58x30');
    await repository.setOverdueDays(10);

    final settings = await repository.load();
    expect(settings.notaFormat, 'INV-{tanggal}-{urut}');
    expect(settings.labelSize, '58x30');
    expect(settings.overdueDays, 10);
  });

  test('menandai onboarding selesai', () async {
    expect(await repository.isOnboardingDone(), isFalse);

    await repository.completeOnboarding();

    expect(await repository.isOnboardingDone(), isTrue);
    expect((await repository.load()).onboardingDone, isTrue);
  });

  test('menyimpan printer dan lebar kertas', () async {
    await repository.setPrinter(name: 'RPP02N', address: 'AA:BB:CC:DD:EE:FF');
    await repository.setPaperWidth(80);

    final settings = await repository.load();
    expect(settings.printerName, 'RPP02N');
    expect(settings.printerAddress, 'AA:BB:CC:DD:EE:FF');
    expect(settings.hasPrinter, isTrue);
    expect(settings.paperWidth, 80);

    final saved = await repository.printer();
    expect(saved?.name, 'RPP02N');
    expect(saved?.address, 'AA:BB:CC:DD:EE:FF');
  });

  test('lebar kertas bawaan 58 mm', () async {
    final settings = await repository.load();
    expect(settings.paperWidth, 58);
    expect(settings.hasPrinter, isFalse);
    expect(await repository.printer(), isNull);
  });
}
