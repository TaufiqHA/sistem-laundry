import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/features/security/domain/pin_hasher.dart';
import 'package:sistem_manajemen_laundry/features/security/presentation/security_providers.dart';

Future<bool> showPinSetupDialog(BuildContext context) async {
  final saved = await showDialog<bool>(
    context: context,
    builder: (_) => const _PinSetupDialog(),
  );
  return saved ?? false;
}

Future<bool> showPinDisableDialog(BuildContext context) async {
  final removed = await showDialog<bool>(
    context: context,
    builder: (_) => const _PinDisableDialog(),
  );
  return removed ?? false;
}

class _PinSetupDialog extends ConsumerStatefulWidget {
  const _PinSetupDialog();

  @override
  ConsumerState<_PinSetupDialog> createState() => _PinSetupDialogState();
}

class _PinSetupDialogState extends ConsumerState<_PinSetupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _pin = TextEditingController();
  final _confirm = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _pin.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(securityRepositoryProvider).setPin(_pin.text);
      ref.read(lockControllerProvider.notifier).unlock();
      ref.invalidate(hasPinProvider);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } on Exception {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Aktifkan PIN'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PinField(
              controller: _pin,
              label: 'PIN baru',
              validator: (value) {
                final error = PinHasher.validate(value ?? '');
                return error;
              },
            ),
            const SizedBox(height: 12),
            _PinField(
              controller: _confirm,
              label: 'Ulangi PIN',
              validator: (value) {
                if (value != _pin.text) {
                  return 'PIN tidak sama';
                }
                return PinHasher.validate(value ?? '');
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}

class _PinDisableDialog extends ConsumerStatefulWidget {
  const _PinDisableDialog();

  @override
  ConsumerState<_PinDisableDialog> createState() => _PinDisableDialogState();
}

class _PinDisableDialogState extends ConsumerState<_PinDisableDialog> {
  final _pin = TextEditingController();
  String? _error;
  bool _checking = false;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _disable() async {
    setState(() => _checking = true);
    final valid = await ref
        .read(securityRepositoryProvider)
        .verifyPin(_pin.text);
    if (!mounted) {
      return;
    }
    if (!valid) {
      setState(() {
        _checking = false;
        _error = 'PIN salah';
      });
      return;
    }

    await ref.read(securityRepositoryProvider).clearPin();
    ref.invalidate(hasPinProvider);
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nonaktifkan PIN'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Masukkan PIN saat ini untuk mematikan kunci aplikasi.'),
          const SizedBox(height: 12),
          _PinField(
            controller: _pin,
            label: 'PIN saat ini',
            errorText: _error,
            onChanged: () {
              if (_error != null) {
                setState(() => _error = null);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: _checking ? null : _disable,
          child: const Text('Nonaktifkan'),
        ),
      ],
    );
  }
}

class _PinField extends StatelessWidget {
  const _PinField({
    required this.controller,
    required this.label,
    this.validator,
    this.errorText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final String? errorText;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: true,
      obscureText: true,
      keyboardType: TextInputType.number,
      maxLength: 6,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(6),
      ],
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
        errorText: errorText,
      ),
      onChanged: onChanged == null ? null : (_) => onChanged!(),
      validator: validator,
    );
  }
}
