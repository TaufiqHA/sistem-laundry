import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/router/app_router.dart';
import 'package:sistem_manajemen_laundry/core/widgets/empty_state.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_providers.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_widgets.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  final _search = TextEditingController();
  Timer? _debounce;
  String _query = '';
  OrderFilter _filter = OrderFilter.hariIni;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();
    setState(() {
      // Mencari order lama tidak masuk akal kalau filter masih "hari ini".
      if (query.isNotEmpty && _filter == OrderFilter.hariIni) {
        _filter = OrderFilter.semua;
      }
    });
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _query = query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(
      orderListProvider((filter: _filter, query: _query)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'order-create-fab',
        onPressed: () => context.push(AppRoutes.orderForm),
        icon: const Icon(Icons.add),
        label: const Text('Order baru'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari nota, nama, atau telepon',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: 'Hapus pencarian',
                        onPressed: () {
                          _search.clear();
                          setState(() => _query = '');
                        },
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final filter in OrderFilter.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter.label),
                      selected: _filter == filter,
                      onSelected: (_) => setState(() => _filter = filter),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: orders.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Gagal memuat order.'),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => ref.invalidate(
                          orderListProvider((filter: _filter, query: _query)),
                        ),
                        child: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (orders) {
                if (orders.isEmpty) {
                  return EmptyState(
                    icon: _query.isEmpty
                        ? Icons.receipt_long_outlined
                        : Icons.search_off,
                    title: _query.isEmpty
                        ? 'Belum ada order'
                        : 'Order tidak ditemukan',
                    message: _query.isEmpty
                        ? 'Order yang dibuat akan muncul di sini.'
                        : 'Tidak ada nota, nama, atau nomor yang cocok dengan '
                              '"$_query".',
                    action: _query.isEmpty
                        ? FilledButton.icon(
                            onPressed: () => context.push(AppRoutes.orderForm),
                            icon: const Icon(Icons.add),
                            label: const Text('Buat order'),
                          )
                        : null,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 96),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      OrderCard(order: orders[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
