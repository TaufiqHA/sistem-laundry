import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/features/report/domain/report_data.dart';

void main() {
  test('rentang harian mulai tengah malam', () {
    final range = ReportRange.day(DateTime(2026, 10, 27, 14, 30));

    expect(range.start, DateTime(2026, 10, 27));
    expect(range.end, DateTime(2026, 10, 28));
  });

  test('rentang bulanan mencakup satu bulan penuh', () {
    final range = ReportRange.month(DateTime(2026, 10, 27));

    expect(range.start, DateTime(2026, 10));
    expect(range.end, DateTime(2026, 11));
  });

  test('geser harian dan bulanan melewati batas tahun', () {
    final day = ReportRange.day(DateTime(2026, 1, 1));
    expect(day.shift(ReportPeriod.harian, -1).start, DateTime(2025, 12, 31));

    final month = ReportRange.month(DateTime(2026, 1, 15));
    expect(month.shift(ReportPeriod.bulanan, -1).start, DateTime(2025, 12));
    expect(month.shift(ReportPeriod.bulanan, 1).start, DateTime(2026, 2));
  });

  test('of memilih jenis rentang sesuai periode', () {
    final anchor = DateTime(2026, 10, 27);
    expect(
      ReportRange.of(ReportPeriod.harian, anchor).end,
      DateTime(2026, 10, 28),
    );
    expect(
      ReportRange.of(ReportPeriod.bulanan, anchor).end,
      DateTime(2026, 11),
    );
  });

  test('laba dihitung dari pemasukan dikurangi pengeluaran', () {
    const data = ReportData(
      orderCount: 2,
      income: 10000,
      expenseTotal: 4000,
      topServices: [],
      expenses: [],
    );
    expect(data.profit, 6000);

    const rugi = ReportData(
      orderCount: 0,
      income: 1000,
      expenseTotal: 5000,
      topServices: [],
      expenses: [],
    );
    expect(rugi.profit, -4000);
  });
}
