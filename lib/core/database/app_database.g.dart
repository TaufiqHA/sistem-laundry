// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, CustomerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teleponMeta = const VerificationMeta(
    'telepon',
  );
  @override
  late final GeneratedColumn<String> telepon = GeneratedColumn<String>(
    'telepon',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alamatMeta = const VerificationMeta('alamat');
  @override
  late final GeneratedColumn<String> alamat = GeneratedColumn<String>(
    'alamat',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _catatanMeta = const VerificationMeta(
    'catatan',
  );
  @override
  late final GeneratedColumn<String> catatan = GeneratedColumn<String>(
    'catatan',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 300),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _poinMeta = const VerificationMeta('poin');
  @override
  late final GeneratedColumn<int> poin = GeneratedColumn<int>(
    'poin',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dibuatPadaMeta = const VerificationMeta(
    'dibuatPada',
  );
  @override
  late final GeneratedColumn<DateTime> dibuatPada = GeneratedColumn<DateTime>(
    'dibuat_pada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nama,
    telepon,
    alamat,
    catatan,
    poin,
    dibuatPada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('telepon')) {
      context.handle(
        _teleponMeta,
        telepon.isAcceptableOrUnknown(data['telepon']!, _teleponMeta),
      );
    } else if (isInserting) {
      context.missing(_teleponMeta);
    }
    if (data.containsKey('alamat')) {
      context.handle(
        _alamatMeta,
        alamat.isAcceptableOrUnknown(data['alamat']!, _alamatMeta),
      );
    }
    if (data.containsKey('catatan')) {
      context.handle(
        _catatanMeta,
        catatan.isAcceptableOrUnknown(data['catatan']!, _catatanMeta),
      );
    }
    if (data.containsKey('poin')) {
      context.handle(
        _poinMeta,
        poin.isAcceptableOrUnknown(data['poin']!, _poinMeta),
      );
    }
    if (data.containsKey('dibuat_pada')) {
      context.handle(
        _dibuatPadaMeta,
        dibuatPada.isAcceptableOrUnknown(data['dibuat_pada']!, _dibuatPadaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      telepon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telepon'],
      )!,
      alamat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alamat'],
      ),
      catatan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catatan'],
      ),
      poin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}poin'],
      )!,
      dibuatPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dibuat_pada'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class CustomerRow extends DataClass implements Insertable<CustomerRow> {
  final int id;
  final String nama;

  /// Disimpan ternormalisasi (`628...`), dipakai untuk pencarian dan WhatsApp.
  final String telepon;
  final String? alamat;
  final String? catatan;
  final int poin;
  final DateTime dibuatPada;
  const CustomerRow({
    required this.id,
    required this.nama,
    required this.telepon,
    this.alamat,
    this.catatan,
    required this.poin,
    required this.dibuatPada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nama'] = Variable<String>(nama);
    map['telepon'] = Variable<String>(telepon);
    if (!nullToAbsent || alamat != null) {
      map['alamat'] = Variable<String>(alamat);
    }
    if (!nullToAbsent || catatan != null) {
      map['catatan'] = Variable<String>(catatan);
    }
    map['poin'] = Variable<int>(poin);
    map['dibuat_pada'] = Variable<DateTime>(dibuatPada);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      nama: Value(nama),
      telepon: Value(telepon),
      alamat: alamat == null && nullToAbsent
          ? const Value.absent()
          : Value(alamat),
      catatan: catatan == null && nullToAbsent
          ? const Value.absent()
          : Value(catatan),
      poin: Value(poin),
      dibuatPada: Value(dibuatPada),
    );
  }

  factory CustomerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerRow(
      id: serializer.fromJson<int>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      telepon: serializer.fromJson<String>(json['telepon']),
      alamat: serializer.fromJson<String?>(json['alamat']),
      catatan: serializer.fromJson<String?>(json['catatan']),
      poin: serializer.fromJson<int>(json['poin']),
      dibuatPada: serializer.fromJson<DateTime>(json['dibuatPada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nama': serializer.toJson<String>(nama),
      'telepon': serializer.toJson<String>(telepon),
      'alamat': serializer.toJson<String?>(alamat),
      'catatan': serializer.toJson<String?>(catatan),
      'poin': serializer.toJson<int>(poin),
      'dibuatPada': serializer.toJson<DateTime>(dibuatPada),
    };
  }

  CustomerRow copyWith({
    int? id,
    String? nama,
    String? telepon,
    Value<String?> alamat = const Value.absent(),
    Value<String?> catatan = const Value.absent(),
    int? poin,
    DateTime? dibuatPada,
  }) => CustomerRow(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    telepon: telepon ?? this.telepon,
    alamat: alamat.present ? alamat.value : this.alamat,
    catatan: catatan.present ? catatan.value : this.catatan,
    poin: poin ?? this.poin,
    dibuatPada: dibuatPada ?? this.dibuatPada,
  );
  CustomerRow copyWithCompanion(CustomersCompanion data) {
    return CustomerRow(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      telepon: data.telepon.present ? data.telepon.value : this.telepon,
      alamat: data.alamat.present ? data.alamat.value : this.alamat,
      catatan: data.catatan.present ? data.catatan.value : this.catatan,
      poin: data.poin.present ? data.poin.value : this.poin,
      dibuatPada: data.dibuatPada.present
          ? data.dibuatPada.value
          : this.dibuatPada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerRow(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('telepon: $telepon, ')
          ..write('alamat: $alamat, ')
          ..write('catatan: $catatan, ')
          ..write('poin: $poin, ')
          ..write('dibuatPada: $dibuatPada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nama, telepon, alamat, catatan, poin, dibuatPada);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerRow &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.telepon == this.telepon &&
          other.alamat == this.alamat &&
          other.catatan == this.catatan &&
          other.poin == this.poin &&
          other.dibuatPada == this.dibuatPada);
}

class CustomersCompanion extends UpdateCompanion<CustomerRow> {
  final Value<int> id;
  final Value<String> nama;
  final Value<String> telepon;
  final Value<String?> alamat;
  final Value<String?> catatan;
  final Value<int> poin;
  final Value<DateTime> dibuatPada;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.telepon = const Value.absent(),
    this.alamat = const Value.absent(),
    this.catatan = const Value.absent(),
    this.poin = const Value.absent(),
    this.dibuatPada = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String nama,
    required String telepon,
    this.alamat = const Value.absent(),
    this.catatan = const Value.absent(),
    this.poin = const Value.absent(),
    this.dibuatPada = const Value.absent(),
  }) : nama = Value(nama),
       telepon = Value(telepon);
  static Insertable<CustomerRow> custom({
    Expression<int>? id,
    Expression<String>? nama,
    Expression<String>? telepon,
    Expression<String>? alamat,
    Expression<String>? catatan,
    Expression<int>? poin,
    Expression<DateTime>? dibuatPada,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (telepon != null) 'telepon': telepon,
      if (alamat != null) 'alamat': alamat,
      if (catatan != null) 'catatan': catatan,
      if (poin != null) 'poin': poin,
      if (dibuatPada != null) 'dibuat_pada': dibuatPada,
    });
  }

  CustomersCompanion copyWith({
    Value<int>? id,
    Value<String>? nama,
    Value<String>? telepon,
    Value<String?>? alamat,
    Value<String?>? catatan,
    Value<int>? poin,
    Value<DateTime>? dibuatPada,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      telepon: telepon ?? this.telepon,
      alamat: alamat ?? this.alamat,
      catatan: catatan ?? this.catatan,
      poin: poin ?? this.poin,
      dibuatPada: dibuatPada ?? this.dibuatPada,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (telepon.present) {
      map['telepon'] = Variable<String>(telepon.value);
    }
    if (alamat.present) {
      map['alamat'] = Variable<String>(alamat.value);
    }
    if (catatan.present) {
      map['catatan'] = Variable<String>(catatan.value);
    }
    if (poin.present) {
      map['poin'] = Variable<int>(poin.value);
    }
    if (dibuatPada.present) {
      map['dibuat_pada'] = Variable<DateTime>(dibuatPada.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('telepon: $telepon, ')
          ..write('alamat: $alamat, ')
          ..write('catatan: $catatan, ')
          ..write('poin: $poin, ')
          ..write('dibuatPada: $dibuatPada')
          ..write(')'))
        .toString();
  }
}

class $ServicesTable extends Services with TableInfo<$ServicesTable, Service> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kategoriMeta = const VerificationMeta(
    'kategori',
  );
  @override
  late final GeneratedColumn<String> kategori = GeneratedColumn<String>(
    'kategori',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 40),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ServiceUnit, int> satuan =
      GeneratedColumn<int>(
        'satuan',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<ServiceUnit>($ServicesTable.$convertersatuan);
  static const VerificationMeta _hargaMeta = const VerificationMeta('harga');
  @override
  late final GeneratedColumn<int> harga = GeneratedColumn<int>(
    'harga',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aktifMeta = const VerificationMeta('aktif');
  @override
  late final GeneratedColumn<bool> aktif = GeneratedColumn<bool>(
    'aktif',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("aktif" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _dibuatPadaMeta = const VerificationMeta(
    'dibuatPada',
  );
  @override
  late final GeneratedColumn<DateTime> dibuatPada = GeneratedColumn<DateTime>(
    'dibuat_pada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nama,
    kategori,
    satuan,
    harga,
    aktif,
    dibuatPada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'services';
  @override
  VerificationContext validateIntegrity(
    Insertable<Service> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('kategori')) {
      context.handle(
        _kategoriMeta,
        kategori.isAcceptableOrUnknown(data['kategori']!, _kategoriMeta),
      );
    }
    if (data.containsKey('harga')) {
      context.handle(
        _hargaMeta,
        harga.isAcceptableOrUnknown(data['harga']!, _hargaMeta),
      );
    } else if (isInserting) {
      context.missing(_hargaMeta);
    }
    if (data.containsKey('aktif')) {
      context.handle(
        _aktifMeta,
        aktif.isAcceptableOrUnknown(data['aktif']!, _aktifMeta),
      );
    }
    if (data.containsKey('dibuat_pada')) {
      context.handle(
        _dibuatPadaMeta,
        dibuatPada.isAcceptableOrUnknown(data['dibuat_pada']!, _dibuatPadaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Service map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Service(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      kategori: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kategori'],
      ),
      satuan: $ServicesTable.$convertersatuan.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}satuan'],
        )!,
      ),
      harga: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}harga'],
      )!,
      aktif: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}aktif'],
      )!,
      dibuatPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dibuat_pada'],
      )!,
    );
  }

  @override
  $ServicesTable createAlias(String alias) {
    return $ServicesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ServiceUnit, int, int> $convertersatuan =
      const EnumIndexConverter<ServiceUnit>(ServiceUnit.values);
}

class Service extends DataClass implements Insertable<Service> {
  final int id;
  final String nama;

  /// Kategori menyusul di rilis 1.0 (FR-02); kolomnya sudah disiapkan
  /// supaya tidak perlu migrasi.
  final String? kategori;
  final ServiceUnit satuan;
  final int harga;

  /// Layanan nonaktif tidak dihapus agar riwayat order tetap utuh.
  final bool aktif;
  final DateTime dibuatPada;
  const Service({
    required this.id,
    required this.nama,
    this.kategori,
    required this.satuan,
    required this.harga,
    required this.aktif,
    required this.dibuatPada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nama'] = Variable<String>(nama);
    if (!nullToAbsent || kategori != null) {
      map['kategori'] = Variable<String>(kategori);
    }
    {
      map['satuan'] = Variable<int>(
        $ServicesTable.$convertersatuan.toSql(satuan),
      );
    }
    map['harga'] = Variable<int>(harga);
    map['aktif'] = Variable<bool>(aktif);
    map['dibuat_pada'] = Variable<DateTime>(dibuatPada);
    return map;
  }

  ServicesCompanion toCompanion(bool nullToAbsent) {
    return ServicesCompanion(
      id: Value(id),
      nama: Value(nama),
      kategori: kategori == null && nullToAbsent
          ? const Value.absent()
          : Value(kategori),
      satuan: Value(satuan),
      harga: Value(harga),
      aktif: Value(aktif),
      dibuatPada: Value(dibuatPada),
    );
  }

  factory Service.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Service(
      id: serializer.fromJson<int>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      kategori: serializer.fromJson<String?>(json['kategori']),
      satuan: $ServicesTable.$convertersatuan.fromJson(
        serializer.fromJson<int>(json['satuan']),
      ),
      harga: serializer.fromJson<int>(json['harga']),
      aktif: serializer.fromJson<bool>(json['aktif']),
      dibuatPada: serializer.fromJson<DateTime>(json['dibuatPada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nama': serializer.toJson<String>(nama),
      'kategori': serializer.toJson<String?>(kategori),
      'satuan': serializer.toJson<int>(
        $ServicesTable.$convertersatuan.toJson(satuan),
      ),
      'harga': serializer.toJson<int>(harga),
      'aktif': serializer.toJson<bool>(aktif),
      'dibuatPada': serializer.toJson<DateTime>(dibuatPada),
    };
  }

  Service copyWith({
    int? id,
    String? nama,
    Value<String?> kategori = const Value.absent(),
    ServiceUnit? satuan,
    int? harga,
    bool? aktif,
    DateTime? dibuatPada,
  }) => Service(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    kategori: kategori.present ? kategori.value : this.kategori,
    satuan: satuan ?? this.satuan,
    harga: harga ?? this.harga,
    aktif: aktif ?? this.aktif,
    dibuatPada: dibuatPada ?? this.dibuatPada,
  );
  Service copyWithCompanion(ServicesCompanion data) {
    return Service(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      kategori: data.kategori.present ? data.kategori.value : this.kategori,
      satuan: data.satuan.present ? data.satuan.value : this.satuan,
      harga: data.harga.present ? data.harga.value : this.harga,
      aktif: data.aktif.present ? data.aktif.value : this.aktif,
      dibuatPada: data.dibuatPada.present
          ? data.dibuatPada.value
          : this.dibuatPada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Service(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('kategori: $kategori, ')
          ..write('satuan: $satuan, ')
          ..write('harga: $harga, ')
          ..write('aktif: $aktif, ')
          ..write('dibuatPada: $dibuatPada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nama, kategori, satuan, harga, aktif, dibuatPada);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Service &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.kategori == this.kategori &&
          other.satuan == this.satuan &&
          other.harga == this.harga &&
          other.aktif == this.aktif &&
          other.dibuatPada == this.dibuatPada);
}

class ServicesCompanion extends UpdateCompanion<Service> {
  final Value<int> id;
  final Value<String> nama;
  final Value<String?> kategori;
  final Value<ServiceUnit> satuan;
  final Value<int> harga;
  final Value<bool> aktif;
  final Value<DateTime> dibuatPada;
  const ServicesCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.kategori = const Value.absent(),
    this.satuan = const Value.absent(),
    this.harga = const Value.absent(),
    this.aktif = const Value.absent(),
    this.dibuatPada = const Value.absent(),
  });
  ServicesCompanion.insert({
    this.id = const Value.absent(),
    required String nama,
    this.kategori = const Value.absent(),
    required ServiceUnit satuan,
    required int harga,
    this.aktif = const Value.absent(),
    this.dibuatPada = const Value.absent(),
  }) : nama = Value(nama),
       satuan = Value(satuan),
       harga = Value(harga);
  static Insertable<Service> custom({
    Expression<int>? id,
    Expression<String>? nama,
    Expression<String>? kategori,
    Expression<int>? satuan,
    Expression<int>? harga,
    Expression<bool>? aktif,
    Expression<DateTime>? dibuatPada,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (kategori != null) 'kategori': kategori,
      if (satuan != null) 'satuan': satuan,
      if (harga != null) 'harga': harga,
      if (aktif != null) 'aktif': aktif,
      if (dibuatPada != null) 'dibuat_pada': dibuatPada,
    });
  }

  ServicesCompanion copyWith({
    Value<int>? id,
    Value<String>? nama,
    Value<String?>? kategori,
    Value<ServiceUnit>? satuan,
    Value<int>? harga,
    Value<bool>? aktif,
    Value<DateTime>? dibuatPada,
  }) {
    return ServicesCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      kategori: kategori ?? this.kategori,
      satuan: satuan ?? this.satuan,
      harga: harga ?? this.harga,
      aktif: aktif ?? this.aktif,
      dibuatPada: dibuatPada ?? this.dibuatPada,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (kategori.present) {
      map['kategori'] = Variable<String>(kategori.value);
    }
    if (satuan.present) {
      map['satuan'] = Variable<int>(
        $ServicesTable.$convertersatuan.toSql(satuan.value),
      );
    }
    if (harga.present) {
      map['harga'] = Variable<int>(harga.value);
    }
    if (aktif.present) {
      map['aktif'] = Variable<bool>(aktif.value);
    }
    if (dibuatPada.present) {
      map['dibuat_pada'] = Variable<DateTime>(dibuatPada.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicesCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('kategori: $kategori, ')
          ..write('satuan: $satuan, ')
          ..write('harga: $harga, ')
          ..write('aktif: $aktif, ')
          ..write('dibuatPada: $dibuatPada')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomorNotaMeta = const VerificationMeta(
    'nomorNota',
  );
  @override
  late final GeneratedColumn<String> nomorNota = GeneratedColumn<String>(
    'nomor_nota',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _qrTokenMeta = const VerificationMeta(
    'qrToken',
  );
  @override
  late final GeneratedColumn<String> qrToken = GeneratedColumn<String>(
    'qr_token',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 8,
      maxTextLength: 32,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _tanggalMasukMeta = const VerificationMeta(
    'tanggalMasuk',
  );
  @override
  late final GeneratedColumn<DateTime> tanggalMasuk = GeneratedColumn<DateTime>(
    'tanggal_masuk',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimasiSelesaiMeta = const VerificationMeta(
    'estimasiSelesai',
  );
  @override
  late final GeneratedColumn<DateTime> estimasiSelesai =
      GeneratedColumn<DateTime>(
        'estimasi_selesai',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<OrderStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<OrderStatus>($OrdersTable.$converterstatus);
  static const VerificationMeta _diskonMeta = const VerificationMeta('diskon');
  @override
  late final GeneratedColumn<int> diskon = GeneratedColumn<int>(
    'diskon',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catatanMeta = const VerificationMeta(
    'catatan',
  );
  @override
  late final GeneratedColumn<String> catatan = GeneratedColumn<String>(
    'catatan',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 500),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dibuatPadaMeta = const VerificationMeta(
    'dibuatPada',
  );
  @override
  late final GeneratedColumn<DateTime> dibuatPada = GeneratedColumn<DateTime>(
    'dibuat_pada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _diubahPadaMeta = const VerificationMeta(
    'diubahPada',
  );
  @override
  late final GeneratedColumn<DateTime> diubahPada = GeneratedColumn<DateTime>(
    'diubah_pada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _dihapusPadaMeta = const VerificationMeta(
    'dihapusPada',
  );
  @override
  late final GeneratedColumn<DateTime> dihapusPada = GeneratedColumn<DateTime>(
    'dihapus_pada',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nomorNota,
    qrToken,
    customerId,
    tanggalMasuk,
    estimasiSelesai,
    status,
    diskon,
    total,
    catatan,
    dibuatPada,
    diubahPada,
    dihapusPada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Order> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nomor_nota')) {
      context.handle(
        _nomorNotaMeta,
        nomorNota.isAcceptableOrUnknown(data['nomor_nota']!, _nomorNotaMeta),
      );
    } else if (isInserting) {
      context.missing(_nomorNotaMeta);
    }
    if (data.containsKey('qr_token')) {
      context.handle(
        _qrTokenMeta,
        qrToken.isAcceptableOrUnknown(data['qr_token']!, _qrTokenMeta),
      );
    } else if (isInserting) {
      context.missing(_qrTokenMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('tanggal_masuk')) {
      context.handle(
        _tanggalMasukMeta,
        tanggalMasuk.isAcceptableOrUnknown(
          data['tanggal_masuk']!,
          _tanggalMasukMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tanggalMasukMeta);
    }
    if (data.containsKey('estimasi_selesai')) {
      context.handle(
        _estimasiSelesaiMeta,
        estimasiSelesai.isAcceptableOrUnknown(
          data['estimasi_selesai']!,
          _estimasiSelesaiMeta,
        ),
      );
    }
    if (data.containsKey('diskon')) {
      context.handle(
        _diskonMeta,
        diskon.isAcceptableOrUnknown(data['diskon']!, _diskonMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('catatan')) {
      context.handle(
        _catatanMeta,
        catatan.isAcceptableOrUnknown(data['catatan']!, _catatanMeta),
      );
    }
    if (data.containsKey('dibuat_pada')) {
      context.handle(
        _dibuatPadaMeta,
        dibuatPada.isAcceptableOrUnknown(data['dibuat_pada']!, _dibuatPadaMeta),
      );
    }
    if (data.containsKey('diubah_pada')) {
      context.handle(
        _diubahPadaMeta,
        diubahPada.isAcceptableOrUnknown(data['diubah_pada']!, _diubahPadaMeta),
      );
    }
    if (data.containsKey('dihapus_pada')) {
      context.handle(
        _dihapusPadaMeta,
        dihapusPada.isAcceptableOrUnknown(
          data['dihapus_pada']!,
          _dihapusPadaMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nomorNota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nomor_nota'],
      )!,
      qrToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qr_token'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      )!,
      tanggalMasuk: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal_masuk'],
      )!,
      estimasiSelesai: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}estimasi_selesai'],
      ),
      status: $OrdersTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      diskon: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diskon'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      catatan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catatan'],
      ),
      dibuatPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dibuat_pada'],
      )!,
      diubahPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}diubah_pada'],
      )!,
      dihapusPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dihapus_pada'],
      ),
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OrderStatus, int, int> $converterstatus =
      const EnumIndexConverter<OrderStatus>(OrderStatus.values);
}

class Order extends DataClass implements Insertable<Order> {
  final int id;

  /// Unik dan tidak dipakai ulang, termasuk setelah order dibatalkan.
  final String nomorNota;

  /// Token acak untuk label kantong; bukan nomor urut agar tidak bisa ditebak.
  final String qrToken;
  final int customerId;
  final DateTime tanggalMasuk;
  final DateTime? estimasiSelesai;
  final OrderStatus status;
  final int diskon;

  /// Snapshot: subtotal item dikurangi diskon, disimpan saat order dibuat.
  final int total;
  final String? catatan;
  final DateTime dibuatPada;
  final DateTime diubahPada;
  final DateTime? dihapusPada;
  const Order({
    required this.id,
    required this.nomorNota,
    required this.qrToken,
    required this.customerId,
    required this.tanggalMasuk,
    this.estimasiSelesai,
    required this.status,
    required this.diskon,
    required this.total,
    this.catatan,
    required this.dibuatPada,
    required this.diubahPada,
    this.dihapusPada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nomor_nota'] = Variable<String>(nomorNota);
    map['qr_token'] = Variable<String>(qrToken);
    map['customer_id'] = Variable<int>(customerId);
    map['tanggal_masuk'] = Variable<DateTime>(tanggalMasuk);
    if (!nullToAbsent || estimasiSelesai != null) {
      map['estimasi_selesai'] = Variable<DateTime>(estimasiSelesai);
    }
    {
      map['status'] = Variable<int>(
        $OrdersTable.$converterstatus.toSql(status),
      );
    }
    map['diskon'] = Variable<int>(diskon);
    map['total'] = Variable<int>(total);
    if (!nullToAbsent || catatan != null) {
      map['catatan'] = Variable<String>(catatan);
    }
    map['dibuat_pada'] = Variable<DateTime>(dibuatPada);
    map['diubah_pada'] = Variable<DateTime>(diubahPada);
    if (!nullToAbsent || dihapusPada != null) {
      map['dihapus_pada'] = Variable<DateTime>(dihapusPada);
    }
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      nomorNota: Value(nomorNota),
      qrToken: Value(qrToken),
      customerId: Value(customerId),
      tanggalMasuk: Value(tanggalMasuk),
      estimasiSelesai: estimasiSelesai == null && nullToAbsent
          ? const Value.absent()
          : Value(estimasiSelesai),
      status: Value(status),
      diskon: Value(diskon),
      total: Value(total),
      catatan: catatan == null && nullToAbsent
          ? const Value.absent()
          : Value(catatan),
      dibuatPada: Value(dibuatPada),
      diubahPada: Value(diubahPada),
      dihapusPada: dihapusPada == null && nullToAbsent
          ? const Value.absent()
          : Value(dihapusPada),
    );
  }

  factory Order.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<int>(json['id']),
      nomorNota: serializer.fromJson<String>(json['nomorNota']),
      qrToken: serializer.fromJson<String>(json['qrToken']),
      customerId: serializer.fromJson<int>(json['customerId']),
      tanggalMasuk: serializer.fromJson<DateTime>(json['tanggalMasuk']),
      estimasiSelesai: serializer.fromJson<DateTime?>(json['estimasiSelesai']),
      status: $OrdersTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      diskon: serializer.fromJson<int>(json['diskon']),
      total: serializer.fromJson<int>(json['total']),
      catatan: serializer.fromJson<String?>(json['catatan']),
      dibuatPada: serializer.fromJson<DateTime>(json['dibuatPada']),
      diubahPada: serializer.fromJson<DateTime>(json['diubahPada']),
      dihapusPada: serializer.fromJson<DateTime?>(json['dihapusPada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nomorNota': serializer.toJson<String>(nomorNota),
      'qrToken': serializer.toJson<String>(qrToken),
      'customerId': serializer.toJson<int>(customerId),
      'tanggalMasuk': serializer.toJson<DateTime>(tanggalMasuk),
      'estimasiSelesai': serializer.toJson<DateTime?>(estimasiSelesai),
      'status': serializer.toJson<int>(
        $OrdersTable.$converterstatus.toJson(status),
      ),
      'diskon': serializer.toJson<int>(diskon),
      'total': serializer.toJson<int>(total),
      'catatan': serializer.toJson<String?>(catatan),
      'dibuatPada': serializer.toJson<DateTime>(dibuatPada),
      'diubahPada': serializer.toJson<DateTime>(diubahPada),
      'dihapusPada': serializer.toJson<DateTime?>(dihapusPada),
    };
  }

  Order copyWith({
    int? id,
    String? nomorNota,
    String? qrToken,
    int? customerId,
    DateTime? tanggalMasuk,
    Value<DateTime?> estimasiSelesai = const Value.absent(),
    OrderStatus? status,
    int? diskon,
    int? total,
    Value<String?> catatan = const Value.absent(),
    DateTime? dibuatPada,
    DateTime? diubahPada,
    Value<DateTime?> dihapusPada = const Value.absent(),
  }) => Order(
    id: id ?? this.id,
    nomorNota: nomorNota ?? this.nomorNota,
    qrToken: qrToken ?? this.qrToken,
    customerId: customerId ?? this.customerId,
    tanggalMasuk: tanggalMasuk ?? this.tanggalMasuk,
    estimasiSelesai: estimasiSelesai.present
        ? estimasiSelesai.value
        : this.estimasiSelesai,
    status: status ?? this.status,
    diskon: diskon ?? this.diskon,
    total: total ?? this.total,
    catatan: catatan.present ? catatan.value : this.catatan,
    dibuatPada: dibuatPada ?? this.dibuatPada,
    diubahPada: diubahPada ?? this.diubahPada,
    dihapusPada: dihapusPada.present ? dihapusPada.value : this.dihapusPada,
  );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      nomorNota: data.nomorNota.present ? data.nomorNota.value : this.nomorNota,
      qrToken: data.qrToken.present ? data.qrToken.value : this.qrToken,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      tanggalMasuk: data.tanggalMasuk.present
          ? data.tanggalMasuk.value
          : this.tanggalMasuk,
      estimasiSelesai: data.estimasiSelesai.present
          ? data.estimasiSelesai.value
          : this.estimasiSelesai,
      status: data.status.present ? data.status.value : this.status,
      diskon: data.diskon.present ? data.diskon.value : this.diskon,
      total: data.total.present ? data.total.value : this.total,
      catatan: data.catatan.present ? data.catatan.value : this.catatan,
      dibuatPada: data.dibuatPada.present
          ? data.dibuatPada.value
          : this.dibuatPada,
      diubahPada: data.diubahPada.present
          ? data.diubahPada.value
          : this.diubahPada,
      dihapusPada: data.dihapusPada.present
          ? data.dihapusPada.value
          : this.dihapusPada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('nomorNota: $nomorNota, ')
          ..write('qrToken: $qrToken, ')
          ..write('customerId: $customerId, ')
          ..write('tanggalMasuk: $tanggalMasuk, ')
          ..write('estimasiSelesai: $estimasiSelesai, ')
          ..write('status: $status, ')
          ..write('diskon: $diskon, ')
          ..write('total: $total, ')
          ..write('catatan: $catatan, ')
          ..write('dibuatPada: $dibuatPada, ')
          ..write('diubahPada: $diubahPada, ')
          ..write('dihapusPada: $dihapusPada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nomorNota,
    qrToken,
    customerId,
    tanggalMasuk,
    estimasiSelesai,
    status,
    diskon,
    total,
    catatan,
    dibuatPada,
    diubahPada,
    dihapusPada,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.nomorNota == this.nomorNota &&
          other.qrToken == this.qrToken &&
          other.customerId == this.customerId &&
          other.tanggalMasuk == this.tanggalMasuk &&
          other.estimasiSelesai == this.estimasiSelesai &&
          other.status == this.status &&
          other.diskon == this.diskon &&
          other.total == this.total &&
          other.catatan == this.catatan &&
          other.dibuatPada == this.dibuatPada &&
          other.diubahPada == this.diubahPada &&
          other.dihapusPada == this.dihapusPada);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<int> id;
  final Value<String> nomorNota;
  final Value<String> qrToken;
  final Value<int> customerId;
  final Value<DateTime> tanggalMasuk;
  final Value<DateTime?> estimasiSelesai;
  final Value<OrderStatus> status;
  final Value<int> diskon;
  final Value<int> total;
  final Value<String?> catatan;
  final Value<DateTime> dibuatPada;
  final Value<DateTime> diubahPada;
  final Value<DateTime?> dihapusPada;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.nomorNota = const Value.absent(),
    this.qrToken = const Value.absent(),
    this.customerId = const Value.absent(),
    this.tanggalMasuk = const Value.absent(),
    this.estimasiSelesai = const Value.absent(),
    this.status = const Value.absent(),
    this.diskon = const Value.absent(),
    this.total = const Value.absent(),
    this.catatan = const Value.absent(),
    this.dibuatPada = const Value.absent(),
    this.diubahPada = const Value.absent(),
    this.dihapusPada = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    required String nomorNota,
    required String qrToken,
    required int customerId,
    required DateTime tanggalMasuk,
    this.estimasiSelesai = const Value.absent(),
    this.status = const Value.absent(),
    this.diskon = const Value.absent(),
    required int total,
    this.catatan = const Value.absent(),
    this.dibuatPada = const Value.absent(),
    this.diubahPada = const Value.absent(),
    this.dihapusPada = const Value.absent(),
  }) : nomorNota = Value(nomorNota),
       qrToken = Value(qrToken),
       customerId = Value(customerId),
       tanggalMasuk = Value(tanggalMasuk),
       total = Value(total);
  static Insertable<Order> custom({
    Expression<int>? id,
    Expression<String>? nomorNota,
    Expression<String>? qrToken,
    Expression<int>? customerId,
    Expression<DateTime>? tanggalMasuk,
    Expression<DateTime>? estimasiSelesai,
    Expression<int>? status,
    Expression<int>? diskon,
    Expression<int>? total,
    Expression<String>? catatan,
    Expression<DateTime>? dibuatPada,
    Expression<DateTime>? diubahPada,
    Expression<DateTime>? dihapusPada,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nomorNota != null) 'nomor_nota': nomorNota,
      if (qrToken != null) 'qr_token': qrToken,
      if (customerId != null) 'customer_id': customerId,
      if (tanggalMasuk != null) 'tanggal_masuk': tanggalMasuk,
      if (estimasiSelesai != null) 'estimasi_selesai': estimasiSelesai,
      if (status != null) 'status': status,
      if (diskon != null) 'diskon': diskon,
      if (total != null) 'total': total,
      if (catatan != null) 'catatan': catatan,
      if (dibuatPada != null) 'dibuat_pada': dibuatPada,
      if (diubahPada != null) 'diubah_pada': diubahPada,
      if (dihapusPada != null) 'dihapus_pada': dihapusPada,
    });
  }

  OrdersCompanion copyWith({
    Value<int>? id,
    Value<String>? nomorNota,
    Value<String>? qrToken,
    Value<int>? customerId,
    Value<DateTime>? tanggalMasuk,
    Value<DateTime?>? estimasiSelesai,
    Value<OrderStatus>? status,
    Value<int>? diskon,
    Value<int>? total,
    Value<String?>? catatan,
    Value<DateTime>? dibuatPada,
    Value<DateTime>? diubahPada,
    Value<DateTime?>? dihapusPada,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      nomorNota: nomorNota ?? this.nomorNota,
      qrToken: qrToken ?? this.qrToken,
      customerId: customerId ?? this.customerId,
      tanggalMasuk: tanggalMasuk ?? this.tanggalMasuk,
      estimasiSelesai: estimasiSelesai ?? this.estimasiSelesai,
      status: status ?? this.status,
      diskon: diskon ?? this.diskon,
      total: total ?? this.total,
      catatan: catatan ?? this.catatan,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      diubahPada: diubahPada ?? this.diubahPada,
      dihapusPada: dihapusPada ?? this.dihapusPada,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nomorNota.present) {
      map['nomor_nota'] = Variable<String>(nomorNota.value);
    }
    if (qrToken.present) {
      map['qr_token'] = Variable<String>(qrToken.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (tanggalMasuk.present) {
      map['tanggal_masuk'] = Variable<DateTime>(tanggalMasuk.value);
    }
    if (estimasiSelesai.present) {
      map['estimasi_selesai'] = Variable<DateTime>(estimasiSelesai.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $OrdersTable.$converterstatus.toSql(status.value),
      );
    }
    if (diskon.present) {
      map['diskon'] = Variable<int>(diskon.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (catatan.present) {
      map['catatan'] = Variable<String>(catatan.value);
    }
    if (dibuatPada.present) {
      map['dibuat_pada'] = Variable<DateTime>(dibuatPada.value);
    }
    if (diubahPada.present) {
      map['diubah_pada'] = Variable<DateTime>(diubahPada.value);
    }
    if (dihapusPada.present) {
      map['dihapus_pada'] = Variable<DateTime>(dihapusPada.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('nomorNota: $nomorNota, ')
          ..write('qrToken: $qrToken, ')
          ..write('customerId: $customerId, ')
          ..write('tanggalMasuk: $tanggalMasuk, ')
          ..write('estimasiSelesai: $estimasiSelesai, ')
          ..write('status: $status, ')
          ..write('diskon: $diskon, ')
          ..write('total: $total, ')
          ..write('catatan: $catatan, ')
          ..write('dibuatPada: $dibuatPada, ')
          ..write('diubahPada: $diubahPada, ')
          ..write('dihapusPada: $dihapusPada')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTable extends OrderItems
    with TableInfo<$OrderItemsTable, OrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _serviceIdMeta = const VerificationMeta(
    'serviceId',
  );
  @override
  late final GeneratedColumn<int> serviceId = GeneratedColumn<int>(
    'service_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES services (id)',
    ),
  );
  static const VerificationMeta _namaLayananMeta = const VerificationMeta(
    'namaLayanan',
  );
  @override
  late final GeneratedColumn<String> namaLayanan = GeneratedColumn<String>(
    'nama_layanan',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMilliMeta = const VerificationMeta(
    'qtyMilli',
  );
  @override
  late final GeneratedColumn<int> qtyMilli = GeneratedColumn<int>(
    'qty_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hargaSatuanMeta = const VerificationMeta(
    'hargaSatuan',
  );
  @override
  late final GeneratedColumn<int> hargaSatuan = GeneratedColumn<int>(
    'harga_satuan',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<int> subtotal = GeneratedColumn<int>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dibuatPadaMeta = const VerificationMeta(
    'dibuatPada',
  );
  @override
  late final GeneratedColumn<DateTime> dibuatPada = GeneratedColumn<DateTime>(
    'dibuat_pada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    serviceId,
    namaLayanan,
    qtyMilli,
    hargaSatuan,
    subtotal,
    dibuatPada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('service_id')) {
      context.handle(
        _serviceIdMeta,
        serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serviceIdMeta);
    }
    if (data.containsKey('nama_layanan')) {
      context.handle(
        _namaLayananMeta,
        namaLayanan.isAcceptableOrUnknown(
          data['nama_layanan']!,
          _namaLayananMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_namaLayananMeta);
    }
    if (data.containsKey('qty_milli')) {
      context.handle(
        _qtyMilliMeta,
        qtyMilli.isAcceptableOrUnknown(data['qty_milli']!, _qtyMilliMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMilliMeta);
    }
    if (data.containsKey('harga_satuan')) {
      context.handle(
        _hargaSatuanMeta,
        hargaSatuan.isAcceptableOrUnknown(
          data['harga_satuan']!,
          _hargaSatuanMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hargaSatuanMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('dibuat_pada')) {
      context.handle(
        _dibuatPadaMeta,
        dibuatPada.isAcceptableOrUnknown(data['dibuat_pada']!, _dibuatPadaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_id'],
      )!,
      serviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}service_id'],
      )!,
      namaLayanan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_layanan'],
      )!,
      qtyMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty_milli'],
      )!,
      hargaSatuan: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}harga_satuan'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal'],
      )!,
      dibuatPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dibuat_pada'],
      )!,
    );
  }

  @override
  $OrderItemsTable createAlias(String alias) {
    return $OrderItemsTable(attachedDatabase, alias);
  }
}

class OrderItem extends DataClass implements Insertable<OrderItem> {
  final int id;
  final int orderId;
  final int serviceId;

  /// Nama dan harga disalin agar perubahan layanan tidak mengubah order lama.
  final String namaLayanan;

  /// 1/1000 satuan, mis. 2,5 kg = 2500.
  final int qtyMilli;
  final int hargaSatuan;
  final int subtotal;
  final DateTime dibuatPada;
  const OrderItem({
    required this.id,
    required this.orderId,
    required this.serviceId,
    required this.namaLayanan,
    required this.qtyMilli,
    required this.hargaSatuan,
    required this.subtotal,
    required this.dibuatPada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['service_id'] = Variable<int>(serviceId);
    map['nama_layanan'] = Variable<String>(namaLayanan);
    map['qty_milli'] = Variable<int>(qtyMilli);
    map['harga_satuan'] = Variable<int>(hargaSatuan);
    map['subtotal'] = Variable<int>(subtotal);
    map['dibuat_pada'] = Variable<DateTime>(dibuatPada);
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      serviceId: Value(serviceId),
      namaLayanan: Value(namaLayanan),
      qtyMilli: Value(qtyMilli),
      hargaSatuan: Value(hargaSatuan),
      subtotal: Value(subtotal),
      dibuatPada: Value(dibuatPada),
    );
  }

  factory OrderItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItem(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      serviceId: serializer.fromJson<int>(json['serviceId']),
      namaLayanan: serializer.fromJson<String>(json['namaLayanan']),
      qtyMilli: serializer.fromJson<int>(json['qtyMilli']),
      hargaSatuan: serializer.fromJson<int>(json['hargaSatuan']),
      subtotal: serializer.fromJson<int>(json['subtotal']),
      dibuatPada: serializer.fromJson<DateTime>(json['dibuatPada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'serviceId': serializer.toJson<int>(serviceId),
      'namaLayanan': serializer.toJson<String>(namaLayanan),
      'qtyMilli': serializer.toJson<int>(qtyMilli),
      'hargaSatuan': serializer.toJson<int>(hargaSatuan),
      'subtotal': serializer.toJson<int>(subtotal),
      'dibuatPada': serializer.toJson<DateTime>(dibuatPada),
    };
  }

  OrderItem copyWith({
    int? id,
    int? orderId,
    int? serviceId,
    String? namaLayanan,
    int? qtyMilli,
    int? hargaSatuan,
    int? subtotal,
    DateTime? dibuatPada,
  }) => OrderItem(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    serviceId: serviceId ?? this.serviceId,
    namaLayanan: namaLayanan ?? this.namaLayanan,
    qtyMilli: qtyMilli ?? this.qtyMilli,
    hargaSatuan: hargaSatuan ?? this.hargaSatuan,
    subtotal: subtotal ?? this.subtotal,
    dibuatPada: dibuatPada ?? this.dibuatPada,
  );
  OrderItem copyWithCompanion(OrderItemsCompanion data) {
    return OrderItem(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      namaLayanan: data.namaLayanan.present
          ? data.namaLayanan.value
          : this.namaLayanan,
      qtyMilli: data.qtyMilli.present ? data.qtyMilli.value : this.qtyMilli,
      hargaSatuan: data.hargaSatuan.present
          ? data.hargaSatuan.value
          : this.hargaSatuan,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      dibuatPada: data.dibuatPada.present
          ? data.dibuatPada.value
          : this.dibuatPada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItem(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('serviceId: $serviceId, ')
          ..write('namaLayanan: $namaLayanan, ')
          ..write('qtyMilli: $qtyMilli, ')
          ..write('hargaSatuan: $hargaSatuan, ')
          ..write('subtotal: $subtotal, ')
          ..write('dibuatPada: $dibuatPada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderId,
    serviceId,
    namaLayanan,
    qtyMilli,
    hargaSatuan,
    subtotal,
    dibuatPada,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItem &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.serviceId == this.serviceId &&
          other.namaLayanan == this.namaLayanan &&
          other.qtyMilli == this.qtyMilli &&
          other.hargaSatuan == this.hargaSatuan &&
          other.subtotal == this.subtotal &&
          other.dibuatPada == this.dibuatPada);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItem> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> serviceId;
  final Value<String> namaLayanan;
  final Value<int> qtyMilli;
  final Value<int> hargaSatuan;
  final Value<int> subtotal;
  final Value<DateTime> dibuatPada;
  const OrderItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.namaLayanan = const Value.absent(),
    this.qtyMilli = const Value.absent(),
    this.hargaSatuan = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.dibuatPada = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int serviceId,
    required String namaLayanan,
    required int qtyMilli,
    required int hargaSatuan,
    required int subtotal,
    this.dibuatPada = const Value.absent(),
  }) : orderId = Value(orderId),
       serviceId = Value(serviceId),
       namaLayanan = Value(namaLayanan),
       qtyMilli = Value(qtyMilli),
       hargaSatuan = Value(hargaSatuan),
       subtotal = Value(subtotal);
  static Insertable<OrderItem> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? serviceId,
    Expression<String>? namaLayanan,
    Expression<int>? qtyMilli,
    Expression<int>? hargaSatuan,
    Expression<int>? subtotal,
    Expression<DateTime>? dibuatPada,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (serviceId != null) 'service_id': serviceId,
      if (namaLayanan != null) 'nama_layanan': namaLayanan,
      if (qtyMilli != null) 'qty_milli': qtyMilli,
      if (hargaSatuan != null) 'harga_satuan': hargaSatuan,
      if (subtotal != null) 'subtotal': subtotal,
      if (dibuatPada != null) 'dibuat_pada': dibuatPada,
    });
  }

  OrderItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? orderId,
    Value<int>? serviceId,
    Value<String>? namaLayanan,
    Value<int>? qtyMilli,
    Value<int>? hargaSatuan,
    Value<int>? subtotal,
    Value<DateTime>? dibuatPada,
  }) {
    return OrderItemsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      serviceId: serviceId ?? this.serviceId,
      namaLayanan: namaLayanan ?? this.namaLayanan,
      qtyMilli: qtyMilli ?? this.qtyMilli,
      hargaSatuan: hargaSatuan ?? this.hargaSatuan,
      subtotal: subtotal ?? this.subtotal,
      dibuatPada: dibuatPada ?? this.dibuatPada,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (serviceId.present) {
      map['service_id'] = Variable<int>(serviceId.value);
    }
    if (namaLayanan.present) {
      map['nama_layanan'] = Variable<String>(namaLayanan.value);
    }
    if (qtyMilli.present) {
      map['qty_milli'] = Variable<int>(qtyMilli.value);
    }
    if (hargaSatuan.present) {
      map['harga_satuan'] = Variable<int>(hargaSatuan.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<int>(subtotal.value);
    }
    if (dibuatPada.present) {
      map['dibuat_pada'] = Variable<DateTime>(dibuatPada.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('serviceId: $serviceId, ')
          ..write('namaLayanan: $namaLayanan, ')
          ..write('qtyMilli: $qtyMilli, ')
          ..write('hargaSatuan: $hargaSatuan, ')
          ..write('subtotal: $subtotal, ')
          ..write('dibuatPada: $dibuatPada')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  static const VerificationMeta _jumlahMeta = const VerificationMeta('jumlah');
  @override
  late final GeneratedColumn<int> jumlah = GeneratedColumn<int>(
    'jumlah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentMethod, int> metode =
      GeneratedColumn<int>(
        'metode',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<PaymentMethod>($PaymentsTable.$convertermetode);
  static const VerificationMeta _tanggalMeta = const VerificationMeta(
    'tanggal',
  );
  @override
  late final GeneratedColumn<DateTime> tanggal = GeneratedColumn<DateTime>(
    'tanggal',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catatanMeta = const VerificationMeta(
    'catatan',
  );
  @override
  late final GeneratedColumn<String> catatan = GeneratedColumn<String>(
    'catatan',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 300),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dibuatPadaMeta = const VerificationMeta(
    'dibuatPada',
  );
  @override
  late final GeneratedColumn<DateTime> dibuatPada = GeneratedColumn<DateTime>(
    'dibuat_pada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _dihapusPadaMeta = const VerificationMeta(
    'dihapusPada',
  );
  @override
  late final GeneratedColumn<DateTime> dihapusPada = GeneratedColumn<DateTime>(
    'dihapus_pada',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    jumlah,
    metode,
    tanggal,
    catatan,
    dibuatPada,
    dihapusPada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('jumlah')) {
      context.handle(
        _jumlahMeta,
        jumlah.isAcceptableOrUnknown(data['jumlah']!, _jumlahMeta),
      );
    } else if (isInserting) {
      context.missing(_jumlahMeta);
    }
    if (data.containsKey('tanggal')) {
      context.handle(
        _tanggalMeta,
        tanggal.isAcceptableOrUnknown(data['tanggal']!, _tanggalMeta),
      );
    } else if (isInserting) {
      context.missing(_tanggalMeta);
    }
    if (data.containsKey('catatan')) {
      context.handle(
        _catatanMeta,
        catatan.isAcceptableOrUnknown(data['catatan']!, _catatanMeta),
      );
    }
    if (data.containsKey('dibuat_pada')) {
      context.handle(
        _dibuatPadaMeta,
        dibuatPada.isAcceptableOrUnknown(data['dibuat_pada']!, _dibuatPadaMeta),
      );
    }
    if (data.containsKey('dihapus_pada')) {
      context.handle(
        _dihapusPadaMeta,
        dihapusPada.isAcceptableOrUnknown(
          data['dihapus_pada']!,
          _dihapusPadaMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_id'],
      )!,
      jumlah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jumlah'],
      )!,
      metode: $PaymentsTable.$convertermetode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}metode'],
        )!,
      ),
      tanggal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal'],
      )!,
      catatan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catatan'],
      ),
      dibuatPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dibuat_pada'],
      )!,
      dihapusPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dihapus_pada'],
      ),
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PaymentMethod, int, int> $convertermetode =
      const EnumIndexConverter<PaymentMethod>(PaymentMethod.values);
}

class Payment extends DataClass implements Insertable<Payment> {
  final int id;
  final int orderId;
  final int jumlah;
  final PaymentMethod metode;
  final DateTime tanggal;
  final String? catatan;
  final DateTime dibuatPada;
  final DateTime? dihapusPada;
  const Payment({
    required this.id,
    required this.orderId,
    required this.jumlah,
    required this.metode,
    required this.tanggal,
    this.catatan,
    required this.dibuatPada,
    this.dihapusPada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['jumlah'] = Variable<int>(jumlah);
    {
      map['metode'] = Variable<int>(
        $PaymentsTable.$convertermetode.toSql(metode),
      );
    }
    map['tanggal'] = Variable<DateTime>(tanggal);
    if (!nullToAbsent || catatan != null) {
      map['catatan'] = Variable<String>(catatan);
    }
    map['dibuat_pada'] = Variable<DateTime>(dibuatPada);
    if (!nullToAbsent || dihapusPada != null) {
      map['dihapus_pada'] = Variable<DateTime>(dihapusPada);
    }
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      jumlah: Value(jumlah),
      metode: Value(metode),
      tanggal: Value(tanggal),
      catatan: catatan == null && nullToAbsent
          ? const Value.absent()
          : Value(catatan),
      dibuatPada: Value(dibuatPada),
      dihapusPada: dihapusPada == null && nullToAbsent
          ? const Value.absent()
          : Value(dihapusPada),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      jumlah: serializer.fromJson<int>(json['jumlah']),
      metode: $PaymentsTable.$convertermetode.fromJson(
        serializer.fromJson<int>(json['metode']),
      ),
      tanggal: serializer.fromJson<DateTime>(json['tanggal']),
      catatan: serializer.fromJson<String?>(json['catatan']),
      dibuatPada: serializer.fromJson<DateTime>(json['dibuatPada']),
      dihapusPada: serializer.fromJson<DateTime?>(json['dihapusPada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'jumlah': serializer.toJson<int>(jumlah),
      'metode': serializer.toJson<int>(
        $PaymentsTable.$convertermetode.toJson(metode),
      ),
      'tanggal': serializer.toJson<DateTime>(tanggal),
      'catatan': serializer.toJson<String?>(catatan),
      'dibuatPada': serializer.toJson<DateTime>(dibuatPada),
      'dihapusPada': serializer.toJson<DateTime?>(dihapusPada),
    };
  }

  Payment copyWith({
    int? id,
    int? orderId,
    int? jumlah,
    PaymentMethod? metode,
    DateTime? tanggal,
    Value<String?> catatan = const Value.absent(),
    DateTime? dibuatPada,
    Value<DateTime?> dihapusPada = const Value.absent(),
  }) => Payment(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    jumlah: jumlah ?? this.jumlah,
    metode: metode ?? this.metode,
    tanggal: tanggal ?? this.tanggal,
    catatan: catatan.present ? catatan.value : this.catatan,
    dibuatPada: dibuatPada ?? this.dibuatPada,
    dihapusPada: dihapusPada.present ? dihapusPada.value : this.dihapusPada,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      jumlah: data.jumlah.present ? data.jumlah.value : this.jumlah,
      metode: data.metode.present ? data.metode.value : this.metode,
      tanggal: data.tanggal.present ? data.tanggal.value : this.tanggal,
      catatan: data.catatan.present ? data.catatan.value : this.catatan,
      dibuatPada: data.dibuatPada.present
          ? data.dibuatPada.value
          : this.dibuatPada,
      dihapusPada: data.dihapusPada.present
          ? data.dihapusPada.value
          : this.dihapusPada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('jumlah: $jumlah, ')
          ..write('metode: $metode, ')
          ..write('tanggal: $tanggal, ')
          ..write('catatan: $catatan, ')
          ..write('dibuatPada: $dibuatPada, ')
          ..write('dihapusPada: $dihapusPada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderId,
    jumlah,
    metode,
    tanggal,
    catatan,
    dibuatPada,
    dihapusPada,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.jumlah == this.jumlah &&
          other.metode == this.metode &&
          other.tanggal == this.tanggal &&
          other.catatan == this.catatan &&
          other.dibuatPada == this.dibuatPada &&
          other.dihapusPada == this.dihapusPada);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> jumlah;
  final Value<PaymentMethod> metode;
  final Value<DateTime> tanggal;
  final Value<String?> catatan;
  final Value<DateTime> dibuatPada;
  final Value<DateTime?> dihapusPada;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.metode = const Value.absent(),
    this.tanggal = const Value.absent(),
    this.catatan = const Value.absent(),
    this.dibuatPada = const Value.absent(),
    this.dihapusPada = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int jumlah,
    required PaymentMethod metode,
    required DateTime tanggal,
    this.catatan = const Value.absent(),
    this.dibuatPada = const Value.absent(),
    this.dihapusPada = const Value.absent(),
  }) : orderId = Value(orderId),
       jumlah = Value(jumlah),
       metode = Value(metode),
       tanggal = Value(tanggal);
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? jumlah,
    Expression<int>? metode,
    Expression<DateTime>? tanggal,
    Expression<String>? catatan,
    Expression<DateTime>? dibuatPada,
    Expression<DateTime>? dihapusPada,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (jumlah != null) 'jumlah': jumlah,
      if (metode != null) 'metode': metode,
      if (tanggal != null) 'tanggal': tanggal,
      if (catatan != null) 'catatan': catatan,
      if (dibuatPada != null) 'dibuat_pada': dibuatPada,
      if (dihapusPada != null) 'dihapus_pada': dihapusPada,
    });
  }

  PaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? orderId,
    Value<int>? jumlah,
    Value<PaymentMethod>? metode,
    Value<DateTime>? tanggal,
    Value<String?>? catatan,
    Value<DateTime>? dibuatPada,
    Value<DateTime?>? dihapusPada,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      jumlah: jumlah ?? this.jumlah,
      metode: metode ?? this.metode,
      tanggal: tanggal ?? this.tanggal,
      catatan: catatan ?? this.catatan,
      dibuatPada: dibuatPada ?? this.dibuatPada,
      dihapusPada: dihapusPada ?? this.dihapusPada,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (jumlah.present) {
      map['jumlah'] = Variable<int>(jumlah.value);
    }
    if (metode.present) {
      map['metode'] = Variable<int>(
        $PaymentsTable.$convertermetode.toSql(metode.value),
      );
    }
    if (tanggal.present) {
      map['tanggal'] = Variable<DateTime>(tanggal.value);
    }
    if (catatan.present) {
      map['catatan'] = Variable<String>(catatan.value);
    }
    if (dibuatPada.present) {
      map['dibuat_pada'] = Variable<DateTime>(dibuatPada.value);
    }
    if (dihapusPada.present) {
      map['dihapus_pada'] = Variable<DateTime>(dihapusPada.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('jumlah: $jumlah, ')
          ..write('metode: $metode, ')
          ..write('tanggal: $tanggal, ')
          ..write('catatan: $catatan, ')
          ..write('dibuatPada: $dibuatPada, ')
          ..write('dihapusPada: $dihapusPada')
          ..write(')'))
        .toString();
  }
}

class $OrderStatusHistoryTable extends OrderStatusHistory
    with TableInfo<$OrderStatusHistoryTable, StatusHistoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderStatusHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<OrderStatus?, int> statusLama =
      GeneratedColumn<int>(
        'status_lama',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<OrderStatus?>(
        $OrderStatusHistoryTable.$converterstatusLaman,
      );
  @override
  late final GeneratedColumnWithTypeConverter<OrderStatus, int> statusBaru =
      GeneratedColumn<int>(
        'status_baru',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<OrderStatus>(
        $OrderStatusHistoryTable.$converterstatusBaru,
      );
  @override
  late final GeneratedColumnWithTypeConverter<StatusChangeSource, int> sumber =
      GeneratedColumn<int>(
        'sumber',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<StatusChangeSource>(
        $OrderStatusHistoryTable.$convertersumber,
      );
  static const VerificationMeta _diubahPadaMeta = const VerificationMeta(
    'diubahPada',
  );
  @override
  late final GeneratedColumn<DateTime> diubahPada = GeneratedColumn<DateTime>(
    'diubah_pada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    statusLama,
    statusBaru,
    sumber,
    diubahPada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_status_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<StatusHistoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('diubah_pada')) {
      context.handle(
        _diubahPadaMeta,
        diubahPada.isAcceptableOrUnknown(data['diubah_pada']!, _diubahPadaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StatusHistoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StatusHistoryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_id'],
      )!,
      statusLama: $OrderStatusHistoryTable.$converterstatusLaman.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status_lama'],
        ),
      ),
      statusBaru: $OrderStatusHistoryTable.$converterstatusBaru.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status_baru'],
        )!,
      ),
      sumber: $OrderStatusHistoryTable.$convertersumber.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}sumber'],
        )!,
      ),
      diubahPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}diubah_pada'],
      )!,
    );
  }

  @override
  $OrderStatusHistoryTable createAlias(String alias) {
    return $OrderStatusHistoryTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OrderStatus, int, int> $converterstatusLama =
      const EnumIndexConverter<OrderStatus>(OrderStatus.values);
  static JsonTypeConverter2<OrderStatus?, int?, int?> $converterstatusLaman =
      JsonTypeConverter2.asNullable($converterstatusLama);
  static JsonTypeConverter2<OrderStatus, int, int> $converterstatusBaru =
      const EnumIndexConverter<OrderStatus>(OrderStatus.values);
  static JsonTypeConverter2<StatusChangeSource, int, int> $convertersumber =
      const EnumIndexConverter<StatusChangeSource>(StatusChangeSource.values);
}

