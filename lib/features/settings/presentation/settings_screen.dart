import 'package:flutter/material.dart';

import 'package:sistem_manajemen_laundry/core/l10n/app_strings.dart';
import 'package:sistem_manajemen_laundry/core/widgets/empty_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.navSettings)),
      body: const EmptyState(
        icon: Icons.settings_outlined,
        title: 'Pengaturan belum tersedia',
        message: AppStrings.settingsEmpty,
      ),
    );
  }
}
