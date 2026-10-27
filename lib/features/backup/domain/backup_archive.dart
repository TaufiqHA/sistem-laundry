import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';

class BackupMetadata {
  const BackupMetadata({
    required this.formatVersion,
    required this.schemaVersion,
    required this.createdAt,
    required this.orderCount,
    required this.customerCount,
    required this.checksum,
  });

  factory BackupMetadata.fromJson(Map<String, dynamic> json) {
    return BackupMetadata(
      formatVersion: json['format_version'] as int,
      schemaVersion: json['schema_version'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      orderCount: json['order_count'] as int,
      customerCount: json['customer_count'] as int,
      checksum: json['checksum'] as String,
    );
  }

  final int formatVersion;
  final int schemaVersion;
  final DateTime createdAt;
  final int orderCount;
  final int customerCount;

  /// SHA-256 isi database, untuk mendeteksi file rusak.
  final String checksum;

  Map<String, dynamic> toJson() {
    return {
      'format_version': formatVersion,
      'schema_version': schemaVersion,
      'created_at': createdAt.toIso8601String(),
      'order_count': orderCount,
      'customer_count': customerCount,
      'checksum': checksum,
    };
  }
}

class BackupPayload {
  const BackupPayload({required this.metadata, required this.database});

  final BackupMetadata metadata;
  final Uint8List database;
}

class BackupException implements Exception {
  BackupException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Format arsip backup: ZIP berisi `laundry.sqlite` dan `meta.json`.
/// Fungsi di sini murni (tanpa file/plugin), jadi bisa diuji tanpa perangkat.
abstract final class BackupArchive {
  static const formatVersion = 1;
  static const _dbEntry = 'laundry.sqlite';
  static const _metaEntry = 'meta.json';

  static Uint8List create({
    required List<int> database,
    required int schemaVersion,
    required int orderCount,
    required int customerCount,
    DateTime? createdAt,
  }) {
    final databaseBytes = Uint8List.fromList(database);
    final metadata = BackupMetadata(
      formatVersion: formatVersion,
      schemaVersion: schemaVersion,
      createdAt: (createdAt ?? DateTime.now()).toUtc(),
      orderCount: orderCount,
      customerCount: customerCount,
      checksum: sha256.convert(databaseBytes).toString(),
    );

    final metaBytes = utf8.encode(jsonEncode(metadata.toJson()));
    final archive = Archive()
      ..addFile(ArchiveFile.bytes(_dbEntry, databaseBytes))
      ..addFile(ArchiveFile.bytes(_metaEntry, metaBytes));

    return Uint8List.fromList(ZipEncoder().encode(archive));
  }

  static BackupPayload parse(
    Uint8List bytes, {
    required int currentSchemaVersion,
  }) {
    final Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } on Exception {
      throw BackupException('File bukan arsip backup.');
    }

    final dbFile = archive.findFile(_dbEntry);
    final metaFile = archive.findFile(_metaEntry);
    if (dbFile == null || metaFile == null) {
      throw BackupException(
        'File backup tidak lengkap. Pastikan memilih file .laundry.',
      );
    }

    final BackupMetadata metadata;
    try {
      metadata = BackupMetadata.fromJson(
        jsonDecode(utf8.decode(metaFile.content)) as Map<String, dynamic>,
      );
    } on Exception {
      throw BackupException('Metadata backup tidak bisa dibaca.');
    }

    if (metadata.formatVersion > formatVersion) {
      throw BackupException(
        'Backup dibuat aplikasi versi lebih baru. Perbarui aplikasi dulu.',
      );
    }
    if (metadata.schemaVersion > currentSchemaVersion) {
      throw BackupException(
        'Skema backup lebih baru dari aplikasi ini. Perbarui aplikasi dulu.',
      );
    }

    final databaseBytes = Uint8List.fromList(dbFile.content);
    final checksum = sha256.convert(databaseBytes).toString();
    if (checksum != metadata.checksum) {
      throw BackupException(
        'File backup rusak: checksum tidak cocok. Minta salinan lain.',
      );
    }

    return BackupPayload(metadata: metadata, database: databaseBytes);
  }
}
