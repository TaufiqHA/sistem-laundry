import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/router/app_router.dart';
import 'package:sistem_manajemen_laundry/core/utils/phone_number.dart';
import 'package:sistem_manajemen_laundry/core/utils/quantity.dart';
import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';
import 'package:sistem_manajemen_laundry/core/utils/tanggal.dart';
import 'package:sistem_manajemen_laundry/features/customer/domain/customer.dart';
import 'package:sistem_manajemen_laundry/features/customer/presentation/customer_form_sheet.dart';
import 'package:sistem_manajemen_laundry/features/customer/presentation/customer_providers.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_pickers.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_providers.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/laundry_service.dart';

class OrderFormPage extends ConsumerWidget {
  const OrderFormPage({super.key, this.orderId});

  final int? orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = orderId;
    if (id == null) {
      return const OrderFormBody();
    }

    final detail = ref.watch(orderDetailProvider(id));
    return detail.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Ubah order')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Ubah order')),
        body: const Center(child: Text('Gagal memuat order.')),
      ),
      data: (detail) {
        if (detail == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Ubah order')),
            body: const Center(child: Text('Order tidak ditemukan.')),
          );
        }
        return OrderFormBody(initial: detail);
      },
    );
  }
}

class OrderFormBody extends ConsumerStatefulWidget {
  const OrderFormBody({super.key, this.initial});

  final OrderDetail? initial;

  @override
  ConsumerState<OrderFormBody> createState() => _OrderFormBodyState();
}

class _OrderFormBodyState extends ConsumerState<OrderFormBody> {
  final _notes = TextEditingController();
  final _items = <NewOrderItem>[];
  Customer? _customer;
  late DateTime _estimasi;
  late int _diskon;
  bool _saving = false;

  bool get _isEdit => widget.initial != null;

  int get _subtotal => _items.fold(0, (sum, item) => sum + item.subtotal);

