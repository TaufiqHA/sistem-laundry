import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/core/utils/quantity.dart';
import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';
import 'package:sistem_manajemen_laundry/core/utils/tanggal.dart';
import 'package:sistem_manajemen_laundry/features/report/domain/report_data.dart';
import 'package:sistem_manajemen_laundry/features/report/presentation/expense_sheet.dart';
import 'package:sistem_manajemen_laundry/features/report/presentation/report_providers.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  ReportPeriod _period = ReportPeriod.harian;
  DateTime _anchor = DateTime.now();

  ReportRange get _range => ReportRange.of(_period, _anchor);

  void _shift(int delta) {
    setState(() {
      _anchor = _range.shift(_period, delta).start;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final range = _range;
    final report = ref.watch(
      reportProvider((start: range.start, end: range.end)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Laporan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          SegmentedButton<ReportPeriod>(
            segments: [
              for (final period in ReportPeriod.values)
                ButtonSegment(value: period, label: Text(period.label)),
            ],
            selected: {_period},
            onSelectionChanged: (selection) {
              setState(() {
                _period = selection.first;
                _anchor = DateTime.now();
              });
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: () => _shift(-1),
                icon: const Icon(Icons.chevron_left),
                tooltip: 'Periode sebelumnya',
              ),
              Expanded(
                child: Text(
                  _period == ReportPeriod.harian
                      ? formatTanggalLengkap(range.start)
                      : formatBulanTahun(range.start),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              IconButton(
                onPressed: () => _shift(1),
                icon: const Icon(Icons.chevron_right),
                tooltip: 'Periode berikutnya',
              ),
            ],
          ),
          const SizedBox(height: 8),
          report.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Gagal memuat laporan.'),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => ref.invalidate(reportProvider),
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
            data: (report) => _ReportBody(
              report: report,
              onAddExpense: _addExpense,
              onDeleteExpense: _deleteExpense,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addExpense() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const ExpenseSheet(),
    );
    if (saved == true) {
      ref.invalidate(reportProvider);
    }
  }

  Future<void> _deleteExpense(ExpenseEntry expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus pengeluaran?'),
        content: Text(
          '${expense.kategori} ${Rupiah.format(expense.jumlah)} akan dihapus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }

    await ref.read(reportRepositoryProvider).deleteExpense(expense.id);
    ref.invalidate(reportProvider);
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({
    required this.report,
    required this.onAddExpense,
    required this.onDeleteExpense,
  });

  final ReportData report;
  final VoidCallback onAddExpense;
  final ValueChanged<ExpenseEntry> onDeleteExpense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        label: 'Pemasukan',
                        value: Rupiah.format(report.income),
                      ),
                    ),
                    Expanded(
                      child: _Stat(
                        label: 'Pengeluaran',
                        value: Rupiah.format(report.expenseTotal),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        label: 'Laba',
                        value: Rupiah.format(report.profit),
                        color: report.profit < 0
                            ? theme.colorScheme.error
                            : null,
                      ),
                    ),
                    Expanded(
                      child: _Stat(
                        label: 'Jumlah order',
                        value: '${report.orderCount}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('Layanan terlaris', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Card(
          child: report.topServices.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Belum ada layanan pada periode ini.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (
                      var index = 0;
                      index < report.topServices.length;
                      index++
                    ) ...[
                      if (index > 0) const Divider(height: 1),
                      _ServiceRow(
                        rank: index + 1,
                        sales: report.topServices[index],
                      ),
                    ],
                  ],
                ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text('Pengeluaran', style: theme.textTheme.titleMedium),
            ),
            TextButton.icon(
              onPressed: onAddExpense,
              icon: const Icon(Icons.add),
              label: const Text('Tambah'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: report.expenses.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Belum ada pengeluaran pada periode ini.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (
                      var index = 0;
                      index < report.expenses.length;
                      index++
                    ) ...[
                      if (index > 0) const Divider(height: 1),
                      _ExpenseRow(
                        expense: report.expenses[index],
                        onDelete: () => onDeleteExpense(report.expenses[index]),
                      ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({required this.rank, required this.sales});

  final int rank;
  final ServiceSales sales;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final qty = sales.satuan == null
        ? Quantity.format(sales.qtyMilli)
        : Quantity.format(sales.qtyMilli, unit: sales.satuan!.label);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        foregroundColor: theme.colorScheme.onSecondaryContainer,
        child: Text('$rank'),
      ),
      title: Text(sales.nama),
      subtitle: Text('${sales.orderCount} order · $qty'),
      trailing: Text(
        Rupiah.format(sales.revenue),
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  const _ExpenseRow({required this.expense, required this.onDelete});

  final ExpenseEntry expense;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final catatan = expense.catatan;
    return ListTile(
      title: Text(expense.kategori),
      subtitle: Text([formatTanggal(expense.tanggal), ?catatan].join(' · ')),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Rupiah.format(expense.jumlah),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Hapus pengeluaran',
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
