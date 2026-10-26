import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sistem_manajemen_laundry/core/l10n/app_strings.dart';
import 'package:sistem_manajemen_laundry/core/router/app_router.dart';
import 'package:sistem_manajemen_laundry/core/theme/app_theme.dart';
import 'package:sistem_manajemen_laundry/core/theme/theme_provider.dart';

class LaundryApp extends ConsumerStatefulWidget {
  const LaundryApp({super.key, this.initialLocation = AppRoutes.home});

  final String initialLocation;

  @override
  ConsumerState<LaundryApp> createState() => _LaundryAppState();
}

class _LaundryAppState extends ConsumerState<LaundryApp> {
  // Router dibuat sekali agar state navigasi tidak hilang saat tema berubah.
  late final GoRouter _router = createRouter(
    initialLocation: widget.initialLocation,
  );

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: const Locale('id', 'ID'),
      supportedLocales: const [Locale('id', 'ID'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
    );
  }
}
