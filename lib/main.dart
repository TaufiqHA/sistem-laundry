import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/app.dart';
import 'package:sistem_manajemen_laundry/core/logging/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppLogger.init();
  AppLogger.installGlobalHandlers();

  runApp(const ProviderScope(child: LaundryApp()));
}
