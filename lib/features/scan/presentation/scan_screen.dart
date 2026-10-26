import 'package:flutter/material.dart';

import 'package:sistem_manajemen_laundry/core/l10n/app_strings.dart';
import 'package:sistem_manajemen_laundry/core/widgets/empty_state.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.scan)),
      body: const EmptyState(
        icon: Icons.qr_code_scanner,
        title: 'Pemindai belum aktif',
        message: AppStrings.scanEmpty,
      ),
    );
  }
}
