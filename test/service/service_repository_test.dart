import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/core/database/app_database.dart';
import 'package:sistem_manajemen_laundry/features/service/data/service_repository.dart';
import 'package:sistem_manajemen_laundry/features/service/domain/service_unit.dart';

void main() {
  late AppDatabase db;
  late ServiceRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = ServiceRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('membuat layanan dan membacanya kembali', () async {
    final id = await repository.create(
      nama: 'Cuci Kering',
      satuan: ServiceUnit.kg,
      harga: 7000,
    );

    final services = await repository.list();
    expect(services, hasLength(1));
    expect(services.single.id, id);
    expect(services.single.nama, 'Cuci Kering');
    expect(services.single.satuan, ServiceUnit.kg);
    expect(services.single.harga, 7000);
    expect(services.single.aktif, isTrue);
  });

  test('daftar untuk order hanya berisi layanan aktif', () async {
    final aktif = await repository.create(
      nama: 'Cuci Setrika',
      satuan: ServiceUnit.kg,
      harga: 9000,
    );
    final nonaktif = await repository.create(
      nama: 'Selimut',
      satuan: ServiceUnit.pcs,
      harga: 15000,
    );
    await repository.setActive(nonaktif, aktif: false);

    final forOrder = await repository.list(includeInactive: false);
    final forManagement = await repository.list();

    expect(forOrder.map((service) => service.id), [aktif]);
    expect(forManagement, hasLength(2));
  });

  test('mengubah nama, satuan, dan harga', () async {
    final id = await repository.create(
      nama: 'Setrika',
      satuan: ServiceUnit.kg,
      harga: 5000,
    );

    await repository.update(
      id: id,
      nama: 'Setrika Saja',
      satuan: ServiceUnit.pcs,
      harga: 6000,
    );

    final service = (await repository.list()).single;
    expect(service.nama, 'Setrika Saja');
    expect(service.satuan, ServiceUnit.pcs);
    expect(service.harga, 6000);
  });

  test('nama layanan dianggap sama tanpa peduli huruf besar/kecil', () async {
    await repository.create(
      nama: 'Cuci Kering',
      satuan: ServiceUnit.kg,
      harga: 7000,
    );

    expect(await repository.isNameTaken('cuci kering'), isTrue);
    expect(await repository.isNameTaken('  CUCI KERING  '), isTrue);
    expect(await repository.isNameTaken('Cuci Setrika'), isFalse);
  });

  test('nama sendiri tidak dihitung duplikat saat mengubah', () async {
    final id = await repository.create(
      nama: 'Cuci Kering',
      satuan: ServiceUnit.kg,
      harga: 7000,
    );

    expect(await repository.isNameTaken('Cuci Kering', exceptId: id), isFalse);
  });

  test('menonaktifkan layanan tidak menghapus riwayatnya', () async {
    final id = await repository.create(
      nama: 'Selimut',
      satuan: ServiceUnit.pcs,
      harga: 15000,
    );

    await repository.setActive(id, aktif: false);

    final rows = await db.select(db.services).get();
    expect(rows, hasLength(1));
    expect(rows.single.aktif, isFalse);
  });
}
