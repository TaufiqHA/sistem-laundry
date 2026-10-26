import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Log lokal sederhana. Aplikasi tidak punya server, jadi satu-satunya
/// cara menelusuri masalah di perangkat pengguna adalah file ini.
abstract final class AppLogger {
  static const _maxBytes = 512 * 1024;
  static File? _file;

  static Future<void> init() async {
    try {
      final support = await getApplicationSupportDirectory();
      final directory = Directory('${support.path}/logs');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      final file = File('${directory.path}/app.log');
      _rotateIfNeeded(file);
      _file = file;
    } on Exception catch (error) {
      debugPrint('AppLogger tidak aktif: $error');
    }
  }

  static void _rotateIfNeeded(File file) {
    if (file.existsSync() && file.lengthSync() > _maxBytes) {
      final old = File('${file.path}.1');
      if (old.existsSync()) {
        old.deleteSync();
      }
      file.renameSync(old.path);
    }
  }

  static void log(String message, {Object? error, StackTrace? stack}) {
    final line = StringBuffer()
      ..write(DateTime.now().toIso8601String())
      ..write('  ')
      ..write(message);
    if (error != null) {
      line.write('\n  error: $error');
    }
    if (stack != null) {
      line.write('\n$stack');
    }
    debugPrint(line.toString());

    final file = _file;
    if (file == null) {
      return;
    }
    try {
      file.writeAsStringSync('$line\n', mode: FileMode.append);
    } on FileSystemException {
      // Menulis log tidak boleh menjatuhkan aplikasi.
    }
  }

  /// Menangkap error yang tidak tertangani supaya tercatat sebelum
  /// aplikasi tertutup.
  static void installGlobalHandlers() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      log('FlutterError', error: details.exception, stack: details.stack);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      log('Uncaught', error: error, stack: stack);
      return true;
    };
  }
}
