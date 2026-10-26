import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/core/logging/app_logger.dart';
import 'package:sistem_manajemen_laundry/features/settings/domain/app_settings.dart';
import 'package:sistem_manajemen_laundry/features/settings/presentation/settings_providers.dart';

/// Form identitas usaha, dipakai wizard pertama kali dan halaman ubah profil.
class BusinessProfileForm extends ConsumerStatefulWidget {
  const BusinessProfileForm({
    required this.initial,
    required this.submitLabel,
    required this.onSaved,
    super.key,
    this.onSkip,
  });

  final AppSettings initial;
  final String submitLabel;
  final VoidCallback onSaved;
  final VoidCallback? onSkip;

  @override
  ConsumerState<BusinessProfileForm> createState() =>
      _BusinessProfileFormState();
}

class _BusinessProfileFormState extends ConsumerState<BusinessProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late final TextEditingController _footer;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.initial.businessName);
    _phone = TextEditingController(text: widget.initial.businessPhone);
    _address = TextEditingController(text: widget.initial.businessAddress);
    _footer = TextEditingController(text: widget.initial.receiptFooter);
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _footer.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    try {
      final repository = ref.read(settingsRepositoryProvider);
      await repository.saveBusiness(
        name: _name.text,
        phone: _phone.text,
        address: _address.text,
        receiptFooter: _footer.text,
      );
      await repository.completeOnboarding();
      ref.invalidate(settingsProvider);
      if (mounted) {
        widget.onSaved();
      }
    } on Exception catch (error, stack) {
      AppLogger.log('Gagal menyimpan profil usaha', error: error, stack: stack);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan. Coba lagi.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _skip() async {
    await ref.read(settingsRepositoryProvider).completeOnboarding();
    ref.invalidate(settingsProvider);
    widget.onSkip?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _name,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Nama usaha',
              hintText: 'Contoh: Laundry Bersih',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nama usaha wajib diisi';
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
              labelText: 'Nomor telepon (opsional)',
              hintText: '08xx xxxx xxxx',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _address,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Alamat (opsional)'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _footer,
            textCapitalization: TextCapitalization.sentences,
            maxLength: 120,
            decoration: const InputDecoration(
              labelText: 'Footer nota (opsional)',
              hintText: 'Contoh: Terima kasih, cucian diambil maksimal 7 hari',
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _saving ? null : _submit,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.submitLabel),
          ),
          if (widget.onSkip != null) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: _saving ? null : _skip,
              child: const Text('Isi nanti'),
            ),
            Text(
              'Nama usaha bisa diisi nanti lewat Pengaturan.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
