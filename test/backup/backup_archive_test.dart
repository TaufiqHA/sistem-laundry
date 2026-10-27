import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/features/backup/domain/backup_archive.dart';

void main() {
  final database = Uint8List.fromList([10, 20, 30, 40]);

  Uint8List validBackup({int schemaVersion = 1}) {
    return BackupArchive.create(
      database: database,
      schemaVersion: schemaVersion,
      orderCount: 12,
      customerCount: 4,
      createdAt: DateTime.utc(2026, 10, 27, 10, 30),
    );
  }

  test('arsip yang dibuat bisa dibaca kembali', () {
    final payload = BackupArchive.parse(validBackup(), currentSchemaVersion: 1);

    expect(payload.database, database);
    expect(payload.metadata.schemaVersion, 1);
    expect(payload.metadata.orderCount, 12);
    expect(payload.metadata.customerCount, 4);
    expect(payload.metadata.createdAt, DateTime.utc(2026, 10, 27, 10, 30));
    expect(payload.metadata.formatVersion, BackupArchive.formatVersion);
    expect(payload.metadata.checksum, sha256.convert(database).toString());
  });

  test('checksum yang tidak cocok ditolak', () {
    final original = ZipDecoder().decodeBytes(validBackup());
    final metaBytes = original.findFile('meta.json')!.content;
    final tampered = Archive()
      ..addFile(ArchiveFile.bytes('laundry.sqlite', [1, 2, 3]))
      ..addFile(ArchiveFile.bytes('meta.json', metaBytes));

    expect(
      () => BackupArchive.parse(
        Uint8List.fromList(ZipEncoder().encode(tampered)),
        currentSchemaVersion: 1,
      ),
      throwsA(isA<BackupException>()),
    );
  });

  test('skema lebih baru ditolak', () {
    expect(
      () => BackupArchive.parse(
        validBackup(schemaVersion: 5),
        currentSchemaVersion: 1,
      ),
      throwsA(
        isA<BackupException>().having(
          (error) => error.message,
          'pesan',
          contains('Skema backup lebih baru'),
        ),
      ),
    );
  });

  test('format arsip lebih baru ditolak', () {
    final meta = {
      'format_version': 9,
      'schema_version': 1,
      'created_at': DateTime.utc(2026, 10, 27).toIso8601String(),
      'order_count': 1,
      'customer_count': 1,
      'checksum': sha256.convert(database).toString(),
    };
    final archive = Archive()
      ..addFile(ArchiveFile.bytes('laundry.sqlite', database))
      ..addFile(ArchiveFile.bytes('meta.json', utf8.encode(jsonEncode(meta))));

    expect(
      () => BackupArchive.parse(
        Uint8List.fromList(ZipEncoder().encode(archive)),
        currentSchemaVersion: 1,
      ),
      throwsA(
        isA<BackupException>().having(
          (error) => error.message,
          'pesan',
          contains('versi lebih baru'),
        ),
      ),
    );
  });

  test('file acak dan arsip tanpa database ditolak', () {
    expect(
      () => BackupArchive.parse(
        Uint8List.fromList([1, 2, 3, 4]),
        currentSchemaVersion: 1,
      ),
      throwsA(isA<BackupException>()),
    );

    final incomplete = Archive()
      ..addFile(ArchiveFile.bytes('meta.json', utf8.encode('{}')));
    expect(
      () => BackupArchive.parse(
        Uint8List.fromList(ZipEncoder().encode(incomplete)),
        currentSchemaVersion: 1,
      ),
      throwsA(isA<BackupException>()),
    );
  });
}
