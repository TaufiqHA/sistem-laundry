import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/router/app_router.dart';
import 'package:sistem_manajemen_laundry/core/utils/phone_number.dart';
import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';
import 'package:sistem_manajemen_laundry/core/utils/tanggal.dart';
import 'package:sistem_manajemen_laundry/core/widgets/empty_state.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/payment_providers.dart';
import 'package:sistem_manajemen_laundry/features/settings/presentation/settings_providers.dart';
import 'package:sistem_manajemen_laundry/features/whatsapp/domain/whatsapp_message.dart';
import 'package:sistem_manajemen_laundry/features/whatsapp/presentation/whatsapp_actions.dart';

class DebtsPage extends ConsumerStatefulWidget {
  const DebtsPage({super.key});

  @override
  ConsumerState<DebtsPage> createState() => _DebtsPageState();
}

class _DebtsPageState extends ConsumerState<DebtsPage> {
  DebtSort _sort = DebtSort.nominal;

  Future<void> _sendReminder(CustomerDebt debt) async {
    final settings = await ref.read(settingsRepositoryProvider).load();
    if (!mounted) {
      return;
    }
    await WhatsAppActions.send(
      context,
      phone: debt.telepon,
      message: WhatsAppMessage.debt(debt, businessName: settings.displayName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final debts = ref.watch(debtsProvider(_sort));
    final total = ref.watch(totalOutstandingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Piutang')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total piutang',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        total.when(
                          data: Rupiah.format,
                          loading: () => '...',
                          error: (error, stack) => '-',
                        ),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<DebtSort>(
              segments: [
                for (final sort in DebtSort.values)
                  ButtonSegment(value: sort, label: Text(sort.label)),
              ],
              selected: {_sort},
              onSelectionChanged: (selection) {
                setState(() => _sort = selection.first);
              },
            ),
          ),
          Expanded(
            child: debts.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  const Center(child: Text('Gagal memuat piutang.')),
              data: (debts) {
                if (debts.isEmpty) {
                  return const EmptyState(
                    icon: Icons.check_circle_outline,
                    title: 'Tidak ada piutang',
                    message: 'Semua order pelanggan sudah lunas.',
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                  itemCount: debts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final debt = debts[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        onTap: () => context.push(
                          AppRoutes.customerDetail(debt.customerId),
                        ),
                        leading: CircleAvatar(
                          child: Text(
                            debt.nama.isEmpty
                                ? '?'
                                : debt.nama.substring(0, 1).toUpperCase(),
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                debt.nama,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              Rupiah.format(debt.piutang),
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${PhoneNumber.display(debt.telepon)}\n'
                          '${debt.jumlahOrder} order · sejak '
                          '${formatTanggal(debt.sejak)}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.chat_outlined),
                          tooltip: 'Pengingat WhatsApp',
                          onPressed: () => _sendReminder(debt),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
