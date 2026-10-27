import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/features/backup/domain/backup_archive.dart';

class BackupService {
  BackupService(this._db);

  final AppDatabase _db;

  static const databaseName = 'laundry.sqlite';
  static const _maxBackups = 5;

  Future<Directory> _documents() => getApplicationDocumentsDirectory();

  Future<String> databasePath() async {
    final documents = await _documents();
    return '${documents.path}/$databaseName';
  }

  Future<Directory> _backupDirectory() async {
    final documents = await _documents();
    final directory = Directory('${documents.path}/backups');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return directory;
  }

  /// Membaca database setelah WAL di-checkpoint, lalu membungkusnya jadi
  /// arsip. File juga disimpan di folder `backups` agar ada salinan lokal.
  Future<File> createBackupFile({
    required int schemaVersion,
    required int orderCount,
    required int customerCount,
    DateTime? createdAt,
  }) async {
    await _db.customSelect('PRAGMA wal_checkpoint(TRUNCATE)').get();

    final databaseFile = File(await databasePath());
    if (!databaseFile.existsSync()) {
      throw StateError('Database belum terbentuk.');
    }

    final databaseBytes = await databaseFile.readAsBytes();
    final archiveBytes = BackupArchive.create(
      database: databaseBytes,
      schemaVersion: schemaVersion,
      orderCount: orderCount,
      customerCount: customerCount,
      createdAt: createdAt,
    );

    final directory = await _backupDirectory();
    final stamp = _timestamp(createdAt ?? DateTime.now());
    final file = File('${directory.path}/laundry-backup-$stamp.laundry');
    await file.writeAsBytes(archiveBytes, flush: true);
    await _prune(directory);
    return file;
  }

  Future<List<int>> readFileBytes(String path) async {
    return File(path).readAsBytes();
  }

  Future<List<File>> listLocalBackups() async {
    final directory = await _backupDirectory();
    final files =
        directory
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.laundry'))
            .toList()
          ..sort((a, b) => b.path.compareTo(a.path));
    return files;
  }

  Future<void> writeRestoredDatabase(List<int> bytes) async {
    final path = await databasePath();
    final temporary = File('$path.restore');
    await temporary.writeAsBytes(bytes, flush: true);

    try {
      await _db.close();
    } on Exception {
      // Koneksi mungkin sudah tertutup; penggantian file tetap dilanjutkan.
    }

    await temporary.rename(path);
    for (final suffix in ['-wal', '-shm']) {
      final sidecar = File('$path$suffix');
      if (sidecar.existsSync()) {
        sidecar.deleteSync();
      }
    }
  }

  Future<void> closeDatabase() async {
    try {
      await _db.close();
    } on Exception {
      // Sudah tertutup.
    }
  }

  Future<void> _prune(Directory directory) async {
    final files =
        directory
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.laundry'))
            .toList()
          ..sort((a, b) => b.path.compareTo(a.path));

    for (final file in files.skip(_maxBackups)) {
      try {
        file.deleteSync();
      } on FileSystemException {
        // Abaikan; salinan lama tidak wajib terhapus.
      }
    }
  }

  static String _timestamp(DateTime value) {
    final local = value.toLocal();
    String two(int number) => number.toString().padLeft(2, '0');
    return '${local.year}${two(local.month)}${two(local.day)}'
        '-${two(local.hour)}${two(local.minute)}';
  }
}
