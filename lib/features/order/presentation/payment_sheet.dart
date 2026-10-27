import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';
import 'package:sistem_manajemen_laundry/core/utils/tanggal.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/order_models.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment.dart';
import 'package:sistem_manajemen_laundry/features/order/domain/payment_method.dart';
import 'package:sistem_manajemen_laundry/features/order/presentation/payment_providers.dart';

class PaymentSheet extends ConsumerStatefulWidget {
  const PaymentSheet({required this.order, required this.sisa, super.key});

  final LaundryOrder order;
  final int sisa;

  @override
  ConsumerState<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends ConsumerState<PaymentSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amount;
  final _notes = TextEditingController();
  PaymentMethod _method = PaymentMethod.tunai;
  late DateTime _date;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _amount = TextEditingController(text: Rupiah.formatPlain(widget.sisa));
    _date = DateTime.now();
  }

  @override
  void dispose() {
    _amount.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Catat pembayaran', style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                '${widget.order.nomorNota} · sisa ${Rupiah.format(widget.sisa)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amount,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Jumlah dibayar',
                  prefixText: 'Rp ',
                ),
                validator: (value) {
                  final amount = Rupiah.parse(value ?? '');
                  if (amount == null || amount <= 0) {
                    return 'Jumlah tidak valid';
                  }
                  if (amount > widget.sisa) {
                    return 'Melebihi sisa ${Rupiah.format(widget.sisa)}';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text('Metode', style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              SegmentedButton<PaymentMethod>(
                segments: [
                  for (final method in PaymentMethod.values)
                    ButtonSegment(value: method, label: Text(method.label)),
                ],
                selected: {_method},
                onSelectionChanged: (selection) {
                  setState(() => _method = selection.first);
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_outlined),
                title: const Text('Tanggal pembayaran'),
                subtitle: Text(formatTanggal(_date)),
                onTap: _pickDate,
              ),
              TextFormField(
                controller: _notes,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Simpan pembayaran'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final firstDate = widget.order.tanggalMasuk.toLocal();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(firstDate.year, firstDate.month, firstDate.day),
      lastDate: now,
      helpText: 'Tanggal pembayaran',
    );
    if (picked != null && mounted) {
      setState(() => _date = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final amount = Rupiah.parse(_amount.text);
    if (amount == null) {
      return;
    }

    setState(() => _saving = true);
    try {
      await ref
          .read(paymentRepositoryProvider)
          .add(
            orderId: widget.order.id,
            jumlah: amount,
            metode: _method,
            tanggal: _date,
            catatan: _notes.text,
          );
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } on PaymentException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan pembayaran.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}
