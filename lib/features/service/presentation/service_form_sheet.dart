import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/core/utils/rupiah.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/laundry_service.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';
import 'package:sistem_manajemen_laundry/features/service/presentation/service_providers.dart';

class ServiceFormSheet extends ConsumerStatefulWidget {
  const ServiceFormSheet({super.key, this.service});

  final LaundryService? service;

  @override
  ConsumerState<ServiceFormSheet> createState() => _ServiceFormSheetState();
}

class _ServiceFormSheetState extends ConsumerState<ServiceFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _category;
  late final TextEditingController _price;
  late ServiceUnit _unit;
  String? _nameError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final service = widget.service;
    _name = TextEditingController(text: service?.nama ?? '');
    _category = TextEditingController(text: service?.kategori ?? '');
    _price = TextEditingController(
      text: service == null ? '' : Rupiah.formatPlain(service.harga),
    );
    _unit = service?.satuan ?? ServiceUnit.kg;
  }

  @override
  void dispose() {
    _name.dispose();
    _category.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    try {
      final repository = ref.read(serviceRepositoryProvider);
      final name = _name.text.trim();
      final taken = await repository.isNameTaken(
        name,
        exceptId: widget.service?.id,
      );
      if (taken) {
        setState(() {
          _nameError = 'Nama layanan sudah dipakai';
          _saving = false;
        });
        return;
      }

      final price = Rupiah.parse(_price.text)!;
      if (widget.service == null) {
        await repository.create(
          nama: name,
          satuan: _unit,
          harga: price,
          kategori: _category.text,
        );
      } else {
        await repository.update(
          id: widget.service!.id,
          nama: name,
          satuan: _unit,
          harga: price,
          kategori: _category.text,
        );
      }
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } on Exception {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan layanan.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
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
                widget.service == null ? 'Tambah layanan' : 'Ubah layanan',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _name,
                autofocus: widget.service == null,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Nama layanan',
                  hintText: 'Contoh: Cuci Setrika',
                  errorText: _nameError,
                ),
                onChanged: (_) {
                  if (_nameError != null) {
                    setState(() => _nameError = null);
                  }
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama layanan wajib diisi';
                  }
                  if (value.trim().length > 80) {
                    return 'Maksimal 80 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _category,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Kategori (opsional)',
                  hintText: 'Contoh: Cuci Kering atau Ekspres',
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final category in const [
                    'Cuci Kering',
                    'Cuci Setrika',
                    'Setrika Saja',
                    'Selimut',
                    'Ekspres',
                  ])
                    ActionChip(
                      label: Text(category),
                      onPressed: () =>
                          setState(() => _category.text = category),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Satuan', style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              SegmentedButton<ServiceUnit>(
                segments: [
                  for (final unit in ServiceUnit.values)
                    ButtonSegment(value: unit, label: Text(unit.label)),
                ],
                selected: {_unit},
                onSelectionChanged: (selection) {
                  setState(() => _unit = selection.first);
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _price,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: InputDecoration(
                  labelText: 'Harga per ${_unit.label}',
                  prefixText: 'Rp ',
                ),
                validator: (value) {
                  final amount = Rupiah.parse(value ?? '');
                  if (amount == null) {
                    return 'Harga tidak valid';
                  }
                  if (amount <= 0) {
                    return 'Harga harus lebih dari 0';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _submit(),
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
