import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/core/utils/phone_number.dart';
import 'package:sistem_manajemen_laundry/features/customer/domain/customer.dart';
import 'package:sistem_manajemen_laundry/features/customer/presentation/customer_providers.dart';

class CustomerFormSheet extends ConsumerStatefulWidget {
  const CustomerFormSheet({super.key, this.customer});

  final Customer? customer;

  @override
  ConsumerState<CustomerFormSheet> createState() => _CustomerFormSheetState();
}

class _CustomerFormSheetState extends ConsumerState<CustomerFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late final TextEditingController _notes;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final customer = widget.customer;
    _name = TextEditingController(text: customer?.nama ?? '');
    _phone = TextEditingController(
      text: customer == null ? '' : PhoneNumber.display(customer.telepon),
    );
    _address = TextEditingController(text: customer?.alamat ?? '');
    _notes = TextEditingController(text: customer?.catatan ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      final repository = ref.read(customerRepositoryProvider);
      final duplicate = await repository.findByPhone(
        _phone.text,
        exceptId: widget.customer?.id,
      );

      if (duplicate != null && mounted) {
        final proceed = await _confirmDuplicate(duplicate);
        if (proceed != true) {
          return;
        }
      }

      if (!mounted) {
        return;
      }
      setState(() => _saving = true);

      final int savedId;
      if (widget.customer == null) {
        savedId = await repository.create(
          nama: _name.text,
          telepon: _phone.text,
          alamat: _address.text,
          catatan: _notes.text,
        );
      } else {
        savedId = widget.customer!.id;
        await repository.update(
          id: widget.customer!.id,
          nama: _name.text,
          telepon: _phone.text,
          alamat: _address.text,
          catatan: _notes.text,
        );
      }
      if (mounted) {
        Navigator.of(context).pop(savedId);
      }
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan pelanggan.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<bool?> _confirmDuplicate(Customer duplicate) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Nomor sudah terdaftar'),
        content: Text(
          'Nomor ini sudah dipakai oleh ${duplicate.nama}. '
          'Tetap simpan sebagai pelanggan terpisah?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Tetap simpan'),
          ),
        ],
      ),
    );
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
              Text(
                widget.customer == null ? 'Tambah pelanggan' : 'Ubah pelanggan',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _name,
                autofocus: widget.customer == null,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Contoh: Ibu Sari',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }
                  if (value.trim().length > 80) {
                    return 'Maksimal 80 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s()]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Nomor telepon',
                  hintText: '0812 3456 7890',
                ),
                validator: PhoneNumber.validate,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _address,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Alamat (opsional)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notes,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                  hintText: 'Contoh: langganan mingguan, antar-jemput',
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
