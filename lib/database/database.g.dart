// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Vehicule extends DataClass implements Insertable<Vehicule> {
  final int id;
  final String marque;
  final String modele;
  final int annee;
  final int consommation;
  final int distance;
  final List<Carburants> carburantsCompatibles;
  final Carburants carburantFavoris;
  final bool consoAffichee;
  Vehicule(
      {@required this.id,
      @required this.marque,
      @required this.modele,
      this.annee,
      @required this.consommation,
      @required this.distance,
      this.carburantsCompatibles,
      this.carburantFavoris,
      @required this.consoAffichee});
  factory Vehicule.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Vehicule(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      marque:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}marque']),
      modele:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}modele']),
      annee: intType.mapFromDatabaseResponse(data['${effectivePrefix}annee']),
      consommation: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}consommation']),
      distance:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}distance']),
      carburantsCompatibles: $VehiculesTable.$converter0.mapToDart(
          stringType.mapFromDatabaseResponse(
              data['${effectivePrefix}carburants_compatibles'])),
      carburantFavoris: $VehiculesTable.$converter1.mapToDart(
          stringType.mapFromDatabaseResponse(
              data['${effectivePrefix}carburant_favoris'])),
      consoAffichee: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}conso_affichee']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || marque != null) {
      map['marque'] = Variable<String>(marque);
    }
    if (!nullToAbsent || modele != null) {
      map['modele'] = Variable<String>(modele);
    }
    if (!nullToAbsent || annee != null) {
      map['annee'] = Variable<int>(annee);
    }
    if (!nullToAbsent || consommation != null) {
      map['consommation'] = Variable<int>(consommation);
    }
    if (!nullToAbsent || distance != null) {
      map['distance'] = Variable<int>(distance);
    }
    if (!nullToAbsent || carburantsCompatibles != null) {
      final converter = $VehiculesTable.$converter0;
      map['carburants_compatibles'] =
          Variable<String>(converter.mapToSql(carburantsCompatibles));
    }
    if (!nullToAbsent || carburantFavoris != null) {
      final converter = $VehiculesTable.$converter1;
      map['carburant_favoris'] =
          Variable<String>(converter.mapToSql(carburantFavoris));
    }
    if (!nullToAbsent || consoAffichee != null) {
      map['conso_affichee'] = Variable<bool>(consoAffichee);
    }
    return map;
  }

  VehiculesCompanion toCompanion(bool nullToAbsent) {
    return VehiculesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      marque:
          marque == null && nullToAbsent ? const Value.absent() : Value(marque),
      modele:
          modele == null && nullToAbsent ? const Value.absent() : Value(modele),
      annee:
          annee == null && nullToAbsent ? const Value.absent() : Value(annee),
      consommation: consommation == null && nullToAbsent
          ? const Value.absent()
          : Value(consommation),
      distance: distance == null && nullToAbsent
          ? const Value.absent()
          : Value(distance),
      carburantsCompatibles: carburantsCompatibles == null && nullToAbsent
          ? const Value.absent()
          : Value(carburantsCompatibles),
      carburantFavoris: carburantFavoris == null && nullToAbsent
          ? const Value.absent()
          : Value(carburantFavoris),
      consoAffichee: consoAffichee == null && nullToAbsent
          ? const Value.absent()
          : Value(consoAffichee),
    );
  }

  factory Vehicule.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Vehicule(
      id: serializer.fromJson<int>(json['id']),
      marque: serializer.fromJson<String>(json['marque']),
      modele: serializer.fromJson<String>(json['modele']),
      annee: serializer.fromJson<int>(json['annee']),
      consommation: serializer.fromJson<int>(json['consommation']),
      distance: serializer.fromJson<int>(json['distance']),
      carburantsCompatibles:
          serializer.fromJson<List<Carburants>>(json['carburantsCompatibles']),
      carburantFavoris:
          serializer.fromJson<Carburants>(json['carburantFavoris']),
      consoAffichee: serializer.fromJson<bool>(json['consoAffichee']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'marque': serializer.toJson<String>(marque),
      'modele': serializer.toJson<String>(modele),
      'annee': serializer.toJson<int>(annee),
      'consommation': serializer.toJson<int>(consommation),
      'distance': serializer.toJson<int>(distance),
      'carburantsCompatibles':
          serializer.toJson<List<Carburants>>(carburantsCompatibles),
      'carburantFavoris': serializer.toJson<Carburants>(carburantFavoris),
      'consoAffichee': serializer.toJson<bool>(consoAffichee),
    };
  }

  Vehicule copyWith(
          {int id,
          String marque,
          String modele,
          int annee,
          int consommation,
          int distance,
          List<Carburants> carburantsCompatibles,
          Carburants carburantFavoris,
          bool consoAffichee}) =>
      Vehicule(
        id: id ?? this.id,
        marque: marque ?? this.marque,
        modele: modele ?? this.modele,
        annee: annee ?? this.annee,
        consommation: consommation ?? this.consommation,
        distance: distance ?? this.distance,
        carburantsCompatibles:
            carburantsCompatibles ?? this.carburantsCompatibles,
        carburantFavoris: carburantFavoris ?? this.carburantFavoris,
        consoAffichee: consoAffichee ?? this.consoAffichee,
      );
  @override
  String toString() {
    return (StringBuffer('Vehicule(')
          ..write('id: $id, ')
          ..write('marque: $marque, ')
          ..write('modele: $modele, ')
          ..write('annee: $annee, ')
          ..write('consommation: $consommation, ')
          ..write('distance: $distance, ')
          ..write('carburantsCompatibles: $carburantsCompatibles, ')
          ..write('carburantFavoris: $carburantFavoris, ')
          ..write('consoAffichee: $consoAffichee')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          marque.hashCode,
          $mrjc(
              modele.hashCode,
              $mrjc(
                  annee.hashCode,
                  $mrjc(
                      consommation.hashCode,
                      $mrjc(
                          distance.hashCode,
                          $mrjc(
                              carburantsCompatibles.hashCode,
                              $mrjc(carburantFavoris.hashCode,
                                  consoAffichee.hashCode)))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Vehicule &&
          other.id == this.id &&
          other.marque == this.marque &&
          other.modele == this.modele &&
          other.annee == this.annee &&
          other.consommation == this.consommation &&
          other.distance == this.distance &&
          other.carburantsCompatibles == this.carburantsCompatibles &&
          other.carburantFavoris == this.carburantFavoris &&
          other.consoAffichee == this.consoAffichee);
}

class VehiculesCompanion extends UpdateCompanion<Vehicule> {
  final Value<int> id;
  final Value<String> marque;
  final Value<String> modele;
  final Value<int> annee;
  final Value<int> consommation;
  final Value<int> distance;
  final Value<List<Carburants>> carburantsCompatibles;
  final Value<Carburants> carburantFavoris;
  final Value<bool> consoAffichee;
  const VehiculesCompanion({
    this.id = const Value.absent(),
    this.marque = const Value.absent(),
    this.modele = const Value.absent(),
    this.annee = const Value.absent(),
    this.consommation = const Value.absent(),
    this.distance = const Value.absent(),
    this.carburantsCompatibles = const Value.absent(),
    this.carburantFavoris = const Value.absent(),
    this.consoAffichee = const Value.absent(),
  });
  VehiculesCompanion.insert({
    this.id = const Value.absent(),
    @required String marque,
    @required String modele,
    this.annee = const Value.absent(),
    this.consommation = const Value.absent(),
    this.distance = const Value.absent(),
    this.carburantsCompatibles = const Value.absent(),
    this.carburantFavoris = const Value.absent(),
    this.consoAffichee = const Value.absent(),
  })  : marque = Value(marque),
        modele = Value(modele);
  static Insertable<Vehicule> custom({
    Expression<int> id,
    Expression<String> marque,
    Expression<String> modele,
    Expression<int> annee,
    Expression<int> consommation,
    Expression<int> distance,
    Expression<String> carburantsCompatibles,
    Expression<String> carburantFavoris,
    Expression<bool> consoAffichee,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (marque != null) 'marque': marque,
      if (modele != null) 'modele': modele,
      if (annee != null) 'annee': annee,
      if (consommation != null) 'consommation': consommation,
      if (distance != null) 'distance': distance,
      if (carburantsCompatibles != null)
        'carburants_compatibles': carburantsCompatibles,
      if (carburantFavoris != null) 'carburant_favoris': carburantFavoris,
      if (consoAffichee != null) 'conso_affichee': consoAffichee,
    });
  }

  VehiculesCompanion copyWith(
      {Value<int> id,
      Value<String> marque,
      Value<String> modele,
      Value<int> annee,
      Value<int> consommation,
      Value<int> distance,
      Value<List<Carburants>> carburantsCompatibles,
      Value<Carburants> carburantFavoris,
      Value<bool> consoAffichee}) {
    return VehiculesCompanion(
      id: id ?? this.id,
      marque: marque ?? this.marque,
      modele: modele ?? this.modele,
      annee: annee ?? this.annee,
      consommation: consommation ?? this.consommation,
      distance: distance ?? this.distance,
      carburantsCompatibles:
          carburantsCompatibles ?? this.carburantsCompatibles,
      carburantFavoris: carburantFavoris ?? this.carburantFavoris,
      consoAffichee: consoAffichee ?? this.consoAffichee,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (marque.present) {
      map['marque'] = Variable<String>(marque.value);
    }
    if (modele.present) {
      map['modele'] = Variable<String>(modele.value);
    }
    if (annee.present) {
      map['annee'] = Variable<int>(annee.value);
    }
    if (consommation.present) {
      map['consommation'] = Variable<int>(consommation.value);
    }
    if (distance.present) {
      map['distance'] = Variable<int>(distance.value);
    }
    if (carburantsCompatibles.present) {
      final converter = $VehiculesTable.$converter0;
      map['carburants_compatibles'] =
          Variable<String>(converter.mapToSql(carburantsCompatibles.value));
    }
    if (carburantFavoris.present) {
      final converter = $VehiculesTable.$converter1;
      map['carburant_favoris'] =
          Variable<String>(converter.mapToSql(carburantFavoris.value));
    }
    if (consoAffichee.present) {
      map['conso_affichee'] = Variable<bool>(consoAffichee.value);
    }
    return map;
  }
}

class $VehiculesTable extends Vehicules
    with TableInfo<$VehiculesTable, Vehicule> {
  final GeneratedDatabase _db;
  final String _alias;
  $VehiculesTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _marqueMeta = const VerificationMeta('marque');
  GeneratedTextColumn _marque;
  @override
  GeneratedTextColumn get marque => _marque ??= _constructMarque();
  GeneratedTextColumn _constructMarque() {
    return GeneratedTextColumn(
      'marque',
      $tableName,
      false,
    );
  }

  final VerificationMeta _modeleMeta = const VerificationMeta('modele');
  GeneratedTextColumn _modele;
  @override
  GeneratedTextColumn get modele => _modele ??= _constructModele();
  GeneratedTextColumn _constructModele() {
    return GeneratedTextColumn(
      'modele',
      $tableName,
      false,
    );
  }

  final VerificationMeta _anneeMeta = const VerificationMeta('annee');
  GeneratedIntColumn _annee;
  @override
  GeneratedIntColumn get annee => _annee ??= _constructAnnee();
  GeneratedIntColumn _constructAnnee() {
    return GeneratedIntColumn(
      'annee',
      $tableName,
      true,
    );
  }

  final VerificationMeta _consommationMeta =
      const VerificationMeta('consommation');
  GeneratedIntColumn _consommation;
  @override
  GeneratedIntColumn get consommation =>
      _consommation ??= _constructConsommation();
  GeneratedIntColumn _constructConsommation() {
    return GeneratedIntColumn('consommation', $tableName, false,
        defaultValue: const Constant(0));
  }

  final VerificationMeta _distanceMeta = const VerificationMeta('distance');
  GeneratedIntColumn _distance;
  @override
  GeneratedIntColumn get distance => _distance ??= _constructDistance();
  GeneratedIntColumn _constructDistance() {
    return GeneratedIntColumn('distance', $tableName, false,
        defaultValue: const Constant(0));
  }

  final VerificationMeta _carburantsCompatiblesMeta =
      const VerificationMeta('carburantsCompatibles');
  GeneratedTextColumn _carburantsCompatibles;
  @override
  GeneratedTextColumn get carburantsCompatibles =>
      _carburantsCompatibles ??= _constructCarburantsCompatibles();
  GeneratedTextColumn _constructCarburantsCompatibles() {
    return GeneratedTextColumn(
      'carburants_compatibles',
      $tableName,
      true,
    );
  }

  final VerificationMeta _carburantFavorisMeta =
      const VerificationMeta('carburantFavoris');
  GeneratedTextColumn _carburantFavoris;
  @override
  GeneratedTextColumn get carburantFavoris =>
      _carburantFavoris ??= _constructCarburantFavoris();
  GeneratedTextColumn _constructCarburantFavoris() {
    return GeneratedTextColumn(
      'carburant_favoris',
      $tableName,
      true,
    );
  }

  final VerificationMeta _consoAfficheeMeta =
      const VerificationMeta('consoAffichee');
  GeneratedBoolColumn _consoAffichee;
  @override
  GeneratedBoolColumn get consoAffichee =>
      _consoAffichee ??= _constructConsoAffichee();
  GeneratedBoolColumn _constructConsoAffichee() {
    return GeneratedBoolColumn('conso_affichee', $tableName, false,
        defaultValue: const Constant(true));
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        marque,
        modele,
        annee,
        consommation,
        distance,
        carburantsCompatibles,
        carburantFavoris,
        consoAffichee
      ];
  @override
  $VehiculesTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'vehicules';
  @override
  final String actualTableName = 'vehicules';
  @override
  VerificationContext validateIntegrity(Insertable<Vehicule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('marque')) {
      context.handle(_marqueMeta,
          marque.isAcceptableOrUnknown(data['marque'], _marqueMeta));
    } else if (isInserting) {
      context.missing(_marqueMeta);
    }
    if (data.containsKey('modele')) {
      context.handle(_modeleMeta,
          modele.isAcceptableOrUnknown(data['modele'], _modeleMeta));
    } else if (isInserting) {
      context.missing(_modeleMeta);
    }
    if (data.containsKey('annee')) {
      context.handle(
          _anneeMeta, annee.isAcceptableOrUnknown(data['annee'], _anneeMeta));
    }
    if (data.containsKey('consommation')) {
      context.handle(
          _consommationMeta,
          consommation.isAcceptableOrUnknown(
              data['consommation'], _consommationMeta));
    }
    if (data.containsKey('distance')) {
      context.handle(_distanceMeta,
          distance.isAcceptableOrUnknown(data['distance'], _distanceMeta));
    }
    context.handle(
        _carburantsCompatiblesMeta, const VerificationResult.success());
    context.handle(_carburantFavorisMeta, const VerificationResult.success());
    if (data.containsKey('conso_affichee')) {
      context.handle(
          _consoAfficheeMeta,
          consoAffichee.isAcceptableOrUnknown(
              data['conso_affichee'], _consoAfficheeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehicule map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Vehicule.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $VehiculesTable createAlias(String alias) {
    return $VehiculesTable(_db, alias);
  }

  static TypeConverter<List<Carburants>, String> $converter0 =
      const CarburantsListConverter();
  static TypeConverter<Carburants, String> $converter1 =
      const CarburantsConverter();
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $VehiculesTable _vehicules;
  $VehiculesTable get vehicules => _vehicules ??= $VehiculesTable(this);
  VehiculesDao _vehiculesDao;
  VehiculesDao get vehiculesDao =>
      _vehiculesDao ??= VehiculesDao(this as MyDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [vehicules];
}
