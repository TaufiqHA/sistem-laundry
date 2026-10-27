import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

enum ReportPeriod {
  harian('Harian'),
  bulanan('Bulanan');

  const ReportPeriod(this.label);

  final String label;
}

/// Rentang setengah terbuka: [start] sampai sebelum [end].
class ReportRange {
  const ReportRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  static ReportRange day(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    return ReportRange(start: start, end: start.add(const Duration(days: 1)));
  }

  static ReportRange month(DateTime date) {
    return ReportRange(
      start: DateTime(date.year, date.month),
      end: DateTime(date.year, date.month + 1),
    );
  }

  static ReportRange of(ReportPeriod period, DateTime anchor) {
    return switch (period) {
      ReportPeriod.harian => day(anchor),
      ReportPeriod.bulanan => month(anchor),
    };
  }

  ReportRange shift(ReportPeriod period, int delta) {
    return switch (period) {
      ReportPeriod.harian => day(start.add(Duration(days: delta))),
      ReportPeriod.bulanan => month(DateTime(start.year, start.month + delta)),
    };
  }
}

class ServiceSales {
  const ServiceSales({
    required this.nama,
    required this.qtyMilli,
    required this.revenue,
    required this.orderCount,
    this.satuan,
  });

  final String nama;
  final int qtyMilli;
  final int revenue;
  final int orderCount;
  final ServiceUnit? satuan;
}

class ExpenseEntry {
  const ExpenseEntry({
    required this.id,
    required this.kategori,
    required this.jumlah,
    required this.tanggal,
    this.catatan,
  });

  final int id;
  final String kategori;
  final int jumlah;
  final DateTime tanggal;
  final String? catatan;
}

class ReportData {
  const ReportData({
    required this.orderCount,
    required this.income,
    required this.expenseTotal,
    required this.topServices,
    required this.expenses,
  });

  static const empty = ReportData(
    orderCount: 0,
    income: 0,
    expenseTotal: 0,
    topServices: [],
    expenses: [],
  );

  final int orderCount;

  /// Uang masuk dari pembayaran pada periode ini.
  final int income;

  final int expenseTotal;
  final List<ServiceSales> topServices;
  final List<ExpenseEntry> expenses;

  int get profit => income - expenseTotal;
}
