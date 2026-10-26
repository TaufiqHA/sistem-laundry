import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/features/settings/presentation/business_profile_form.dart';
import 'package:sistem_manajemen_laundry/features/settings/presentation/settings_providers.dart';

class BusinessProfilePage extends ConsumerWidget {
  const BusinessProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil usaha')),
      body: settings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Gagal memuat pengaturan.'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref.invalidate(settingsProvider),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
        data: (settings) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: BusinessProfileForm(
            initial: settings,
            submitLabel: 'Simpan perubahan',
            onSaved: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil usaha disimpan.')),
              );
              Navigator.of(context).maybePop();
            },
          ),
        ),
      ),
    );
  }
}
