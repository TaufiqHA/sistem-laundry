import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/features/security/data/security_repository.dart';
import 'package:sistem_manajemen_laundry/features/settings/data/settings_repository.dart';

void main() {
  late AppDatabase db;
  late SecurityRepository security;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    security = SecurityRepository(SettingsRepository(db));
  });

  tearDown(() async {
    await db.close();
  });

  test('PIN tersimpan sebagai hash dan bisa diverifikasi', () async {
    expect(await security.hasPin(), isFalse);

    await security.setPin('123456');

    expect(await security.hasPin(), isTrue);
    expect(await security.verifyPin('123456'), isTrue);
    expect(await security.verifyPin('654321'), isFalse);

    final rows = await db.select(db.settings).get();
    final values = {for (final row in rows) row.kunci: row.nilai};
    expect(values['pin_hash'], isNotNull);
    expect(values['pin_hash'], isNot('123456'));
    expect(values['pin_salt'], isNotNull);
  });

  test('PIN bisa diganti', () async {
    await security.setPin('123456');
    await security.setPin('222333');

    expect(await security.verifyPin('123456'), isFalse);
    expect(await security.verifyPin('222333'), isTrue);
  });

  test('menonaktifkan PIN menghapus hash dan salt', () async {
    await security.setPin('123456');
    await security.clearPin();

    expect(await security.hasPin(), isFalse);
    expect(await security.verifyPin('123456'), isFalse);
  });

  test('PIN yang tidak valid ditolak saat disimpan', () async {
    await expectLater(security.setPin('12345'), throwsArgumentError);
    expect(await security.hasPin(), isFalse);
  });
}