  int get _total {
    final total = _subtotal - _diskon;
    return total < 0 ? 0 : total;
  }

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial == null) {
      _estimasi = _defaultEstimasi();
      _diskon = 0;
      return;
    }

    _customer = Customer(
      id: initial.order.customerId,
      nama: initial.order.customerNama,
      telepon: initial.order.customerTelepon,
    );
    _items.addAll(
      initial.items.map(
        (line) => NewOrderItem(
          serviceId: line.serviceId,
          namaLayanan: line.namaLayanan,
          qtyMilli: line.qtyMilli,
          hargaSatuan: line.hargaSatuan,
          satuan: line.satuan,
        ),
      ),
    );
    _notes.text = initial.order.catatan ?? '';
    _estimasi = initial.order.estimasiSelesai ?? _defaultEstimasi();
    _diskon = initial.order.diskon;
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  DateTime _defaultEstimasi() {
    final target = DateTime.now().add(const Duration(days: 2));
    return DateTime(target.year, target.month, target.day, 17);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Ubah order' : 'Order baru')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _CustomerCard(
            customer: _customer,
            onPick: _pickCustomer,
            onCreate: _createCustomer,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text('Layanan', style: theme.textTheme.titleMedium),
              ),
              if (_items.isNotEmpty)
                Text(
                  '${_items.length} item',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (_items.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Belum ada layanan. Tambahkan minimal satu layanan.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          for (var index = 0; index < _items.length; index++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ItemCard(
                item: _items[index],
                onTap: () => _editItem(index),
                onRemove: () => setState(() => _items.removeAt(index)),
              ),
            ),
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
            label: const Text('Tambah layanan'),
          ),
          const SizedBox(height: 24),
          Text('Detail', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.event_outlined),
                  title: const Text('Estimasi selesai'),
                  subtitle: Text(formatTanggalJam(_estimasi)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _pickDate,
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: TextField(
                    controller: _notes,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Catatan (opsional)',
                      hintText: 'Contoh: noda di kerah',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _TotalCard(subtotal: _subtotal, diskon: _diskon, total: _total),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      Rupiah.format(_total),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isEdit ? 'Simpan perubahan' : 'Simpan order'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickCustomer() async {
    final result = await showModalBottomSheet<CustomerPickResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const CustomerPickerSheet(),
    );
    if (result == null || !mounted) {
      return;
    }
    if (result.createNew) {
      await _createCustomer();
      return;
    }
    final customer = result.customer;
    if (customer != null) {
      setState(() => _customer = customer);
    }
  }

  Future<void> _createCustomer() async {
    final id = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const CustomerFormSheet(),
    );
    if (id == null || !mounted) {
      return;
    }
    final customer = await ref.read(customerRepositoryProvider).getById(id);
    if (customer != null && mounted) {
      setState(() => _customer = customer);
    }
  }

  Future<void> _addItem() async {
    final service = await showModalBottomSheet<LaundryService>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const ServicePickerSheet(),
    );
    if (service == null || !mounted) {
      return;
    }

    final milli = await showDialog<int>(
      context: context,
      builder: (_) => QuantityDialog(
        namaLayanan: service.nama,
        satuanLabel: service.satuan.label,
        hargaSatuan: service.harga,
      ),
    );
    if (milli == null || !mounted) {
      return;
    }

    setState(() {
      _items.add(
        NewOrderItem(
          serviceId: service.id,
          namaLayanan: service.nama,
          qtyMilli: milli,
          hargaSatuan: service.harga,
          satuan: service.satuan,
        ),
      );
    });
  }

  Future<void> _editItem(int index) async {
    final item = _items[index];
    final milli = await showDialog<int>(
      context: context,
      builder: (_) => QuantityDialog(
        namaLayanan: item.namaLayanan,
        satuanLabel: item.satuan?.label ?? '',
        hargaSatuan: item.hargaSatuan,
        initialMilli: item.qtyMilli,
      ),
    );
    if (milli == null || !mounted) {
      return;
    }
    setState(() {
      _items[index] = NewOrderItem(
        serviceId: item.serviceId,
        namaLayanan: item.namaLayanan,
        qtyMilli: milli,
        hargaSatuan: item.hargaSatuan,
        satuan: item.satuan,
      );
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _estimasi,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
      helpText: 'Estimasi selesai',
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      _estimasi = DateTime(picked.year, picked.month, picked.day, 17);
    });
  }

  Future<void> _save() async {
    final customer = _customer;
    if (customer == null) {
      _showMessage('Pilih pelanggan dulu.');
      return;
    }
    if (_items.isEmpty) {
      _showMessage('Tambahkan minimal satu layanan.');
      return;
    }

    setState(() => _saving = true);
    try {
      final repository = ref.read(orderRepositoryProvider);
      final int savedId;
      if (_isEdit) {
        savedId = widget.initial!.order.id;
        await repository.update(
          id: savedId,
          customerId: customer.id,
          items: _items,
          estimasiSelesai: _estimasi,
          catatan: _notes.text,
          diskon: _diskon,
        );
      } else {
        savedId = await repository.create(
          customerId: customer.id,
          items: _items,
          estimasiSelesai: _estimasi,
          catatan: _notes.text,
          diskon: _diskon,
        );
      }

      ref.invalidate(orderDetailProvider(savedId));
      invalidateOrderViews(ref);
      if (!mounted) {
        return;
      }
      if (_isEdit) {
        context.pop(true);
      } else {
        context.pushReplacement(AppRoutes.orderDetail(savedId));
      }
    } on OrderException catch (error) {
      _showMessage(error.message);
    } on Exception {
      _showMessage('Gagal menyimpan order.');
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({
    required this.customer,
    required this.onPick,
    required this.onCreate,
  });

  final Customer? customer;
  final VoidCallback onPick;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onPick,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.secondaryContainer,
          foregroundColor: theme.colorScheme.onSecondaryContainer,
          child: Icon(customer == null ? Icons.person_outline : Icons.person),
        ),
        title: Text(
          customer?.nama ?? 'Pilih pelanggan',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          customer == null
              ? 'Wajib diisi sebelum menyimpan'
              : PhoneNumber.display(customer!.telepon),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.person_add_alt),
          tooltip: 'Pelanggan baru',
          onPressed: onCreate,
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.item,
    required this.onTap,
    required this.onRemove,
  });

  final NewOrderItem item;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final satuan = item.satuan?.label;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.only(left: 16, right: 4),
        title: Row(
          children: [
            Expanded(
              child: Text(
                item.namaLayanan,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              Rupiah.format(item.subtotal),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        subtitle: Text(
          '${Quantity.format(item.qtyMilli, unit: satuan)} × '
          '${Rupiah.format(item.hargaSatuan)}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Hapus layanan',
          onPressed: onRemove,
        ),
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({
    required this.subtotal,
    required this.diskon,
    required this.total,
  });

  final int subtotal;
  final int diskon;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row(theme, 'Subtotal', Rupiah.format(subtotal)),
            if (diskon > 0) ...[
              const SizedBox(height: 8),
              _row(theme, 'Diskon', '- ${Rupiah.format(diskon)}'),
            ],
            const Divider(height: 24),
            _row(theme, 'Total', Rupiah.format(total), bold: true),
          ],
        ),
      ),
    );
  }

  Widget _row(
    ThemeData theme,
    String label,
    String value, {
    bool bold = false,
  }) {
    final style = bold
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
        : theme.textTheme.bodyMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}
