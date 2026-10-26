import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/core/utils/phone_number.dart';
import 'package:sistem_manajemen_laundry/core/utils/quantity.dart';
import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';
import 'package:sistem_manajemen_laundry/features/customer/domain/customer.dart';
import 'package:sistem_manajemen_laundry/features/customer/presentation/customer_providers.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/order_providers.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/laundry_service.dart';

/// Hasil pemilihan pelanggan: memilih yang ada, atau minta buat baru.
typedef CustomerPickResult = ({Customer? customer, bool createNew});

class CustomerPickerSheet extends ConsumerStatefulWidget {
  const CustomerPickerSheet({super.key});

  @override
  ConsumerState<CustomerPickerSheet> createState() =>
      _CustomerPickerSheetState();
}

class _CustomerPickerSheetState extends ConsumerState<CustomerPickerSheet> {
  final _search = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerSearchProvider(_query));

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _search,
              autofocus: false,
              decoration: const InputDecoration(
                hintText: 'Cari nama atau telepon',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  if (mounted) {
                    setState(() => _query = value.trim());
                  }
                });
              },
            ),
          ),
          Expanded(
            child: customers.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  const Center(child: Text('Gagal memuat pelanggan.')),
              data: (customers) {
                if (customers.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Tidak ada pelanggan yang cocok.'),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  itemCount: customers.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(customer.initial)),
                      title: Text(customer.nama),
                      subtitle: Text(PhoneNumber.display(customer.telepon)),
                      onTap: () =>
                          Navigator.of(context)
                              .pop((customer: customer, createNew: false)),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () =>
                      Navigator.of(context)
                          .pop((customer: null, createNew: true)),
                  icon: const Icon(Icons.person_add_alt),
                  label: const Text('Pelanggan baru'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServicePickerSheet extends ConsumerWidget {
  const ServicePickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(activeServicesProvider);

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: services.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            const Center(child: Text('Gagal memuat layanan.')),
        data: (services) {
          if (services.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Belum ada layanan aktif. Tambahkan lewat Pengaturan.',
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            itemCount: services.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final service = services[index];
              return ListTile(
                title: Text(service.nama),
                subtitle: Text(
                  '${Rupiah.format(service.harga)} / ${service.satuan.label}',
                ),
                trailing: const Icon(Icons.add),
                onTap: () => Navigator.of(context).pop<LaundryService>(service),
              );
            },
          );
        },
      ),
    );
  }
}

class QuantityDialog extends StatefulWidget {
  const QuantityDialog({
    required this.namaLayanan,
    required this.satuanLabel,
    required this.hargaSatuan,
    super.key,
    this.initialMilli,
  });

  final String namaLayanan;
  final String satuanLabel;
  final int hargaSatuan;
  final int? initialMilli;

  @override
  State<QuantityDialog> createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  late final TextEditingController _qty;
  String? _error;

  @override
  void initState() {
    super.initState();
    _qty = TextEditingController(
      text: Quantity.format(widget.initialMilli ?? 1000),
    );
  }

  @override
  void dispose() {
    _qty.dispose();
    super.dispose();
  }

  int? get _milli => Quantity.parse(_qty.text);

  int get _subtotal {
    final milli = _milli;
    if (milli == null || milli <= 0) {
      return 0;
    }
    return (milli * widget.hargaSatuan + 500) ~/ 1000;
  }

  void _submit() {
    final milli = _milli;
    if (milli == null || milli <= 0) {
      setState(() => _error = 'Jumlah tidak valid');
      return;
    }
    Navigator.of(context).pop(milli);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.namaLayanan),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${Rupiah.format(widget.hargaSatuan)} / ${widget.satuanLabel}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _qty,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Jumlah',
              suffixText: widget.satuanLabel,
              errorText: _error,
            ),
            onChanged: (_) => setState(() => _error = null),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          Text(
            'Subtotal ${Rupiah.format(_subtotal)}',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Tambahkan')),
      ],
    );
  }
}
