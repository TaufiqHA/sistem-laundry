import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/router/app_router.dart';
import 'package:sistem_manajemen_laundry/features/settings/domain/app_settings.dart';
import 'package:sistem_manajemen_laundry/features/settings/presentation/business_profile_form.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          children: [
            Icon(
              Icons.local_laundry_service,
              size: 56,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Atur usaha Anda',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Data ini dipakai di nota dan kepala struk. Bisa diubah kapan saja.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            BusinessProfileForm(
              initial: const AppSettings(),
              submitLabel: 'Simpan dan mulai',
              onSaved: () => context.go(AppRoutes.home),
              onSkip: () => context.go(AppRoutes.home),
            ),
          ],
        ),
      ),
    );
  }
}
