import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

import 'package:sistem_manajemen_laundry/core/utils/quantity.dart';
import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';
import 'package:sistem_manajemen_laundry/core/utils/tanggal.dart';
import 'package:sistem_manajemen_laundry/features/printer/domain/print_content.dart';

/// Penyusun byte ESC/POS. Tidak menyentuh Bluetooth sama sekali supaya
/// hasil cetak bisa diuji tanpa printer.
abstract final class EscPosBuilder {
  static CapabilityProfile? _profile;

  static Future<CapabilityProfile> _loadProfile() async {
    final cached = _profile;
    if (cached != null) {
      return cached;
    }
    final loaded = await CapabilityProfile.load();
    _profile = loaded;
    return loaded;
  }

  static Future<List<int>> receipt(
    ReceiptContent content, {
    PaperSize paper = PaperSize.mm58,
  }) async {
    final generator = Generator(paper, await _loadProfile());
    final width = _charsPerLine(paper);
    final bytes = <int>[];

    bytes.addAll(generator.reset());
    bytes.addAll(
      generator.text(
        content.businessName,
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ),
    );
    if (content.address.isNotEmpty) {
      bytes.addAll(
        generator.text(
          content.address,
          styles: const PosStyles(align: PosAlign.center),
        ),
      );
    }
    if (content.phone.isNotEmpty) {
      bytes.addAll(
        generator.text(
          content.phone,
          styles: const PosStyles(align: PosAlign.center),
        ),
      );
    }
    bytes.addAll(generator.hr());
    bytes.addAll(
      generator.text(
        'No. ${content.nota}',
        styles: const PosStyles(bold: true),
      ),
    );
    if (content.masuk != null) {
      bytes.addAll(generator.text(formatTanggalJam(content.masuk!)));
    }
    bytes.addAll(generator.text('Pelanggan: ${content.customerName}'));
    bytes.addAll(generator.hr());

    for (final item in content.items) {
      bytes.addAll(generator.text(item.nama));
      final quantity = item.satuan.isEmpty
          ? Quantity.format(item.qtyMilli)
          : Quantity.format(item.qtyMilli, unit: item.satuan);
      bytes.addAll(
        generator.text(
          _twoColumns(
            '$quantity x ${Rupiah.format(item.hargaSatuan)}',
            Rupiah.format(item.subtotal),
            width,
          ),
        ),
      );
    }

    bytes.addAll(generator.hr());
    bytes.addAll(
      generator.text(
        _twoColumns('Subtotal', Rupiah.format(content.subtotal), width),
      ),
    );
    if (content.diskon > 0) {
      bytes.addAll(
        generator.text(
          _twoColumns('Diskon', '-${Rupiah.format(content.diskon)}', width),
        ),
      );
    }
    bytes.addAll(
      generator.text(
        _twoColumns('Total', Rupiah.format(content.total), width),
        styles: const PosStyles(bold: true),
      ),
    );
    bytes.addAll(
      generator.text(
        _twoColumns('Dibayar', Rupiah.format(content.dibayar), width),
      ),
    );
    if (content.piutang > 0) {
      bytes.addAll(
        generator.text(
          _twoColumns('Sisa', Rupiah.format(content.piutang), width),
          styles: const PosStyles(bold: true),
        ),
      );
    }

    bytes.addAll(generator.hr());
    if (content.footer.isNotEmpty) {
      bytes.addAll(
        generator.text(
          content.footer,
          styles: const PosStyles(align: PosAlign.center),
        ),
      );
    }
    bytes.addAll(
      generator.text(
        'Terima kasih',
        styles: const PosStyles(align: PosAlign.center),
      ),
    );
    bytes.addAll(generator.feed(3));
    bytes.addAll(generator.cut());
    return bytes;
  }

  /// Label kantong: nomor nota besar, tanpa harga, QR untuk memajukan status.
  /// [labelSize] mengikuti pengaturan `58x40` atau `58x30`.
  static Future<List<int>> label(
    LabelContent content, {
    PaperSize paper = PaperSize.mm58,
    String labelSize = '58x40',
  }) async {
    final generator = Generator(paper, await _loadProfile());
    final compact = labelSize == '58x30';
    final maxItems = compact ? 1 : 2;
    final qrSize = compact ? QRSize.size5 : QRSize.size6;

    final bytes = <int>[];
    bytes.addAll(generator.reset());
    bytes.addAll(
      generator.text(
        content.nota,
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ),
    );
    bytes.addAll(
      generator.text(
        content.customerName,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
    );

    final lines = content.itemLines.take(maxItems).toList(growable: false);
    for (final line in lines) {
      bytes.addAll(
        generator.text(line, styles: const PosStyles(align: PosAlign.center)),
      );
    }
    if (content.itemLines.length > maxItems) {
      bytes.addAll(
        generator.text(
          '+${content.itemLines.length - maxItems} layanan lain',
          styles: const PosStyles(align: PosAlign.center),
        ),
      );
    }
    if (content.estimasi != null) {
      bytes.addAll(
        generator.text(
          'Est. ${formatTanggal(content.estimasi!)}',
          styles: const PosStyles(align: PosAlign.center),
        ),
      );
    }

    bytes.addAll(
      generator.qrcode(content.qrPayload, size: qrSize, cor: QRCorrection.M),
    );
    bytes.addAll(generator.feed(compact ? 1 : 2));
    bytes.addAll(generator.cut());
    return bytes;
  }

  /// Hanya untuk pengujian koneksi printer.
  static Future<List<int>> testPage(String businessName) async {
    final generator = Generator(PaperSize.mm58, await _loadProfile());
    final bytes = <int>[];
    bytes.addAll(generator.reset());
    bytes.addAll(
      generator.text(
        'Uji printer',
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ),
    );
    bytes.addAll(
      generator.text(
        businessName,
        styles: const PosStyles(align: PosAlign.center),
      ),
    );
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text('Kertas: 58 mm'));
    bytes.addAll(generator.text('QR uji di bawah ini:'));
    bytes.addAll(
      generator.qrcode(
        'LDR1:TEST-001:TOKENUJI01',
        size: QRSize.size6,
        cor: QRCorrection.M,
      ),
    );
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());
    return bytes;
  }

  static int _charsPerLine(PaperSize paper) {
    if (paper == PaperSize.mm58) {
      return 32;
    }
    if (paper == PaperSize.mm72) {
      return 42;
    }
    return 48;
  }

  static String _twoColumns(String left, String right, int width) {
    final available = width - right.length - 1;
    if (available <= 0) {
      return right;
    }
    final text = left.length > available ? left.substring(0, available) : left;
    return '${text.padRight(width - right.length)}$right';
  }
}
