import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/router/app_router.dart';
import 'package:sistem_manajemen_laundry/core/utils/phone_number.dart';
import 'package:sistem_manajemen_laundry/core/widgets/empty_state.dart';
import 'package:sistem_manajemen_laundry/features/customer/domain/customer.dart';
import 'package:sistem_manajemen_laundry/features/customer/presentation/customer_form_sheet.dart';
import 'package:sistem_manajemen_laundry/features/customer/presentation/customer_providers.dart';

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  final _search = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _query = value.trim());
      }
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
    _search.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerSearchProvider(_query));

    return Scaffold(
      appBar: AppBar(title: const Text('Pelanggan')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'customer-add-fab',
        onPressed: () => _openForm(context, ref, null),
        icon: const Icon(Icons.person_add_alt),
        label: const Text('Tambah'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari nama atau telepon',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: 'Hapus pencarian',
                        onPressed: _clearSearch,
                      ),
              ),
            ),
          ),
          Expanded(
            child: customers.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Gagal memuat pelanggan.'),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () =>
                            ref.invalidate(customerSearchProvider(_query)),
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (customers) {
                if (customers.isEmpty) {
                  return EmptyState(
                    icon: _query.isEmpty
                        ? Icons.people_outline
                        : Icons.search_off,
                    title: _query.isEmpty
                        ? 'Belum ada pelanggan'
                        : 'Tidak ditemukan',
                    message: _query.isEmpty
                        ? 'Tambahkan pelanggan agar order bisa dicatat atas namanya.'
                        : 'Tidak ada nama atau nomor yang cocok dengan "$_query".',
                    action: _query.isEmpty
                        ? FilledButton.icon(
                            onPressed: () => _openForm(context, ref, null),
                            icon: const Icon(Icons.person_add_alt),
                            label: const Text('Tambah pelanggan'),
                          )
                        : null,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 96),
                  itemCount: customers.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return _CustomerTile(
                      customer: customer,
                      onTap: () =>
                          context.push(AppRoutes.customerDetail(customer.id)),
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

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref,
    Customer? customer,
  ) async {
    final savedId = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => CustomerFormSheet(customer: customer),
    );
    if (savedId != null) {
      ref.invalidate(customerSearchProvider);
    }
  }
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({required this.customer, required this.onTap});

  final Customer customer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alamat = customer.alamat;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.secondaryContainer,
          foregroundColor: theme.colorScheme.onSecondaryContainer,
          child: Text(
            customer.initial,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        title: Text(
          customer.nama,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          [PhoneNumber.display(customer.telepon), ?alamat].join(' · '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