class StatusHistoryEntry extends DataClass
    implements Insertable<StatusHistoryEntry> {
  final int id;
  final int orderId;

  /// Null saat order pertama kali dibuat.
  final OrderStatus? statusLama;
  final OrderStatus statusBaru;
  final StatusChangeSource sumber;
  final DateTime diubahPada;
  const StatusHistoryEntry({
    required this.id,
    required this.orderId,
    this.statusLama,
    required this.statusBaru,
    required this.sumber,
    required this.diubahPada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    if (!nullToAbsent || statusLama != null) {
      map['status_lama'] = Variable<int>(
        $OrderStatusHistoryTable.$converterstatusLaman.toSql(statusLama),
      );
    }
    {
      map['status_baru'] = Variable<int>(
        $OrderStatusHistoryTable.$converterstatusBaru.toSql(statusBaru),
      );
    }
    {
      map['sumber'] = Variable<int>(
        $OrderStatusHistoryTable.$convertersumber.toSql(sumber),
      );
    }
    map['diubah_pada'] = Variable<DateTime>(diubahPada);
    return map;
  }

  OrderStatusHistoryCompanion toCompanion(bool nullToAbsent) {
    return OrderStatusHistoryCompanion(
      id: Value(id),
      orderId: Value(orderId),
      statusLama: statusLama == null && nullToAbsent
          ? const Value.absent()
          : Value(statusLama),
      statusBaru: Value(statusBaru),
      sumber: Value(sumber),
      diubahPada: Value(diubahPada),
    );
  }

  factory StatusHistoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StatusHistoryEntry(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      statusLama: $OrderStatusHistoryTable.$converterstatusLaman.fromJson(
        serializer.fromJson<int?>(json['statusLama']),
      ),
      statusBaru: $OrderStatusHistoryTable.$converterstatusBaru.fromJson(
        serializer.fromJson<int>(json['statusBaru']),
      ),
      sumber: $OrderStatusHistoryTable.$convertersumber.fromJson(
        serializer.fromJson<int>(json['sumber']),
      ),
      diubahPada: serializer.fromJson<DateTime>(json['diubahPada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'statusLama': serializer.toJson<int?>(
        $OrderStatusHistoryTable.$converterstatusLaman.toJson(statusLama),
      ),
      'statusBaru': serializer.toJson<int>(
        $OrderStatusHistoryTable.$converterstatusBaru.toJson(statusBaru),
      ),
      'sumber': serializer.toJson<int>(
        $OrderStatusHistoryTable.$convertersumber.toJson(sumber),
      ),
      'diubahPada': serializer.toJson<DateTime>(diubahPada),
    };
  }

  StatusHistoryEntry copyWith({
    int? id,
    int? orderId,
    Value<OrderStatus?> statusLama = const Value.absent(),
    OrderStatus? statusBaru,
    StatusChangeSource? sumber,
    DateTime? diubahPada,
  }) => StatusHistoryEntry(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    statusLama: statusLama.present ? statusLama.value : this.statusLama,
    statusBaru: statusBaru ?? this.statusBaru,
    sumber: sumber ?? this.sumber,
    diubahPada: diubahPada ?? this.diubahPada,
  );
  StatusHistoryEntry copyWithCompanion(OrderStatusHistoryCompanion data) {
    return StatusHistoryEntry(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      statusLama: data.statusLama.present
          ? data.statusLama.value
          : this.statusLama,
      statusBaru: data.statusBaru.present
          ? data.statusBaru.value
          : this.statusBaru,
      sumber: data.sumber.present ? data.sumber.value : this.sumber,
      diubahPada: data.diubahPada.present
          ? data.diubahPada.value
          : this.diubahPada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StatusHistoryEntry(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('statusLama: $statusLama, ')
          ..write('statusBaru: $statusBaru, ')
          ..write('sumber: $sumber, ')
          ..write('diubahPada: $diubahPada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, orderId, statusLama, statusBaru, sumber, diubahPada);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StatusHistoryEntry &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.statusLama == this.statusLama &&
          other.statusBaru == this.statusBaru &&
          other.sumber == this.sumber &&
          other.diubahPada == this.diubahPada);
}

class OrderStatusHistoryCompanion extends UpdateCompanion<StatusHistoryEntry> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<OrderStatus?> statusLama;
  final Value<OrderStatus> statusBaru;
  final Value<StatusChangeSource> sumber;
  final Value<DateTime> diubahPada;
  const OrderStatusHistoryCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.statusLama = const Value.absent(),
    this.statusBaru = const Value.absent(),
    this.sumber = const Value.absent(),
    this.diubahPada = const Value.absent(),
  });
  OrderStatusHistoryCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    this.statusLama = const Value.absent(),
    required OrderStatus statusBaru,
    required StatusChangeSource sumber,
    this.diubahPada = const Value.absent(),
  }) : orderId = Value(orderId),
       statusBaru = Value(statusBaru),
       sumber = Value(sumber);
  static Insertable<StatusHistoryEntry> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? statusLama,
    Expression<int>? statusBaru,
    Expression<int>? sumber,
    Expression<DateTime>? diubahPada,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (statusLama != null) 'status_lama': statusLama,
      if (statusBaru != null) 'status_baru': statusBaru,
      if (sumber != null) 'sumber': sumber,
      if (diubahPada != null) 'diubah_pada': diubahPada,
    });
  }

  OrderStatusHistoryCompanion copyWith({
    Value<int>? id,
    Value<int>? orderId,
    Value<OrderStatus?>? statusLama,
    Value<OrderStatus>? statusBaru,
    Value<StatusChangeSource>? sumber,
    Value<DateTime>? diubahPada,
  }) {
    return OrderStatusHistoryCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      statusLama: statusLama ?? this.statusLama,
      statusBaru: statusBaru ?? this.statusBaru,
      sumber: sumber ?? this.sumber,
      diubahPada: diubahPada ?? this.diubahPada,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (statusLama.present) {
      map['status_lama'] = Variable<int>(
        $OrderStatusHistoryTable.$converterstatusLaman.toSql(statusLama.value),
      );
    }
    if (statusBaru.present) {
      map['status_baru'] = Variable<int>(
        $OrderStatusHistoryTable.$converterstatusBaru.toSql(statusBaru.value),
      );
    }
    if (sumber.present) {
      map['sumber'] = Variable<int>(
        $OrderStatusHistoryTable.$convertersumber.toSql(sumber.value),
      );
    }
    if (diubahPada.present) {
      map['diubah_pada'] = Variable<DateTime>(diubahPada.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderStatusHistoryCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('statusLama: $statusLama, ')
          ..write('statusBaru: $statusBaru, ')
          ..write('sumber: $sumber, ')
          ..write('diubahPada: $diubahPada')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kategoriMeta = const VerificationMeta(
    'kategori',
  );
  @override
  late final GeneratedColumn<String> kategori = GeneratedColumn<String>(
    'kategori',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jumlahMeta = const VerificationMeta('jumlah');
  @override
  late final GeneratedColumn<int> jumlah = GeneratedColumn<int>(
    'jumlah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tanggalMeta = const VerificationMeta(
    'tanggal',
  );
  @override
  late final GeneratedColumn<DateTime> tanggal = GeneratedColumn<DateTime>(
    'tanggal',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catatanMeta = const VerificationMeta(
    'catatan',
  );
  @override
  late final GeneratedColumn<String> catatan = GeneratedColumn<String>(
    'catatan',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 300),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dibuatPadaMeta = const VerificationMeta(
    'dibuatPada',
  );
  @override
  late final GeneratedColumn<DateTime> dibuatPada = GeneratedColumn<DateTime>(
    'dibuat_pada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kategori,
    jumlah,
    tanggal,
    catatan,
    dibuatPada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kategori')) {
      context.handle(
        _kategoriMeta,
        kategori.isAcceptableOrUnknown(data['kategori']!, _kategoriMeta),
      );
    } else if (isInserting) {
      context.missing(_kategoriMeta);
    }
    if (data.containsKey('jumlah')) {
      context.handle(
        _jumlahMeta,
        jumlah.isAcceptableOrUnknown(data['jumlah']!, _jumlahMeta),
      );
    } else if (isInserting) {
      context.missing(_jumlahMeta);
    }
    if (data.containsKey('tanggal')) {
      context.handle(
        _tanggalMeta,
        tanggal.isAcceptableOrUnknown(data['tanggal']!, _tanggalMeta),
      );
    } else if (isInserting) {
      context.missing(_tanggalMeta);
    }
    if (data.containsKey('catatan')) {
      context.handle(
        _catatanMeta,
        catatan.isAcceptableOrUnknown(data['catatan']!, _catatanMeta),
      );
    }
    if (data.containsKey('dibuat_pada')) {
      context.handle(
        _dibuatPadaMeta,
        dibuatPada.isAcceptableOrUnknown(data['dibuat_pada']!, _dibuatPadaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kategori: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kategori'],
      )!,
      jumlah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jumlah'],
      )!,
      tanggal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal'],
      )!,
      catatan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catatan'],
      ),
      dibuatPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dibuat_pada'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final String kategori;
  final int jumlah;
  final DateTime tanggal;
  final String? catatan;
  final DateTime dibuatPada;
  const Expense({
    required this.id,
    required this.kategori,
    required this.jumlah,
    required this.tanggal,
    this.catatan,
    required this.dibuatPada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kategori'] = Variable<String>(kategori);
    map['jumlah'] = Variable<int>(jumlah);
    map['tanggal'] = Variable<DateTime>(tanggal);
    if (!nullToAbsent || catatan != null) {
      map['catatan'] = Variable<String>(catatan);
    }
    map['dibuat_pada'] = Variable<DateTime>(dibuatPada);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      kategori: Value(kategori),
      jumlah: Value(jumlah),
      tanggal: Value(tanggal),
      catatan: catatan == null && nullToAbsent
          ? const Value.absent()
          : Value(catatan),
      dibuatPada: Value(dibuatPada),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      kategori: serializer.fromJson<String>(json['kategori']),
      jumlah: serializer.fromJson<int>(json['jumlah']),
      tanggal: serializer.fromJson<DateTime>(json['tanggal']),
      catatan: serializer.fromJson<String?>(json['catatan']),
      dibuatPada: serializer.fromJson<DateTime>(json['dibuatPada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kategori': serializer.toJson<String>(kategori),
      'jumlah': serializer.toJson<int>(jumlah),
      'tanggal': serializer.toJson<DateTime>(tanggal),
      'catatan': serializer.toJson<String?>(catatan),
      'dibuatPada': serializer.toJson<DateTime>(dibuatPada),
    };
  }

  Expense copyWith({
    int? id,
    String? kategori,
    int? jumlah,
    DateTime? tanggal,
    Value<String?> catatan = const Value.absent(),
    DateTime? dibuatPada,
  }) => Expense(
    id: id ?? this.id,
    kategori: kategori ?? this.kategori,
    jumlah: jumlah ?? this.jumlah,
    tanggal: tanggal ?? this.tanggal,
    catatan: catatan.present ? catatan.value : this.catatan,
    dibuatPada: dibuatPada ?? this.dibuatPada,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      kategori: data.kategori.present ? data.kategori.value : this.kategori,
      jumlah: data.jumlah.present ? data.jumlah.value : this.jumlah,
      tanggal: data.tanggal.present ? data.tanggal.value : this.tanggal,
      catatan: data.catatan.present ? data.catatan.value : this.catatan,
      dibuatPada: data.dibuatPada.present
          ? data.dibuatPada.value
          : this.dibuatPada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('kategori: $kategori, ')
          ..write('jumlah: $jumlah, ')
          ..write('tanggal: $tanggal, ')
          ..write('catatan: $catatan, ')
          ..write('dibuatPada: $dibuatPada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kategori, jumlah, tanggal, catatan, dibuatPada);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.kategori == this.kategori &&
          other.jumlah == this.jumlah &&
          other.tanggal == this.tanggal &&
          other.catatan == this.catatan &&
          other.dibuatPada == this.dibuatPada);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<String> kategori;
  final Value<int> jumlah;
  final Value<DateTime> tanggal;
  final Value<String?> catatan;
  final Value<DateTime> dibuatPada;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.kategori = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.tanggal = const Value.absent(),
    this.catatan = const Value.absent(),
    this.dibuatPada = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required String kategori,
    required int jumlah,
    required DateTime tanggal,
    this.catatan = const Value.absent(),
    this.dibuatPada = const Value.absent(),
  }) : kategori = Value(kategori),
       jumlah = Value(jumlah),
       tanggal = Value(tanggal);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<String>? kategori,
    Expression<int>? jumlah,
    Expression<DateTime>? tanggal,
    Expression<String>? catatan,
    Expression<DateTime>? dibuatPada,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kategori != null) 'kategori': kategori,
      if (jumlah != null) 'jumlah': jumlah,
      if (tanggal != null) 'tanggal': tanggal,
      if (catatan != null) 'catatan': catatan,
      if (dibuatPada != null) 'dibuat_pada': dibuatPada,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<String>? kategori,
    Value<int>? jumlah,
    Value<DateTime>? tanggal,
    Value<String?>? catatan,
    Value<DateTime>? dibuatPada,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      kategori: kategori ?? this.kategori,
      jumlah: jumlah ?? this.jumlah,
      tanggal: tanggal ?? this.tanggal,
      catatan: catatan ?? this.catatan,
      dibuatPada: dibuatPada ?? this.dibuatPada,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kategori.present) {
      map['kategori'] = Variable<String>(kategori.value);
    }
    if (jumlah.present) {
      map['jumlah'] = Variable<int>(jumlah.value);
    }
    if (tanggal.present) {
      map['tanggal'] = Variable<DateTime>(tanggal.value);
    }
    if (catatan.present) {
      map['catatan'] = Variable<String>(catatan.value);
    }
    if (dibuatPada.present) {
      map['dibuat_pada'] = Variable<DateTime>(dibuatPada.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('kategori: $kategori, ')
          ..write('jumlah: $jumlah, ')
          ..write('tanggal: $tanggal, ')
          ..write('catatan: $catatan, ')
          ..write('dibuatPada: $dibuatPada')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kunciMeta = const VerificationMeta('kunci');
  @override
  late final GeneratedColumn<String> kunci = GeneratedColumn<String>(
    'kunci',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nilaiMeta = const VerificationMeta('nilai');
  @override
  late final GeneratedColumn<String> nilai = GeneratedColumn<String>(
    'nilai',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diubahPadaMeta = const VerificationMeta(
    'diubahPada',
  );
  @override
  late final GeneratedColumn<DateTime> diubahPada = GeneratedColumn<DateTime>(
    'diubah_pada',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  @override
  List<GeneratedColumn> get $columns => [kunci, nilai, diubahPada];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('kunci')) {
      context.handle(
        _kunciMeta,
        kunci.isAcceptableOrUnknown(data['kunci']!, _kunciMeta),
      );
    } else if (isInserting) {
      context.missing(_kunciMeta);
    }
    if (data.containsKey('nilai')) {
      context.handle(
        _nilaiMeta,
        nilai.isAcceptableOrUnknown(data['nilai']!, _nilaiMeta),
      );
    } else if (isInserting) {
      context.missing(_nilaiMeta);
    }
    if (data.containsKey('diubah_pada')) {
      context.handle(
        _diubahPadaMeta,
        diubahPada.isAcceptableOrUnknown(data['diubah_pada']!, _diubahPadaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {kunci};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      kunci: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kunci'],
      )!,
      nilai: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nilai'],
      )!,
      diubahPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}diubah_pada'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String kunci;
  final String nilai;
  final DateTime diubahPada;
  const Setting({
    required this.kunci,
    required this.nilai,
    required this.diubahPada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['kunci'] = Variable<String>(kunci);
    map['nilai'] = Variable<String>(nilai);
    map['diubah_pada'] = Variable<DateTime>(diubahPada);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      kunci: Value(kunci),
      nilai: Value(nilai),
      diubahPada: Value(diubahPada),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      kunci: serializer.fromJson<String>(json['kunci']),
      nilai: serializer.fromJson<String>(json['nilai']),
      diubahPada: serializer.fromJson<DateTime>(json['diubahPada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'kunci': serializer.toJson<String>(kunci),
      'nilai': serializer.toJson<String>(nilai),
      'diubahPada': serializer.toJson<DateTime>(diubahPada),
    };
  }

  Setting copyWith({String? kunci, String? nilai, DateTime? diubahPada}) =>
      Setting(
        kunci: kunci ?? this.kunci,
        nilai: nilai ?? this.nilai,
        diubahPada: diubahPada ?? this.diubahPada,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      kunci: data.kunci.present ? data.kunci.value : this.kunci,
      nilai: data.nilai.present ? data.nilai.value : this.nilai,
      diubahPada: data.diubahPada.present
          ? data.diubahPada.value
          : this.diubahPada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('kunci: $kunci, ')
          ..write('nilai: $nilai, ')
          ..write('diubahPada: $diubahPada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(kunci, nilai, diubahPada);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.kunci == this.kunci &&
          other.nilai == this.nilai &&
          other.diubahPada == this.diubahPada);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> kunci;
  final Value<String> nilai;
  final Value<DateTime> diubahPada;
  final Value<int> rowid;
  const SettingsCompanion({
    this.kunci = const Value.absent(),
    this.nilai = const Value.absent(),
    this.diubahPada = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String kunci,
    required String nilai,
    this.diubahPada = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : kunci = Value(kunci),
       nilai = Value(nilai);
  static Insertable<Setting> custom({
    Expression<String>? kunci,
    Expression<String>? nilai,
    Expression<DateTime>? diubahPada,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (kunci != null) 'kunci': kunci,
      if (nilai != null) 'nilai': nilai,
      if (diubahPada != null) 'diubah_pada': diubahPada,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? kunci,
    Value<String>? nilai,
    Value<DateTime>? diubahPada,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      kunci: kunci ?? this.kunci,
      nilai: nilai ?? this.nilai,
      diubahPada: diubahPada ?? this.diubahPada,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (kunci.present) {
      map['kunci'] = Variable<String>(kunci.value);
    }
    if (nilai.present) {
      map['nilai'] = Variable<String>(nilai.value);
    }
    if (diubahPada.present) {
      map['diubah_pada'] = Variable<DateTime>(diubahPada.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('kunci: $kunci, ')
          ..write('nilai: $nilai, ')
          ..write('diubahPada: $diubahPada, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LicensesTable extends Licenses with TableInfo<$LicensesTable, License> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LicensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kodeMeta = const VerificationMeta('kode');
  @override
  late final GeneratedColumn<String> kode = GeneratedColumn<String>(
    'kode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _idPerangkatMeta = const VerificationMeta(
    'idPerangkat',
  );
  @override
  late final GeneratedColumn<String> idPerangkat = GeneratedColumn<String>(
    'id_perangkat',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 80),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diaktifkanPadaMeta = const VerificationMeta(
    'diaktifkanPada',
  );
  @override
  late final GeneratedColumn<DateTime> diaktifkanPada =
      GeneratedColumn<DateTime>(
        'diaktifkan_pada',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        clientDefault: nowUtc,
      );
  @override
  List<GeneratedColumn> get $columns => [id, kode, idPerangkat, diaktifkanPada];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'licenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<License> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kode')) {
      context.handle(
        _kodeMeta,
        kode.isAcceptableOrUnknown(data['kode']!, _kodeMeta),
      );
    } else if (isInserting) {
      context.missing(_kodeMeta);
    }
    if (data.containsKey('id_perangkat')) {
      context.handle(
        _idPerangkatMeta,
        idPerangkat.isAcceptableOrUnknown(
          data['id_perangkat']!,
          _idPerangkatMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idPerangkatMeta);
    }
    if (data.containsKey('diaktifkan_pada')) {
      context.handle(
        _diaktifkanPadaMeta,
        diaktifkanPada.isAcceptableOrUnknown(
          data['diaktifkan_pada']!,
          _diaktifkanPadaMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  License map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return License(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kode'],
      )!,
      idPerangkat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id_perangkat'],
      )!,
      diaktifkanPada: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}diaktifkan_pada'],
      )!,
    );
  }

  @override
  $LicensesTable createAlias(String alias) {
    return $LicensesTable(attachedDatabase, alias);
  }
}

class License extends DataClass implements Insertable<License> {
  final int id;
  final String kode;
  final String idPerangkat;
  final DateTime diaktifkanPada;
  const License({
    required this.id,
    required this.kode,
    required this.idPerangkat,
    required this.diaktifkanPada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kode'] = Variable<String>(kode);
    map['id_perangkat'] = Variable<String>(idPerangkat);
    map['diaktifkan_pada'] = Variable<DateTime>(diaktifkanPada);
    return map;
  }

  LicensesCompanion toCompanion(bool nullToAbsent) {
    return LicensesCompanion(
      id: Value(id),
      kode: Value(kode),
      idPerangkat: Value(idPerangkat),
      diaktifkanPada: Value(diaktifkanPada),
    );
  }

  factory License.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return License(
      id: serializer.fromJson<int>(json['id']),
      kode: serializer.fromJson<String>(json['kode']),
      idPerangkat: serializer.fromJson<String>(json['idPerangkat']),
      diaktifkanPada: serializer.fromJson<DateTime>(json['diaktifkanPada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kode': serializer.toJson<String>(kode),
      'idPerangkat': serializer.toJson<String>(idPerangkat),
      'diaktifkanPada': serializer.toJson<DateTime>(diaktifkanPada),
    };
  }

  License copyWith({
    int? id,
    String? kode,
    String? idPerangkat,
    DateTime? diaktifkanPada,
  }) => License(
    id: id ?? this.id,
    kode: kode ?? this.kode,
    idPerangkat: idPerangkat ?? this.idPerangkat,
    diaktifkanPada: diaktifkanPada ?? this.diaktifkanPada,
  );
  License copyWithCompanion(LicensesCompanion data) {
    return License(
      id: data.id.present ? data.id.value : this.id,
      kode: data.kode.present ? data.kode.value : this.kode,
      idPerangkat: data.idPerangkat.present
          ? data.idPerangkat.value
          : this.idPerangkat,
      diaktifkanPada: data.diaktifkanPada.present
          ? data.diaktifkanPada.value
          : this.diaktifkanPada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('License(')
          ..write('id: $id, ')
          ..write('kode: $kode, ')
          ..write('idPerangkat: $idPerangkat, ')
          ..write('diaktifkanPada: $diaktifkanPada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kode, idPerangkat, diaktifkanPada);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is License &&
          other.id == this.id &&
          other.kode == this.kode &&
          other.idPerangkat == this.idPerangkat &&
          other.diaktifkanPada == this.diaktifkanPada);
}

class LicensesCompanion extends UpdateCompanion<License> {
  final Value<int> id;
  final Value<String> kode;
  final Value<String> idPerangkat;
  final Value<DateTime> diaktifkanPada;
  const LicensesCompanion({
    this.id = const Value.absent(),
    this.kode = const Value.absent(),
    this.idPerangkat = const Value.absent(),
    this.diaktifkanPada = const Value.absent(),
  });
  LicensesCompanion.insert({
    this.id = const Value.absent(),
    required String kode,
    required String idPerangkat,
    this.diaktifkanPada = const Value.absent(),
  }) : kode = Value(kode),
       idPerangkat = Value(idPerangkat);
  static Insertable<License> custom({
    Expression<int>? id,
    Expression<String>? kode,
    Expression<String>? idPerangkat,
    Expression<DateTime>? diaktifkanPada,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kode != null) 'kode': kode,
      if (idPerangkat != null) 'id_perangkat': idPerangkat,
      if (diaktifkanPada != null) 'diaktifkan_pada': diaktifkanPada,
    });
  }

  LicensesCompanion copyWith({
    Value<int>? id,
    Value<String>? kode,
    Value<String>? idPerangkat,
    Value<DateTime>? diaktifkanPada,
  }) {
    return LicensesCompanion(
      id: id ?? this.id,
      kode: kode ?? this.kode,
      idPerangkat: idPerangkat ?? this.idPerangkat,
      diaktifkanPada: diaktifkanPada ?? this.diaktifkanPada,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kode.present) {
      map['kode'] = Variable<String>(kode.value);
    }
    if (idPerangkat.present) {
      map['id_perangkat'] = Variable<String>(idPerangkat.value);
    }
    if (diaktifkanPada.present) {
      map['diaktifkan_pada'] = Variable<DateTime>(diaktifkanPada.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LicensesCompanion(')
          ..write('id: $id, ')
          ..write('kode: $kode, ')
          ..write('idPerangkat: $idPerangkat, ')
          ..write('diaktifkanPada: $diaktifkanPada')
          ..write(')'))
        .toString();
  }
}

class $NotaCountersTable extends NotaCounters
    with TableInfo<$NotaCountersTable, NotaCounter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotaCountersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tanggalMeta = const VerificationMeta(
    'tanggal',
  );
  @override
  late final GeneratedColumn<String> tanggal = GeneratedColumn<String>(
    'tanggal',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 8,
      maxTextLength: 8,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urutanMeta = const VerificationMeta('urutan');
  @override
  late final GeneratedColumn<int> urutan = GeneratedColumn<int>(
    'urutan',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [tanggal, urutan];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nota_counters';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotaCounter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('tanggal')) {
      context.handle(
        _tanggalMeta,
        tanggal.isAcceptableOrUnknown(data['tanggal']!, _tanggalMeta),
      );
    } else if (isInserting) {
      context.missing(_tanggalMeta);
    }
    if (data.containsKey('urutan')) {
      context.handle(
        _urutanMeta,
        urutan.isAcceptableOrUnknown(data['urutan']!, _urutanMeta),
      );
    } else if (isInserting) {
      context.missing(_urutanMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tanggal};
  @override
  NotaCounter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotaCounter(
      tanggal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tanggal'],
      )!,
      urutan: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}urutan'],
      )!,
    );
  }

  @override
  $NotaCountersTable createAlias(String alias) {
    return $NotaCountersTable(attachedDatabase, alias);
  }
}

class NotaCounter extends DataClass implements Insertable<NotaCounter> {
  /// Format `yyyyMMdd`, mis. `20261027`.
  final String tanggal;
  final int urutan;
  const NotaCounter({required this.tanggal, required this.urutan});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['tanggal'] = Variable<String>(tanggal);
    map['urutan'] = Variable<int>(urutan);
    return map;
  }

  NotaCountersCompanion toCompanion(bool nullToAbsent) {
    return NotaCountersCompanion(
      tanggal: Value(tanggal),
      urutan: Value(urutan),
    );
  }

  factory NotaCounter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotaCounter(
      tanggal: serializer.fromJson<String>(json['tanggal']),
      urutan: serializer.fromJson<int>(json['urutan']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tanggal': serializer.toJson<String>(tanggal),
      'urutan': serializer.toJson<int>(urutan),
    };
  }

  NotaCounter copyWith({String? tanggal, int? urutan}) => NotaCounter(
    tanggal: tanggal ?? this.tanggal,
    urutan: urutan ?? this.urutan,
  );
  NotaCounter copyWithCompanion(NotaCountersCompanion data) {
    return NotaCounter(
      tanggal: data.tanggal.present ? data.tanggal.value : this.tanggal,
      urutan: data.urutan.present ? data.urutan.value : this.urutan,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotaCounter(')
          ..write('tanggal: $tanggal, ')
          ..write('urutan: $urutan')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(tanggal, urutan);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotaCounter &&
          other.tanggal == this.tanggal &&
          other.urutan == this.urutan);
}

class NotaCountersCompanion extends UpdateCompanion<NotaCounter> {
  final Value<String> tanggal;
  final Value<int> urutan;
  final Value<int> rowid;
  const NotaCountersCompanion({
    this.tanggal = const Value.absent(),
    this.urutan = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotaCountersCompanion.insert({
    required String tanggal,
    required int urutan,
    this.rowid = const Value.absent(),
  }) : tanggal = Value(tanggal),
       urutan = Value(urutan);
  static Insertable<NotaCounter> custom({
    Expression<String>? tanggal,
    Expression<int>? urutan,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tanggal != null) 'tanggal': tanggal,
      if (urutan != null) 'urutan': urutan,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotaCountersCompanion copyWith({
    Value<String>? tanggal,
    Value<int>? urutan,
    Value<int>? rowid,
  }) {
    return NotaCountersCompanion(
      tanggal: tanggal ?? this.tanggal,
      urutan: urutan ?? this.urutan,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tanggal.present) {
      map['tanggal'] = Variable<String>(tanggal.value);
    }
    if (urutan.present) {
      map['urutan'] = Variable<int>(urutan.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotaCountersCompanion(')
          ..write('tanggal: $tanggal, ')
          ..write('urutan: $urutan, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $ServicesTable services = $ServicesTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $OrderStatusHistoryTable orderStatusHistory =
      $OrderStatusHistoryTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $LicensesTable licenses = $LicensesTable(this);
  late final $NotaCountersTable notaCounters = $NotaCountersTable(this);
  late final Index idxCustomersNama = Index(
    'idx_customers_nama',
    'CREATE INDEX idx_customers_nama ON customers (nama)',
  );
  late final Index idxCustomersTelepon = Index(
    'idx_customers_telepon',
    'CREATE INDEX idx_customers_telepon ON customers (telepon)',
  );
  late final Index idxOrdersCustomer = Index(
    'idx_orders_customer',
    'CREATE INDEX idx_orders_customer ON orders (customer_id)',
  );
  late final Index idxOrdersTanggalMasuk = Index(
    'idx_orders_tanggal_masuk',
    'CREATE INDEX idx_orders_tanggal_masuk ON orders (tanggal_masuk)',
  );
  late final Index idxOrdersStatus = Index(
    'idx_orders_status',
    'CREATE INDEX idx_orders_status ON orders (status)',
  );
  late final Index idxOrderItemsOrder = Index(
    'idx_order_items_order',
    'CREATE INDEX idx_order_items_order ON order_items (order_id)',
  );
  late final Index idxPaymentsOrder = Index(
    'idx_payments_order',
    'CREATE INDEX idx_payments_order ON payments (order_id)',
  );
  late final Index idxPaymentsTanggal = Index(
    'idx_payments_tanggal',
    'CREATE INDEX idx_payments_tanggal ON payments (tanggal)',
  );
  late final Index idxStatusHistoryOrder = Index(
    'idx_status_history_order',
    'CREATE INDEX idx_status_history_order ON order_status_history (order_id)',
  );
  late final Index idxExpensesTanggal = Index(
    'idx_expenses_tanggal',
    'CREATE INDEX idx_expenses_tanggal ON expenses (tanggal)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    customers,
    services,
    orders,
    orderItems,
    payments,
    orderStatusHistory,
    expenses,
    settings,
    licenses,
    notaCounters,
    idxCustomersNama,
    idxCustomersTelepon,
    idxOrdersCustomer,
    idxOrdersTanggalMasuk,
    idxOrdersStatus,
    idxOrderItemsOrder,
    idxPaymentsOrder,
    idxPaymentsTanggal,
    idxStatusHistoryOrder,
    idxExpensesTanggal,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'orders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('order_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'orders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('order_status_history', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  required String nama,
  required String telepon,
  Value<String?> alamat,
  Value<String?> catatan,
  Value<int> poin,
  Value<DateTime> dibuatPada,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<int> id,
  Value<String> nama,
  Value<String> telepon,
  Value<String?> alamat,
  Value<String?> catatan,
  Value<int> poin,
  Value<DateTime> dibuatPada,
});

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, CustomerRow> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrdersTable, List<Order>> _ordersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.orders,
    aliasName: 'customers__id__orders__customer_id',
  );

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telepon => $composableBuilder(
    column: $table.telepon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alamat => $composableBuilder(
    column: $table.alamat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get poin => $composableBuilder(
    column: $table.poin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ordersRefs(
    Expression<bool> Function($$OrdersTableFilterComposer f) f,
  ) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telepon => $composableBuilder(
    column: $table.telepon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alamat => $composableBuilder(
    column: $table.alamat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get poin => $composableBuilder(
    column: $table.poin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<String> get telepon =>
      $composableBuilder(column: $table.telepon, builder: (column) => column);

  GeneratedColumn<String> get alamat =>
      $composableBuilder(column: $table.alamat, builder: (column) => column);

  GeneratedColumn<String> get catatan =>
      $composableBuilder(column: $table.catatan, builder: (column) => column);

  GeneratedColumn<int> get poin =>
      $composableBuilder(column: $table.poin, builder: (column) => column);

  GeneratedColumn<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => column,
  );

  Expression<T> ordersRefs<T extends Object>(
    Expression<T> Function($$OrdersTableAnnotationComposer a) f,
  ) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          CustomerRow,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (CustomerRow, $$CustomersTableReferences),
          CustomerRow,
          PrefetchHooks Function({bool ordersRefs})
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<String> telepon = const Value.absent(),
                Value<String?> alamat = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                Value<int> poin = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                nama: nama,
                telepon: telepon,
                alamat: alamat,
                catatan: catatan,
                poin: poin,
                dibuatPada: dibuatPada,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nama,
                required String telepon,
                Value<String?> alamat = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                Value<int> poin = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                nama: nama,
                telepon: telepon,
                alamat: alamat,
                catatan: catatan,
                poin: poin,
                dibuatPada: dibuatPada,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomersTable, CustomerRow>(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ordersRefs) db.orders],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordersRefs)
                    await $_getPrefetchedDataByColumns<
                      CustomerRow,
                      $CustomersTable,
                      Order,
                      $OrdersTable
                    >(
                      currentTable: table,
                      referencedTable: $$CustomersTableReferences
                          ._ordersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CustomersTableReferences(db, table, p0).ordersRefs,
                      currentColumn: 'id',
                      referencedColumn: 'customer_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      CustomerRow,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (CustomerRow, $$CustomersTableReferences),
      CustomerRow,
      PrefetchHooks Function({bool ordersRefs})
    >;
typedef $$ServicesTableCreateCompanionBuilder = ServicesCompanion Function({
  Value<int> id,
  required String nama,
  Value<String?> kategori,
  required ServiceUnit satuan,
  required int harga,
  Value<bool> aktif,
  Value<DateTime> dibuatPada,
});
typedef $$ServicesTableUpdateCompanionBuilder = ServicesCompanion Function({
  Value<int> id,
  Value<String> nama,
  Value<String?> kategori,
  Value<ServiceUnit> satuan,
  Value<int> harga,
  Value<bool> aktif,
  Value<DateTime> dibuatPada,
});

final class $$ServicesTableReferences
    extends BaseReferences<_$AppDatabase, $ServicesTable, Service> {
  $$ServicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
  _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItems,
    aliasName: 'services__id__order_items__service_id',
  );

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager(
      $_db,
      $_db.orderItems,
    ).filter((f) => f.serviceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServicesTableFilterComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kategori => $composableBuilder(
    column: $table.kategori,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ServiceUnit, ServiceUnit, int> get satuan =>
      $composableBuilder(
        column: $table.satuan,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get harga => $composableBuilder(
    column: $table.harga,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get aktif => $composableBuilder(
    column: $table.aktif,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> orderItemsRefs(
    Expression<bool> Function($$OrderItemsTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.serviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServicesTableOrderingComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kategori => $composableBuilder(
    column: $table.kategori,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get satuan => $composableBuilder(
    column: $table.satuan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get harga => $composableBuilder(
    column: $table.harga,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get aktif => $composableBuilder(
    column: $table.aktif,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServicesTable> {
  $$ServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<String> get kategori =>
      $composableBuilder(column: $table.kategori, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ServiceUnit, int> get satuan =>
      $composableBuilder(column: $table.satuan, builder: (column) => column);

  GeneratedColumn<int> get harga =>
      $composableBuilder(column: $table.harga, builder: (column) => column);

  GeneratedColumn<bool> get aktif =>
      $composableBuilder(column: $table.aktif, builder: (column) => column);

  GeneratedColumn<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => column,
  );

  Expression<T> orderItemsRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.serviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ServicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServicesTable,
          Service,
          $$ServicesTableFilterComposer,
          $$ServicesTableOrderingComposer,
          $$ServicesTableAnnotationComposer,
          $$ServicesTableCreateCompanionBuilder,
          $$ServicesTableUpdateCompanionBuilder,
          (Service, $$ServicesTableReferences),
          Service,
          PrefetchHooks Function({bool orderItemsRefs})
        > {
  $$ServicesTableTableManager(_$AppDatabase db, $ServicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<String?> kategori = const Value.absent(),
                Value<ServiceUnit> satuan = const Value.absent(),
                Value<int> harga = const Value.absent(),
                Value<bool> aktif = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
              }) => ServicesCompanion(
                id: id,
                nama: nama,
                kategori: kategori,
                satuan: satuan,
                harga: harga,
                aktif: aktif,
                dibuatPada: dibuatPada,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nama,
                Value<String?> kategori = const Value.absent(),
                required ServiceUnit satuan,
                required int harga,
                Value<bool> aktif = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
              }) => ServicesCompanion.insert(
                id: id,
                nama: nama,
                kategori: kategori,
                satuan: satuan,
                harga: harga,
                aktif: aktif,
                dibuatPada: dibuatPada,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ServicesTable, Service>(table),
                  $$ServicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (orderItemsRefs) db.orderItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderItemsRefs)
                    await $_getPrefetchedDataByColumns<
                      Service,
                      $ServicesTable,
                      OrderItem,
                      $OrderItemsTable
                    >(
                      currentTable: table,
                      referencedTable: $$ServicesTableReferences
                          ._orderItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ServicesTableReferences(
                        db,
                        table,
                        p0,
                      ).orderItemsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'service_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ServicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServicesTable,
      Service,
      $$ServicesTableFilterComposer,
      $$ServicesTableOrderingComposer,
      $$ServicesTableAnnotationComposer,
      $$ServicesTableCreateCompanionBuilder,
      $$ServicesTableUpdateCompanionBuilder,
      (Service, $$ServicesTableReferences),
      Service,
      PrefetchHooks Function({bool orderItemsRefs})
    >;
typedef $$OrdersTableCreateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  required String nomorNota,
  required String qrToken,
  required int customerId,
  required DateTime tanggalMasuk,
  Value<DateTime?> estimasiSelesai,
  Value<OrderStatus> status,
  Value<int> diskon,
  required int total,
  Value<String?> catatan,
  Value<DateTime> dibuatPada,
  Value<DateTime> diubahPada,
  Value<DateTime?> dihapusPada,
});
typedef $$OrdersTableUpdateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  Value<String> nomorNota,
  Value<String> qrToken,
  Value<int> customerId,
  Value<DateTime> tanggalMasuk,
  Value<DateTime?> estimasiSelesai,
  Value<OrderStatus> status,
  Value<int> diskon,
  Value<int> total,
  Value<String?> catatan,
  Value<DateTime> dibuatPada,
  Value<DateTime> diubahPada,
  Value<DateTime?> dihapusPada,
});

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, Order> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('orders__customer_id__customers__id');

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<int>('customer_id')!;

    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
  _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderItems,
    aliasName: 'orders__id__order_items__order_id',
  );

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager(
      $_db,
      $_db.orderItems,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: 'orders__id__payments__order_id',
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrderStatusHistoryTable, List<StatusHistoryEntry>>
  _orderStatusHistoryRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.orderStatusHistory,
        aliasName: 'orders__id__order_status_history__order_id',
      );

  $$OrderStatusHistoryTableProcessedTableManager get orderStatusHistoryRefs {
    final manager = $$OrderStatusHistoryTableTableManager(
      $_db,
      $_db.orderStatusHistory,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _orderStatusHistoryRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomorNota => $composableBuilder(
    column: $table.nomorNota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qrToken => $composableBuilder(
    column: $table.qrToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggalMasuk => $composableBuilder(
    column: $table.tanggalMasuk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get estimasiSelesai => $composableBuilder(
    column: $table.estimasiSelesai,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OrderStatus, OrderStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get diskon => $composableBuilder(
    column: $table.diskon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get diubahPada => $composableBuilder(
    column: $table.diubahPada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dihapusPada => $composableBuilder(
    column: $table.dihapusPada,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> orderItemsRefs(
    Expression<bool> Function($$OrderItemsTableFilterComposer f) f,
  ) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableFilterComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> orderStatusHistoryRefs(
    Expression<bool> Function($$OrderStatusHistoryTableFilterComposer f) f,
  ) {
    final $$OrderStatusHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderStatusHistory,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderStatusHistoryTableFilterComposer(
            $db: $db,
            $table: $db.orderStatusHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomorNota => $composableBuilder(
    column: $table.nomorNota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qrToken => $composableBuilder(
    column: $table.qrToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggalMasuk => $composableBuilder(
    column: $table.tanggalMasuk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get estimasiSelesai => $composableBuilder(
    column: $table.estimasiSelesai,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diskon => $composableBuilder(
    column: $table.diskon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get diubahPada => $composableBuilder(
    column: $table.diubahPada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dihapusPada => $composableBuilder(
    column: $table.dihapusPada,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nomorNota =>
      $composableBuilder(column: $table.nomorNota, builder: (column) => column);

  GeneratedColumn<String> get qrToken =>
      $composableBuilder(column: $table.qrToken, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggalMasuk => $composableBuilder(
    column: $table.tanggalMasuk,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get estimasiSelesai => $composableBuilder(
    column: $table.estimasiSelesai,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<OrderStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get diskon =>
      $composableBuilder(column: $table.diskon, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get catatan =>
      $composableBuilder(column: $table.catatan, builder: (column) => column);

  GeneratedColumn<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get diubahPada => $composableBuilder(
    column: $table.diubahPada,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dihapusPada => $composableBuilder(
    column: $table.dihapusPada,
    builder: (column) => column,
  );

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> orderItemsRefs<T extends Object>(
    Expression<T> Function($$OrderItemsTableAnnotationComposer a) f,
  ) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderItems,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.orderItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> orderStatusHistoryRefs<T extends Object>(
    Expression<T> Function($$OrderStatusHistoryTableAnnotationComposer a) f,
  ) {
    final $$OrderStatusHistoryTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.orderStatusHistory,
          getReferencedColumn: (t) => t.orderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OrderStatusHistoryTableAnnotationComposer(
                $db: $db,
                $table: $db.orderStatusHistory,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTable,
          Order,
          $$OrdersTableFilterComposer,
          $$OrdersTableOrderingComposer,
          $$OrdersTableAnnotationComposer,
          $$OrdersTableCreateCompanionBuilder,
          $$OrdersTableUpdateCompanionBuilder,
          (Order, $$OrdersTableReferences),
          Order,
          PrefetchHooks Function({
            bool customerId,
            bool orderItemsRefs,
            bool paymentsRefs,
            bool orderStatusHistoryRefs,
          })
        > {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nomorNota = const Value.absent(),
                Value<String> qrToken = const Value.absent(),
                Value<int> customerId = const Value.absent(),
                Value<DateTime> tanggalMasuk = const Value.absent(),
                Value<DateTime?> estimasiSelesai = const Value.absent(),
                Value<OrderStatus> status = const Value.absent(),
                Value<int> diskon = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
                Value<DateTime> diubahPada = const Value.absent(),
                Value<DateTime?> dihapusPada = const Value.absent(),
              }) => OrdersCompanion(
                id: id,
                nomorNota: nomorNota,
                qrToken: qrToken,
                customerId: customerId,
                tanggalMasuk: tanggalMasuk,
                estimasiSelesai: estimasiSelesai,
                status: status,
                diskon: diskon,
                total: total,
                catatan: catatan,
                dibuatPada: dibuatPada,
                diubahPada: diubahPada,
                dihapusPada: dihapusPada,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nomorNota,
                required String qrToken,
                required int customerId,
                required DateTime tanggalMasuk,
                Value<DateTime?> estimasiSelesai = const Value.absent(),
                Value<OrderStatus> status = const Value.absent(),
                Value<int> diskon = const Value.absent(),
                required int total,
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
                Value<DateTime> diubahPada = const Value.absent(),
                Value<DateTime?> dihapusPada = const Value.absent(),
              }) => OrdersCompanion.insert(
                id: id,
                nomorNota: nomorNota,
                qrToken: qrToken,
                customerId: customerId,
                tanggalMasuk: tanggalMasuk,
                estimasiSelesai: estimasiSelesai,
                status: status,
                diskon: diskon,
                total: total,
                catatan: catatan,
                dibuatPada: dibuatPada,
                diubahPada: diubahPada,
                dihapusPada: dihapusPada,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrdersTable, Order>(table),
                  $$OrdersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customerId = false,
                orderItemsRefs = false,
                paymentsRefs = false,
                orderStatusHistoryRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (orderItemsRefs) db.orderItems,
                    if (paymentsRefs) db.payments,
                    if (orderStatusHistoryRefs) db.orderStatusHistory,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.customerId,
                            referencedTable: $$OrdersTableReferences
                                ._customerIdTable(db),
                            referencedColumn: $$OrdersTableReferences
                                ._customerIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (orderItemsRefs)
                        await $_getPrefetchedDataByColumns<
                          Order,
                          $OrdersTable,
                          OrderItem,
                          $OrderItemsTable
                        >(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._orderItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).orderItemsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'order_id',
                          typedResults: items,
                        ),
                      if (paymentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Order,
                          $OrdersTable,
                          Payment,
                          $PaymentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._paymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'order_id',
                          typedResults: items,
                        ),
                      if (orderStatusHistoryRefs)
                        await $_getPrefetchedDataByColumns<
                          Order,
                          $OrdersTable,
                          StatusHistoryEntry,
                          $OrderStatusHistoryTable
                        >(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._orderStatusHistoryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).orderStatusHistoryRefs,
                          currentColumn: 'id',
                          referencedColumn: 'order_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTable,
      Order,
      $$OrdersTableFilterComposer,
      $$OrdersTableOrderingComposer,
      $$OrdersTableAnnotationComposer,
      $$OrdersTableCreateCompanionBuilder,
      $$OrdersTableUpdateCompanionBuilder,
      (Order, $$OrdersTableReferences),
      Order,
      PrefetchHooks Function({
        bool customerId,
        bool orderItemsRefs,
        bool paymentsRefs,
        bool orderStatusHistoryRefs,
      })
    >;
typedef $$OrderItemsTableCreateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  required int orderId,
  required int serviceId,
  required String namaLayanan,
  required int qtyMilli,
  required int hargaSatuan,
  required int subtotal,
  Value<DateTime> dibuatPada,
});
typedef $$OrderItemsTableUpdateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  Value<int> orderId,
  Value<int> serviceId,
  Value<String> namaLayanan,
  Value<int> qtyMilli,
  Value<int> hargaSatuan,
  Value<int> subtotal,
  Value<DateTime> dibuatPada,
});

final class $$OrderItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem> {
  $$OrderItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) =>
      db.orders.createAlias('order_items__order_id__orders__id');

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ServicesTable _serviceIdTable(_$AppDatabase db) =>
      db.services.createAlias('order_items__service_id__services__id');

  $$ServicesTableProcessedTableManager get serviceId {
    final $_column = $_itemColumn<int>('service_id')!;

    final manager = $$ServicesTableTableManager(
      $_db,
      $_db.services,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaLayanan => $composableBuilder(
    column: $table.namaLayanan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qtyMilli => $composableBuilder(
    column: $table.qtyMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hargaSatuan => $composableBuilder(
    column: $table.hargaSatuan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServicesTableFilterComposer get serviceId {
    final $$ServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableFilterComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaLayanan => $composableBuilder(
    column: $table.namaLayanan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qtyMilli => $composableBuilder(
    column: $table.qtyMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hargaSatuan => $composableBuilder(
    column: $table.hargaSatuan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServicesTableOrderingComposer get serviceId {
    final $$ServicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableOrderingComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get namaLayanan => $composableBuilder(
    column: $table.namaLayanan,
    builder: (column) => column,
  );

  GeneratedColumn<int> get qtyMilli =>
      $composableBuilder(column: $table.qtyMilli, builder: (column) => column);

  GeneratedColumn<int> get hargaSatuan => $composableBuilder(
    column: $table.hargaSatuan,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => column,
  );

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServicesTableAnnotationComposer get serviceId {
    final $$ServicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableAnnotationComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderItemsTable,
          OrderItem,
          $$OrderItemsTableFilterComposer,
          $$OrderItemsTableOrderingComposer,
          $$OrderItemsTableAnnotationComposer,
          $$OrderItemsTableCreateCompanionBuilder,
          $$OrderItemsTableUpdateCompanionBuilder,
          (OrderItem, $$OrderItemsTableReferences),
          OrderItem,
          PrefetchHooks Function({bool orderId, bool serviceId})
        > {
  $$OrderItemsTableTableManager(_$AppDatabase db, $OrderItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> orderId = const Value.absent(),
                Value<int> serviceId = const Value.absent(),
                Value<String> namaLayanan = const Value.absent(),
                Value<int> qtyMilli = const Value.absent(),
                Value<int> hargaSatuan = const Value.absent(),
                Value<int> subtotal = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
              }) => OrderItemsCompanion(
                id: id,
                orderId: orderId,
                serviceId: serviceId,
                namaLayanan: namaLayanan,
                qtyMilli: qtyMilli,
                hargaSatuan: hargaSatuan,
                subtotal: subtotal,
                dibuatPada: dibuatPada,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int orderId,
                required int serviceId,
                required String namaLayanan,
                required int qtyMilli,
                required int hargaSatuan,
                required int subtotal,
                Value<DateTime> dibuatPada = const Value.absent(),
              }) => OrderItemsCompanion.insert(
                id: id,
                orderId: orderId,
                serviceId: serviceId,
                namaLayanan: namaLayanan,
                qtyMilli: qtyMilli,
                hargaSatuan: hargaSatuan,
                subtotal: subtotal,
                dibuatPada: dibuatPada,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrderItemsTable, OrderItem>(table),
                  $$OrderItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderId = false, serviceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (orderId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.orderId,
                        referencedTable: $$OrderItemsTableReferences
                            ._orderIdTable(db),
                        referencedColumn: $$OrderItemsTableReferences
                            ._orderIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (serviceId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.serviceId,
                        referencedTable: $$OrderItemsTableReferences
                            ._serviceIdTable(db),
                        referencedColumn: $$OrderItemsTableReferences
                            ._serviceIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OrderItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderItemsTable,
      OrderItem,
      $$OrderItemsTableFilterComposer,
      $$OrderItemsTableOrderingComposer,
      $$OrderItemsTableAnnotationComposer,
      $$OrderItemsTableCreateCompanionBuilder,
      $$OrderItemsTableUpdateCompanionBuilder,
      (OrderItem, $$OrderItemsTableReferences),
      OrderItem,
      PrefetchHooks Function({bool orderId, bool serviceId})
    >;
typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  required int orderId,
  required int jumlah,
  required PaymentMethod metode,
  required DateTime tanggal,
  Value<String?> catatan,
  Value<DateTime> dibuatPada,
  Value<DateTime?> dihapusPada,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  Value<int> orderId,
  Value<int> jumlah,
  Value<PaymentMethod> metode,
  Value<DateTime> tanggal,
  Value<String?> catatan,
  Value<DateTime> dibuatPada,
  Value<DateTime?> dihapusPada,
});

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) =>
      db.orders.createAlias('payments__order_id__orders__id');

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentMethod, PaymentMethod, int>
  get metode => $composableBuilder(
    column: $table.metode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dihapusPada => $composableBuilder(
    column: $table.dihapusPada,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get metode => $composableBuilder(
    column: $table.metode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dihapusPada => $composableBuilder(
    column: $table.dihapusPada,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get jumlah =>
      $composableBuilder(column: $table.jumlah, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaymentMethod, int> get metode =>
      $composableBuilder(column: $table.metode, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggal =>
      $composableBuilder(column: $table.tanggal, builder: (column) => column);

  GeneratedColumn<String> get catatan =>
      $composableBuilder(column: $table.catatan, builder: (column) => column);

  GeneratedColumn<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dihapusPada => $composableBuilder(
    column: $table.dihapusPada,
    builder: (column) => column,
  );

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, $$PaymentsTableReferences),
          Payment,
          PrefetchHooks Function({bool orderId})
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> orderId = const Value.absent(),
                Value<int> jumlah = const Value.absent(),
                Value<PaymentMethod> metode = const Value.absent(),
                Value<DateTime> tanggal = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
                Value<DateTime?> dihapusPada = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                orderId: orderId,
                jumlah: jumlah,
                metode: metode,
                tanggal: tanggal,
                catatan: catatan,
                dibuatPada: dibuatPada,
                dihapusPada: dihapusPada,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int orderId,
                required int jumlah,
                required PaymentMethod metode,
                required DateTime tanggal,
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
                Value<DateTime?> dihapusPada = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                orderId: orderId,
                jumlah: jumlah,
                metode: metode,
                tanggal: tanggal,
                catatan: catatan,
                dibuatPada: dibuatPada,
                dihapusPada: dihapusPada,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentsTable, Payment>(table),
                  $$PaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (orderId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.orderId,
                        referencedTable: $$PaymentsTableReferences
                            ._orderIdTable(db),
                        referencedColumn: $$PaymentsTableReferences
                            ._orderIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, $$PaymentsTableReferences),
      Payment,
      PrefetchHooks Function({bool orderId})
    >;
typedef $$OrderStatusHistoryTableCreateCompanionBuilder =
    OrderStatusHistoryCompanion Function({
      Value<int> id,
      required int orderId,
      Value<OrderStatus?> statusLama,
      required OrderStatus statusBaru,
      required StatusChangeSource sumber,
      Value<DateTime> diubahPada,
    });
typedef $$OrderStatusHistoryTableUpdateCompanionBuilder =
    OrderStatusHistoryCompanion Function({
      Value<int> id,
      Value<int> orderId,
      Value<OrderStatus?> statusLama,
      Value<OrderStatus> statusBaru,
      Value<StatusChangeSource> sumber,
      Value<DateTime> diubahPada,
    });

final class $$OrderStatusHistoryTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $OrderStatusHistoryTable,
          StatusHistoryEntry
        > {
  $$OrderStatusHistoryTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OrdersTable _orderIdTable(_$AppDatabase db) =>
      db.orders.createAlias('order_status_history__order_id__orders__id');

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderStatusHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $OrderStatusHistoryTable> {
  $$OrderStatusHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OrderStatus?, OrderStatus, int>
  get statusLama => $composableBuilder(
    column: $table.statusLama,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<OrderStatus, OrderStatus, int>
  get statusBaru => $composableBuilder(
    column: $table.statusBaru,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<StatusChangeSource, StatusChangeSource, int>
  get sumber => $composableBuilder(
    column: $table.sumber,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get diubahPada => $composableBuilder(
    column: $table.diubahPada,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderStatusHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderStatusHistoryTable> {
  $$OrderStatusHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statusLama => $composableBuilder(
    column: $table.statusLama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statusBaru => $composableBuilder(
    column: $table.statusBaru,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sumber => $composableBuilder(
    column: $table.sumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get diubahPada => $composableBuilder(
    column: $table.diubahPada,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderStatusHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderStatusHistoryTable> {
  $$OrderStatusHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OrderStatus?, int> get statusLama =>
      $composableBuilder(
        column: $table.statusLama,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<OrderStatus, int> get statusBaru =>
      $composableBuilder(
        column: $table.statusBaru,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<StatusChangeSource, int> get sumber =>
      $composableBuilder(column: $table.sumber, builder: (column) => column);

  GeneratedColumn<DateTime> get diubahPada => $composableBuilder(
    column: $table.diubahPada,
    builder: (column) => column,
  );

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderStatusHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderStatusHistoryTable,
          StatusHistoryEntry,
          $$OrderStatusHistoryTableFilterComposer,
          $$OrderStatusHistoryTableOrderingComposer,
          $$OrderStatusHistoryTableAnnotationComposer,
          $$OrderStatusHistoryTableCreateCompanionBuilder,
          $$OrderStatusHistoryTableUpdateCompanionBuilder,
          (StatusHistoryEntry, $$OrderStatusHistoryTableReferences),
          StatusHistoryEntry,
          PrefetchHooks Function({bool orderId})
        > {
  $$OrderStatusHistoryTableTableManager(
    _$AppDatabase db,
    $OrderStatusHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderStatusHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderStatusHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderStatusHistoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> orderId = const Value.absent(),
                Value<OrderStatus?> statusLama = const Value.absent(),
                Value<OrderStatus> statusBaru = const Value.absent(),
                Value<StatusChangeSource> sumber = const Value.absent(),
                Value<DateTime> diubahPada = const Value.absent(),
              }) => OrderStatusHistoryCompanion(
                id: id,
                orderId: orderId,
                statusLama: statusLama,
                statusBaru: statusBaru,
                sumber: sumber,
                diubahPada: diubahPada,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int orderId,
                Value<OrderStatus?> statusLama = const Value.absent(),
                required OrderStatus statusBaru,
                required StatusChangeSource sumber,
                Value<DateTime> diubahPada = const Value.absent(),
              }) => OrderStatusHistoryCompanion.insert(
                id: id,
                orderId: orderId,
                statusLama: statusLama,
                statusBaru: statusBaru,
                sumber: sumber,
                diubahPada: diubahPada,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OrderStatusHistoryTable, StatusHistoryEntry>(
                    table,
                  ),
                  $$OrderStatusHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (orderId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.orderId,
                        referencedTable: $$OrderStatusHistoryTableReferences
                            ._orderIdTable(db),
                        referencedColumn: $$OrderStatusHistoryTableReferences
                            ._orderIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OrderStatusHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderStatusHistoryTable,
      StatusHistoryEntry,
      $$OrderStatusHistoryTableFilterComposer,
      $$OrderStatusHistoryTableOrderingComposer,
      $$OrderStatusHistoryTableAnnotationComposer,
      $$OrderStatusHistoryTableCreateCompanionBuilder,
      $$OrderStatusHistoryTableUpdateCompanionBuilder,
      (StatusHistoryEntry, $$OrderStatusHistoryTableReferences),
      StatusHistoryEntry,
      PrefetchHooks Function({bool orderId})
    >;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  required String kategori,
  required int jumlah,
  required DateTime tanggal,
  Value<String?> catatan,
  Value<DateTime> dibuatPada,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<String> kategori,
  Value<int> jumlah,
  Value<DateTime> tanggal,
  Value<String?> catatan,
  Value<DateTime> dibuatPada,
});

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kategori => $composableBuilder(
    column: $table.kategori,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kategori => $composableBuilder(
    column: $table.kategori,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kategori =>
      $composableBuilder(column: $table.kategori, builder: (column) => column);

  GeneratedColumn<int> get jumlah =>
      $composableBuilder(column: $table.jumlah, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggal =>
      $composableBuilder(column: $table.tanggal, builder: (column) => column);

  GeneratedColumn<String> get catatan =>
      $composableBuilder(column: $table.catatan, builder: (column) => column);

  GeneratedColumn<DateTime> get dibuatPada => $composableBuilder(
    column: $table.dibuatPada,
    builder: (column) => column,
  );
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
          Expense,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kategori = const Value.absent(),
                Value<int> jumlah = const Value.absent(),
                Value<DateTime> tanggal = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                kategori: kategori,
                jumlah: jumlah,
                tanggal: tanggal,
                catatan: catatan,
                dibuatPada: dibuatPada,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kategori,
                required int jumlah,
                required DateTime tanggal,
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> dibuatPada = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                kategori: kategori,
                jumlah: jumlah,
                tanggal: tanggal,
                catatan: catatan,
                dibuatPada: dibuatPada,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExpensesTable, Expense>(table),
                  BaseReferences<_$AppDatabase, $ExpensesTable, Expense>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
      Expense,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String kunci,
  required String nilai,
  Value<DateTime> diubahPada,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> kunci,
  Value<String> nilai,
  Value<DateTime> diubahPada,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get kunci => $composableBuilder(
    column: $table.kunci,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nilai => $composableBuilder(
    column: $table.nilai,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get diubahPada => $composableBuilder(
    column: $table.diubahPada,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get kunci => $composableBuilder(
    column: $table.kunci,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nilai => $composableBuilder(
    column: $table.nilai,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get diubahPada => $composableBuilder(
    column: $table.diubahPada,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get kunci =>
      $composableBuilder(column: $table.kunci, builder: (column) => column);

  GeneratedColumn<String> get nilai =>
      $composableBuilder(column: $table.nilai, builder: (column) => column);

  GeneratedColumn<DateTime> get diubahPada => $composableBuilder(
    column: $table.diubahPada,
    builder: (column) => column,
  );
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> kunci = const Value.absent(),
                Value<String> nilai = const Value.absent(),
                Value<DateTime> diubahPada = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(
                kunci: kunci,
                nilai: nilai,
                diubahPada: diubahPada,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String kunci,
                required String nilai,
                Value<DateTime> diubahPada = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                kunci: kunci,
                nilai: nilai,
                diubahPada: diubahPada,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$LicensesTableCreateCompanionBuilder = LicensesCompanion Function({
  Value<int> id,
  required String kode,
  required String idPerangkat,
  Value<DateTime> diaktifkanPada,
});
typedef $$LicensesTableUpdateCompanionBuilder = LicensesCompanion Function({
  Value<int> id,
  Value<String> kode,
  Value<String> idPerangkat,
  Value<DateTime> diaktifkanPada,
});

class $$LicensesTableFilterComposer
    extends Composer<_$AppDatabase, $LicensesTable> {
  $$LicensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kode => $composableBuilder(
    column: $table.kode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idPerangkat => $composableBuilder(
    column: $table.idPerangkat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get diaktifkanPada => $composableBuilder(
    column: $table.diaktifkanPada,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LicensesTableOrderingComposer
    extends Composer<_$AppDatabase, $LicensesTable> {
  $$LicensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kode => $composableBuilder(
    column: $table.kode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idPerangkat => $composableBuilder(
    column: $table.idPerangkat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get diaktifkanPada => $composableBuilder(
    column: $table.diaktifkanPada,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LicensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LicensesTable> {
  $$LicensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kode =>
      $composableBuilder(column: $table.kode, builder: (column) => column);

  GeneratedColumn<String> get idPerangkat => $composableBuilder(
    column: $table.idPerangkat,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get diaktifkanPada => $composableBuilder(
    column: $table.diaktifkanPada,
    builder: (column) => column,
  );
}

class $$LicensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LicensesTable,
          License,
          $$LicensesTableFilterComposer,
          $$LicensesTableOrderingComposer,
          $$LicensesTableAnnotationComposer,
          $$LicensesTableCreateCompanionBuilder,
          $$LicensesTableUpdateCompanionBuilder,
          (License, BaseReferences<_$AppDatabase, $LicensesTable, License>),
          License,
          PrefetchHooks Function()
        > {
  $$LicensesTableTableManager(_$AppDatabase db, $LicensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LicensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LicensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LicensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kode = const Value.absent(),
                Value<String> idPerangkat = const Value.absent(),
                Value<DateTime> diaktifkanPada = const Value.absent(),
              }) => LicensesCompanion(
                id: id,
                kode: kode,
                idPerangkat: idPerangkat,
                diaktifkanPada: diaktifkanPada,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kode,
                required String idPerangkat,
                Value<DateTime> diaktifkanPada = const Value.absent(),
              }) => LicensesCompanion.insert(
                id: id,
                kode: kode,
                idPerangkat: idPerangkat,
                diaktifkanPada: diaktifkanPada,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LicensesTable, License>(table),
                  BaseReferences<_$AppDatabase, $LicensesTable, License>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LicensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LicensesTable,
      License,
      $$LicensesTableFilterComposer,
      $$LicensesTableOrderingComposer,
      $$LicensesTableAnnotationComposer,
      $$LicensesTableCreateCompanionBuilder,
      $$LicensesTableUpdateCompanionBuilder,
      (License, BaseReferences<_$AppDatabase, $LicensesTable, License>),
      License,
      PrefetchHooks Function()
    >;
typedef $$NotaCountersTableCreateCompanionBuilder =
    NotaCountersCompanion Function({
      required String tanggal,
      required int urutan,
      Value<int> rowid,
    });
typedef $$NotaCountersTableUpdateCompanionBuilder =
    NotaCountersCompanion Function({
      Value<String> tanggal,
      Value<int> urutan,
      Value<int> rowid,
    });

class $$NotaCountersTableFilterComposer
    extends Composer<_$AppDatabase, $NotaCountersTable> {
  $$NotaCountersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get urutan => $composableBuilder(
    column: $table.urutan,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotaCountersTableOrderingComposer
    extends Composer<_$AppDatabase, $NotaCountersTable> {
  $$NotaCountersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get urutan => $composableBuilder(
    column: $table.urutan,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotaCountersTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotaCountersTable> {
  $$NotaCountersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tanggal =>
      $composableBuilder(column: $table.tanggal, builder: (column) => column);

  GeneratedColumn<int> get urutan =>
      $composableBuilder(column: $table.urutan, builder: (column) => column);
}

class $$NotaCountersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotaCountersTable,
          NotaCounter,
          $$NotaCountersTableFilterComposer,
          $$NotaCountersTableOrderingComposer,
          $$NotaCountersTableAnnotationComposer,
          $$NotaCountersTableCreateCompanionBuilder,
          $$NotaCountersTableUpdateCompanionBuilder,
          (
            NotaCounter,
            BaseReferences<_$AppDatabase, $NotaCountersTable, NotaCounter>,
          ),
          NotaCounter,
          PrefetchHooks Function()
        > {
  $$NotaCountersTableTableManager(_$AppDatabase db, $NotaCountersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotaCountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotaCountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotaCountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> tanggal = const Value.absent(),
                Value<int> urutan = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotaCountersCompanion(
                tanggal: tanggal,
                urutan: urutan,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String tanggal,
                required int urutan,
                Value<int> rowid = const Value.absent(),
              }) => NotaCountersCompanion.insert(
                tanggal: tanggal,
                urutan: urutan,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NotaCountersTable, NotaCounter>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $NotaCountersTable,
                    NotaCounter
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotaCountersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotaCountersTable,
      NotaCounter,
      $$NotaCountersTableFilterComposer,
      $$NotaCountersTableOrderingComposer,
      $$NotaCountersTableAnnotationComposer,
      $$NotaCountersTableCreateCompanionBuilder,
      $$NotaCountersTableUpdateCompanionBuilder,
      (
        NotaCounter,
        BaseReferences<_$AppDatabase, $NotaCountersTable, NotaCounter>,
      ),
      NotaCounter,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$ServicesTableTableManager get services =>
      $$ServicesTableTableManager(_db, _db.services);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$OrderStatusHistoryTableTableManager get orderStatusHistory =>
      $$OrderStatusHistoryTableTableManager(_db, _db.orderStatusHistory);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$LicensesTableTableManager get licenses =>
      $$LicensesTableTableManager(_db, _db.licenses);
  $$NotaCountersTableTableManager get notaCounters =>
      $$NotaCountersTableTableManager(_db, _db.notaCounters);
}
