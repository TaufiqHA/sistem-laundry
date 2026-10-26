import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/features/settings/domain/app_settings.dart';

void main() {
  group('AppSettings.validateNotaFormat', () {
    test('format bawaan valid', () {
      expect(
        AppSettings.validateNotaFormat(AppSettings.defaultNotaFormat),
        isNull,
      );
    });

    test('wajib memuat penanda tanggal dan urutan', () {
      expect(AppSettings.validateNotaFormat('LDR-{tanggal}'), isNotNull);
      expect(AppSettings.validateNotaFormat('LDR-{urut}'), isNotNull);
      expect(AppSettings.validateNotaFormat('LDR-{tanggal}-{urut}'), isNull);
    });

    test('menolak kosong dan terlalu panjang', () {
      expect(AppSettings.validateNotaFormat('   '), isNotNull);
      expect(
        AppSettings.validateNotaFormat('{tanggal}-{urut}-${'X' * 40}'),
        isNotNull,
      );
    });
  });

  test('nama tampilan memakai teks cadangan saat usaha belum diisi', () {
    const empty = AppSettings();
    expect(empty.displayName, 'Usaha belum diatur');

    const filled = AppSettings(businessName: '  Laundry Bersih ');
    expect(filled.displayName, 'Laundry Bersih');
  });

  test('pilihan ukuran label yang didukung', () {
    expect(AppSettings.labelSizes.keys, containsAll(['58x40', '58x30']));
  });
}
