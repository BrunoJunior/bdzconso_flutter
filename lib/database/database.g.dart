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
  final List<Carburants> carburantsCompatibles;
  final Carburants carburantFavoris;
  final bool consoAffichee;
  final String photo;
  Vehicule(
      {@required this.id,
      @required this.marque,
      @required this.modele,
      this.annee,
      this.carburantsCompatibles,
      this.carburantFavoris,
      @required this.consoAffichee,
      this.photo});
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
      carburantsCompatibles: $VehiculesTable.$converter0.mapToDart(
          stringType.mapFromDatabaseResponse(
              data['${effectivePrefix}carburants_compatibles'])),
      carburantFavoris: $VehiculesTable.$converter1.mapToDart(
          stringType.mapFromDatabaseResponse(
              data['${effectivePrefix}carburant_favoris'])),
      consoAffichee: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}conso_affichee']),
      photo:
          stringType.mapFromDatabaseResponse(data['${effectivePrefix}photo']),
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
    if (!nullToAbsent || photo != null) {
      map['photo'] = Variable<String>(photo);
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
      carburantsCompatibles: carburantsCompatibles == null && nullToAbsent
          ? const Value.absent()
          : Value(carburantsCompatibles),
      carburantFavoris: carburantFavoris == null && nullToAbsent
          ? const Value.absent()
          : Value(carburantFavoris),
      consoAffichee: consoAffichee == null && nullToAbsent
          ? const Value.absent()
          : Value(consoAffichee),
      photo:
          photo == null && nullToAbsent ? const Value.absent() : Value(photo),
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
      carburantsCompatibles:
          serializer.fromJson<List<Carburants>>(json['carburantsCompatibles']),
      carburantFavoris:
          serializer.fromJson<Carburants>(json['carburantFavoris']),
      consoAffichee: serializer.fromJson<bool>(json['consoAffichee']),
      photo: serializer.fromJson<String>(json['photo']),
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
      'carburantsCompatibles':
          serializer.toJson<List<Carburants>>(carburantsCompatibles),
      'carburantFavoris': serializer.toJson<Carburants>(carburantFavoris),
      'consoAffichee': serializer.toJson<bool>(consoAffichee),
      'photo': serializer.toJson<String>(photo),
    };
  }

  Vehicule copyWith(
          {int id,
          String marque,
          String modele,
          int annee,
          List<Carburants> carburantsCompatibles,
          Carburants carburantFavoris,
          bool consoAffichee,
          String photo}) =>
      Vehicule(
        id: id ?? this.id,
        marque: marque ?? this.marque,
        modele: modele ?? this.modele,
        annee: annee ?? this.annee,
        carburantsCompatibles:
            carburantsCompatibles ?? this.carburantsCompatibles,
        carburantFavoris: carburantFavoris ?? this.carburantFavoris,
        consoAffichee: consoAffichee ?? this.consoAffichee,
        photo: photo ?? this.photo,
      );
  @override
  String toString() {
    return (StringBuffer('Vehicule(')
          ..write('id: $id, ')
          ..write('marque: $marque, ')
          ..write('modele: $modele, ')
          ..write('annee: $annee, ')
          ..write('carburantsCompatibles: $carburantsCompatibles, ')
          ..write('carburantFavoris: $carburantFavoris, ')
          ..write('consoAffichee: $consoAffichee, ')
          ..write('photo: $photo')
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
                      carburantsCompatibles.hashCode,
                      $mrjc(carburantFavoris.hashCode,
                          $mrjc(consoAffichee.hashCode, photo.hashCode))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Vehicule &&
          other.id == this.id &&
          other.marque == this.marque &&
          other.modele == this.modele &&
          other.annee == this.annee &&
          other.carburantsCompatibles == this.carburantsCompatibles &&
          other.carburantFavoris == this.carburantFavoris &&
          other.consoAffichee == this.consoAffichee &&
          other.photo == this.photo);
}

class VehiculesCompanion extends UpdateCompanion<Vehicule> {
  final Value<int> id;
  final Value<String> marque;
  final Value<String> modele;
  final Value<int> annee;
  final Value<List<Carburants>> carburantsCompatibles;
  final Value<Carburants> carburantFavoris;
  final Value<bool> consoAffichee;
  final Value<String> photo;
  const VehiculesCompanion({
    this.id = const Value.absent(),
    this.marque = const Value.absent(),
    this.modele = const Value.absent(),
    this.annee = const Value.absent(),
    this.carburantsCompatibles = const Value.absent(),
    this.carburantFavoris = const Value.absent(),
    this.consoAffichee = const Value.absent(),
    this.photo = const Value.absent(),
  });
  VehiculesCompanion.insert({
    this.id = const Value.absent(),
    @required String marque,
    @required String modele,
    this.annee = const Value.absent(),
    this.carburantsCompatibles = const Value.absent(),
    this.carburantFavoris = const Value.absent(),
    this.consoAffichee = const Value.absent(),
    this.photo = const Value.absent(),
  })  : marque = Value(marque),
        modele = Value(modele);
  static Insertable<Vehicule> custom({
    Expression<int> id,
    Expression<String> marque,
    Expression<String> modele,
    Expression<int> annee,
    Expression<String> carburantsCompatibles,
    Expression<String> carburantFavoris,
    Expression<bool> consoAffichee,
    Expression<String> photo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (marque != null) 'marque': marque,
      if (modele != null) 'modele': modele,
      if (annee != null) 'annee': annee,
      if (carburantsCompatibles != null)
        'carburants_compatibles': carburantsCompatibles,
      if (carburantFavoris != null) 'carburant_favoris': carburantFavoris,
      if (consoAffichee != null) 'conso_affichee': consoAffichee,
      if (photo != null) 'photo': photo,
    });
  }

  VehiculesCompanion copyWith(
      {Value<int> id,
      Value<String> marque,
      Value<String> modele,
      Value<int> annee,
      Value<List<Carburants>> carburantsCompatibles,
      Value<Carburants> carburantFavoris,
      Value<bool> consoAffichee,
      Value<String> photo}) {
    return VehiculesCompanion(
      id: id ?? this.id,
      marque: marque ?? this.marque,
      modele: modele ?? this.modele,
      annee: annee ?? this.annee,
      carburantsCompatibles:
          carburantsCompatibles ?? this.carburantsCompatibles,
      carburantFavoris: carburantFavoris ?? this.carburantFavoris,
      consoAffichee: consoAffichee ?? this.consoAffichee,
      photo: photo ?? this.photo,
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
    if (photo.present) {
      map['photo'] = Variable<String>(photo.value);
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

  final VerificationMeta _photoMeta = const VerificationMeta('photo');
  GeneratedTextColumn _photo;
  @override
  GeneratedTextColumn get photo => _photo ??= _constructPhoto();
  GeneratedTextColumn _constructPhoto() {
    return GeneratedTextColumn(
      'photo',
      $tableName,
      true,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        marque,
        modele,
        annee,
        carburantsCompatibles,
        carburantFavoris,
        consoAffichee,
        photo
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
    context.handle(
        _carburantsCompatiblesMeta, const VerificationResult.success());
    context.handle(_carburantFavorisMeta, const VerificationResult.success());
    if (data.containsKey('conso_affichee')) {
      context.handle(
          _consoAfficheeMeta,
          consoAffichee.isAcceptableOrUnknown(
              data['conso_affichee'], _consoAfficheeMeta));
    }
    if (data.containsKey('photo')) {
      context.handle(
          _photoMeta, photo.isAcceptableOrUnknown(data['photo'], _photoMeta));
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

class Plein extends DataClass implements Insertable<Plein> {
  final int id;
  final int idVehicule;
  final DateTime date;
  final Carburants carburant;
  final double volume;
  final double montant;
  final double distance;
  final double prixLitre;
  final bool additif;
  final double consoAffichee;
  final double consoCalculee;
  final bool partiel;
  final bool traite;
  Plein(
      {@required this.id,
      @required this.idVehicule,
      @required this.date,
      @required this.carburant,
      @required this.volume,
      @required this.montant,
      @required this.distance,
      @required this.prixLitre,
      @required this.additif,
      @required this.consoAffichee,
      @required this.consoCalculee,
      @required this.partiel,
      @required this.traite});
  factory Plein.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final stringType = db.typeSystem.forDartType<String>();
    final boolType = db.typeSystem.forDartType<bool>();
    return Plein(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      idVehicule: intType
          .mapFromDatabaseResponse(data['${effectivePrefix}id_vehicule']),
      date:
          dateTimeType.mapFromDatabaseResponse(data['${effectivePrefix}date']),
      carburant: $PleinsTable.$converter0.mapToDart(stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}carburant'])),
      volume: $PleinsTable.$converter1.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}volume'])),
      montant: $PleinsTable.$converter2.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}montant'])),
      distance: $PleinsTable.$converter3.mapToDart(
          intType.mapFromDatabaseResponse(data['${effectivePrefix}distance'])),
      prixLitre: $PleinsTable.$converter4.mapToDart(intType
          .mapFromDatabaseResponse(data['${effectivePrefix}prix_litre'])),
      additif:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}additif']),
      consoAffichee: $PleinsTable.$converter5.mapToDart(intType
          .mapFromDatabaseResponse(data['${effectivePrefix}conso_affichee'])),
      consoCalculee: $PleinsTable.$converter6.mapToDart(intType
          .mapFromDatabaseResponse(data['${effectivePrefix}conso_calculee'])),
      partiel:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}partiel']),
      traite:
          boolType.mapFromDatabaseResponse(data['${effectivePrefix}traite']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || idVehicule != null) {
      map['id_vehicule'] = Variable<int>(idVehicule);
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    if (!nullToAbsent || carburant != null) {
      final converter = $PleinsTable.$converter0;
      map['carburant'] = Variable<String>(converter.mapToSql(carburant));
    }
    if (!nullToAbsent || volume != null) {
      final converter = $PleinsTable.$converter1;
      map['volume'] = Variable<int>(converter.mapToSql(volume));
    }
    if (!nullToAbsent || montant != null) {
      final converter = $PleinsTable.$converter2;
      map['montant'] = Variable<int>(converter.mapToSql(montant));
    }
    if (!nullToAbsent || distance != null) {
      final converter = $PleinsTable.$converter3;
      map['distance'] = Variable<int>(converter.mapToSql(distance));
    }
    if (!nullToAbsent || prixLitre != null) {
      final converter = $PleinsTable.$converter4;
      map['prix_litre'] = Variable<int>(converter.mapToSql(prixLitre));
    }
    if (!nullToAbsent || additif != null) {
      map['additif'] = Variable<bool>(additif);
    }
    if (!nullToAbsent || consoAffichee != null) {
      final converter = $PleinsTable.$converter5;
      map['conso_affichee'] = Variable<int>(converter.mapToSql(consoAffichee));
    }
    if (!nullToAbsent || consoCalculee != null) {
      final converter = $PleinsTable.$converter6;
      map['conso_calculee'] = Variable<int>(converter.mapToSql(consoCalculee));
    }
    if (!nullToAbsent || partiel != null) {
      map['partiel'] = Variable<bool>(partiel);
    }
    if (!nullToAbsent || traite != null) {
      map['traite'] = Variable<bool>(traite);
    }
    return map;
  }

  PleinsCompanion toCompanion(bool nullToAbsent) {
    return PleinsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      idVehicule: idVehicule == null && nullToAbsent
          ? const Value.absent()
          : Value(idVehicule),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      carburant: carburant == null && nullToAbsent
          ? const Value.absent()
          : Value(carburant),
      volume:
          volume == null && nullToAbsent ? const Value.absent() : Value(volume),
      montant: montant == null && nullToAbsent
          ? const Value.absent()
          : Value(montant),
      distance: distance == null && nullToAbsent
          ? const Value.absent()
          : Value(distance),
      prixLitre: prixLitre == null && nullToAbsent
          ? const Value.absent()
          : Value(prixLitre),
      additif: additif == null && nullToAbsent
          ? const Value.absent()
          : Value(additif),
      consoAffichee: consoAffichee == null && nullToAbsent
          ? const Value.absent()
          : Value(consoAffichee),
      consoCalculee: consoCalculee == null && nullToAbsent
          ? const Value.absent()
          : Value(consoCalculee),
      partiel: partiel == null && nullToAbsent
          ? const Value.absent()
          : Value(partiel),
      traite:
          traite == null && nullToAbsent ? const Value.absent() : Value(traite),
    );
  }

  factory Plein.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Plein(
      id: serializer.fromJson<int>(json['id']),
      idVehicule: serializer.fromJson<int>(json['idVehicule']),
      date: serializer.fromJson<DateTime>(json['date']),
      carburant: serializer.fromJson<Carburants>(json['carburant']),
      volume: serializer.fromJson<double>(json['volume']),
      montant: serializer.fromJson<double>(json['montant']),
      distance: serializer.fromJson<double>(json['distance']),
      prixLitre: serializer.fromJson<double>(json['prixLitre']),
      additif: serializer.fromJson<bool>(json['additif']),
      consoAffichee: serializer.fromJson<double>(json['consoAffichee']),
      consoCalculee: serializer.fromJson<double>(json['consoCalculee']),
      partiel: serializer.fromJson<bool>(json['partiel']),
      traite: serializer.fromJson<bool>(json['traite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idVehicule': serializer.toJson<int>(idVehicule),
      'date': serializer.toJson<DateTime>(date),
      'carburant': serializer.toJson<Carburants>(carburant),
      'volume': serializer.toJson<double>(volume),
      'montant': serializer.toJson<double>(montant),
      'distance': serializer.toJson<double>(distance),
      'prixLitre': serializer.toJson<double>(prixLitre),
      'additif': serializer.toJson<bool>(additif),
      'consoAffichee': serializer.toJson<double>(consoAffichee),
      'consoCalculee': serializer.toJson<double>(consoCalculee),
      'partiel': serializer.toJson<bool>(partiel),
      'traite': serializer.toJson<bool>(traite),
    };
  }

  Plein copyWith(
          {int id,
          int idVehicule,
          DateTime date,
          Carburants carburant,
          double volume,
          double montant,
          double distance,
          double prixLitre,
          bool additif,
          double consoAffichee,
          double consoCalculee,
          bool partiel,
          bool traite}) =>
      Plein(
        id: id ?? this.id,
        idVehicule: idVehicule ?? this.idVehicule,
        date: date ?? this.date,
        carburant: carburant ?? this.carburant,
        volume: volume ?? this.volume,
        montant: montant ?? this.montant,
        distance: distance ?? this.distance,
        prixLitre: prixLitre ?? this.prixLitre,
        additif: additif ?? this.additif,
        consoAffichee: consoAffichee ?? this.consoAffichee,
        consoCalculee: consoCalculee ?? this.consoCalculee,
        partiel: partiel ?? this.partiel,
        traite: traite ?? this.traite,
      );
  @override
  String toString() {
    return (StringBuffer('Plein(')
          ..write('id: $id, ')
          ..write('idVehicule: $idVehicule, ')
          ..write('date: $date, ')
          ..write('carburant: $carburant, ')
          ..write('volume: $volume, ')
          ..write('montant: $montant, ')
          ..write('distance: $distance, ')
          ..write('prixLitre: $prixLitre, ')
          ..write('additif: $additif, ')
          ..write('consoAffichee: $consoAffichee, ')
          ..write('consoCalculee: $consoCalculee, ')
          ..write('partiel: $partiel, ')
          ..write('traite: $traite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          idVehicule.hashCode,
          $mrjc(
              date.hashCode,
              $mrjc(
                  carburant.hashCode,
                  $mrjc(
                      volume.hashCode,
                      $mrjc(
                          montant.hashCode,
                          $mrjc(
                              distance.hashCode,
                              $mrjc(
                                  prixLitre.hashCode,
                                  $mrjc(
                                      additif.hashCode,
                                      $mrjc(
                                          consoAffichee.hashCode,
                                          $mrjc(
                                              consoCalculee.hashCode,
                                              $mrjc(partiel.hashCode,
                                                  traite.hashCode)))))))))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Plein &&
          other.id == this.id &&
          other.idVehicule == this.idVehicule &&
          other.date == this.date &&
          other.carburant == this.carburant &&
          other.volume == this.volume &&
          other.montant == this.montant &&
          other.distance == this.distance &&
          other.prixLitre == this.prixLitre &&
          other.additif == this.additif &&
          other.consoAffichee == this.consoAffichee &&
          other.consoCalculee == this.consoCalculee &&
          other.partiel == this.partiel &&
          other.traite == this.traite);
}

class PleinsCompanion extends UpdateCompanion<Plein> {
  final Value<int> id;
  final Value<int> idVehicule;
  final Value<DateTime> date;
  final Value<Carburants> carburant;
  final Value<double> volume;
  final Value<double> montant;
  final Value<double> distance;
  final Value<double> prixLitre;
  final Value<bool> additif;
  final Value<double> consoAffichee;
  final Value<double> consoCalculee;
  final Value<bool> partiel;
  final Value<bool> traite;
  const PleinsCompanion({
    this.id = const Value.absent(),
    this.idVehicule = const Value.absent(),
    this.date = const Value.absent(),
    this.carburant = const Value.absent(),
    this.volume = const Value.absent(),
    this.montant = const Value.absent(),
    this.distance = const Value.absent(),
    this.prixLitre = const Value.absent(),
    this.additif = const Value.absent(),
    this.consoAffichee = const Value.absent(),
    this.consoCalculee = const Value.absent(),
    this.partiel = const Value.absent(),
    this.traite = const Value.absent(),
  });
  PleinsCompanion.insert({
    this.id = const Value.absent(),
    @required int idVehicule,
    @required DateTime date,
    @required Carburants carburant,
    this.volume = const Value.absent(),
    this.montant = const Value.absent(),
    this.distance = const Value.absent(),
    this.prixLitre = const Value.absent(),
    this.additif = const Value.absent(),
    this.consoAffichee = const Value.absent(),
    this.consoCalculee = const Value.absent(),
    this.partiel = const Value.absent(),
    this.traite = const Value.absent(),
  })  : idVehicule = Value(idVehicule),
        date = Value(date),
        carburant = Value(carburant);
  static Insertable<Plein> custom({
    Expression<int> id,
    Expression<int> idVehicule,
    Expression<DateTime> date,
    Expression<String> carburant,
    Expression<int> volume,
    Expression<int> montant,
    Expression<int> distance,
    Expression<int> prixLitre,
    Expression<bool> additif,
    Expression<int> consoAffichee,
    Expression<int> consoCalculee,
    Expression<bool> partiel,
    Expression<bool> traite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idVehicule != null) 'id_vehicule': idVehicule,
      if (date != null) 'date': date,
      if (carburant != null) 'carburant': carburant,
      if (volume != null) 'volume': volume,
      if (montant != null) 'montant': montant,
      if (distance != null) 'distance': distance,
      if (prixLitre != null) 'prix_litre': prixLitre,
      if (additif != null) 'additif': additif,
      if (consoAffichee != null) 'conso_affichee': consoAffichee,
      if (consoCalculee != null) 'conso_calculee': consoCalculee,
      if (partiel != null) 'partiel': partiel,
      if (traite != null) 'traite': traite,
    });
  }

  PleinsCompanion copyWith(
      {Value<int> id,
      Value<int> idVehicule,
      Value<DateTime> date,
      Value<Carburants> carburant,
      Value<double> volume,
      Value<double> montant,
      Value<double> distance,
      Value<double> prixLitre,
      Value<bool> additif,
      Value<double> consoAffichee,
      Value<double> consoCalculee,
      Value<bool> partiel,
      Value<bool> traite}) {
    return PleinsCompanion(
      id: id ?? this.id,
      idVehicule: idVehicule ?? this.idVehicule,
      date: date ?? this.date,
      carburant: carburant ?? this.carburant,
      volume: volume ?? this.volume,
      montant: montant ?? this.montant,
      distance: distance ?? this.distance,
      prixLitre: prixLitre ?? this.prixLitre,
      additif: additif ?? this.additif,
      consoAffichee: consoAffichee ?? this.consoAffichee,
      consoCalculee: consoCalculee ?? this.consoCalculee,
      partiel: partiel ?? this.partiel,
      traite: traite ?? this.traite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idVehicule.present) {
      map['id_vehicule'] = Variable<int>(idVehicule.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (carburant.present) {
      final converter = $PleinsTable.$converter0;
      map['carburant'] = Variable<String>(converter.mapToSql(carburant.value));
    }
    if (volume.present) {
      final converter = $PleinsTable.$converter1;
      map['volume'] = Variable<int>(converter.mapToSql(volume.value));
    }
    if (montant.present) {
      final converter = $PleinsTable.$converter2;
      map['montant'] = Variable<int>(converter.mapToSql(montant.value));
    }
    if (distance.present) {
      final converter = $PleinsTable.$converter3;
      map['distance'] = Variable<int>(converter.mapToSql(distance.value));
    }
    if (prixLitre.present) {
      final converter = $PleinsTable.$converter4;
      map['prix_litre'] = Variable<int>(converter.mapToSql(prixLitre.value));
    }
    if (additif.present) {
      map['additif'] = Variable<bool>(additif.value);
    }
    if (consoAffichee.present) {
      final converter = $PleinsTable.$converter5;
      map['conso_affichee'] =
          Variable<int>(converter.mapToSql(consoAffichee.value));
    }
    if (consoCalculee.present) {
      final converter = $PleinsTable.$converter6;
      map['conso_calculee'] =
          Variable<int>(converter.mapToSql(consoCalculee.value));
    }
    if (partiel.present) {
      map['partiel'] = Variable<bool>(partiel.value);
    }
    if (traite.present) {
      map['traite'] = Variable<bool>(traite.value);
    }
    return map;
  }
}

class $PleinsTable extends Pleins with TableInfo<$PleinsTable, Plein> {
  final GeneratedDatabase _db;
  final String _alias;
  $PleinsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _idVehiculeMeta = const VerificationMeta('idVehicule');
  GeneratedIntColumn _idVehicule;
  @override
  GeneratedIntColumn get idVehicule => _idVehicule ??= _constructIdVehicule();
  GeneratedIntColumn _constructIdVehicule() {
    return GeneratedIntColumn('id_vehicule', $tableName, false,
        $customConstraints: 'REFERENCES vehicules(id)');
  }

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  GeneratedDateTimeColumn _date;
  @override
  GeneratedDateTimeColumn get date => _date ??= _constructDate();
  GeneratedDateTimeColumn _constructDate() {
    return GeneratedDateTimeColumn(
      'date',
      $tableName,
      false,
    );
  }

  final VerificationMeta _carburantMeta = const VerificationMeta('carburant');
  GeneratedTextColumn _carburant;
  @override
  GeneratedTextColumn get carburant => _carburant ??= _constructCarburant();
  GeneratedTextColumn _constructCarburant() {
    return GeneratedTextColumn(
      'carburant',
      $tableName,
      false,
    );
  }

  final VerificationMeta _volumeMeta = const VerificationMeta('volume');
  GeneratedIntColumn _volume;
  @override
  GeneratedIntColumn get volume => _volume ??= _constructVolume();
  GeneratedIntColumn _constructVolume() {
    return GeneratedIntColumn('volume', $tableName, false,
        defaultValue: const Constant(0));
  }

  final VerificationMeta _montantMeta = const VerificationMeta('montant');
  GeneratedIntColumn _montant;
  @override
  GeneratedIntColumn get montant => _montant ??= _constructMontant();
  GeneratedIntColumn _constructMontant() {
    return GeneratedIntColumn('montant', $tableName, false,
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

  final VerificationMeta _prixLitreMeta = const VerificationMeta('prixLitre');
  GeneratedIntColumn _prixLitre;
  @override
  GeneratedIntColumn get prixLitre => _prixLitre ??= _constructPrixLitre();
  GeneratedIntColumn _constructPrixLitre() {
    return GeneratedIntColumn('prix_litre', $tableName, false,
        defaultValue: const Constant(0));
  }

  final VerificationMeta _additifMeta = const VerificationMeta('additif');
  GeneratedBoolColumn _additif;
  @override
  GeneratedBoolColumn get additif => _additif ??= _constructAdditif();
  GeneratedBoolColumn _constructAdditif() {
    return GeneratedBoolColumn('additif', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _consoAfficheeMeta =
      const VerificationMeta('consoAffichee');
  GeneratedIntColumn _consoAffichee;
  @override
  GeneratedIntColumn get consoAffichee =>
      _consoAffichee ??= _constructConsoAffichee();
  GeneratedIntColumn _constructConsoAffichee() {
    return GeneratedIntColumn('conso_affichee', $tableName, false,
        defaultValue: const Constant(0));
  }

  final VerificationMeta _consoCalculeeMeta =
      const VerificationMeta('consoCalculee');
  GeneratedIntColumn _consoCalculee;
  @override
  GeneratedIntColumn get consoCalculee =>
      _consoCalculee ??= _constructConsoCalculee();
  GeneratedIntColumn _constructConsoCalculee() {
    return GeneratedIntColumn('conso_calculee', $tableName, false,
        defaultValue: const Constant(0));
  }

  final VerificationMeta _partielMeta = const VerificationMeta('partiel');
  GeneratedBoolColumn _partiel;
  @override
  GeneratedBoolColumn get partiel => _partiel ??= _constructPartiel();
  GeneratedBoolColumn _constructPartiel() {
    return GeneratedBoolColumn('partiel', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _traiteMeta = const VerificationMeta('traite');
  GeneratedBoolColumn _traite;
  @override
  GeneratedBoolColumn get traite => _traite ??= _constructTraite();
  GeneratedBoolColumn _constructTraite() {
    return GeneratedBoolColumn('traite', $tableName, false,
        defaultValue: const Constant(true));
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        idVehicule,
        date,
        carburant,
        volume,
        montant,
        distance,
        prixLitre,
        additif,
        consoAffichee,
        consoCalculee,
        partiel,
        traite
      ];
  @override
  $PleinsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'pleins';
  @override
  final String actualTableName = 'pleins';
  @override
  VerificationContext validateIntegrity(Insertable<Plein> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('id_vehicule')) {
      context.handle(
          _idVehiculeMeta,
          idVehicule.isAcceptableOrUnknown(
              data['id_vehicule'], _idVehiculeMeta));
    } else if (isInserting) {
      context.missing(_idVehiculeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date'], _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    context.handle(_carburantMeta, const VerificationResult.success());
    context.handle(_volumeMeta, const VerificationResult.success());
    context.handle(_montantMeta, const VerificationResult.success());
    context.handle(_distanceMeta, const VerificationResult.success());
    context.handle(_prixLitreMeta, const VerificationResult.success());
    if (data.containsKey('additif')) {
      context.handle(_additifMeta,
          additif.isAcceptableOrUnknown(data['additif'], _additifMeta));
    }
    context.handle(_consoAfficheeMeta, const VerificationResult.success());
    context.handle(_consoCalculeeMeta, const VerificationResult.success());
    if (data.containsKey('partiel')) {
      context.handle(_partielMeta,
          partiel.isAcceptableOrUnknown(data['partiel'], _partielMeta));
    }
    if (data.containsKey('traite')) {
      context.handle(_traiteMeta,
          traite.isAcceptableOrUnknown(data['traite'], _traiteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Plein map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Plein.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $PleinsTable createAlias(String alias) {
    return $PleinsTable(_db, alias);
  }

  static TypeConverter<Carburants, String> $converter0 =
      const CarburantsConverter();
  static TypeConverter<double, int> $converter1 = NumericConverter.cents;
  static TypeConverter<double, int> $converter2 = NumericConverter.cents;
  static TypeConverter<double, int> $converter3 = NumericConverter.cents;
  static TypeConverter<double, int> $converter4 = NumericConverter.milli;
  static TypeConverter<double, int> $converter5 = NumericConverter.cents;
  static TypeConverter<double, int> $converter6 = NumericConverter.cents;
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $VehiculesTable _vehicules;
  $VehiculesTable get vehicules => _vehicules ??= $VehiculesTable(this);
  $PleinsTable _pleins;
  $PleinsTable get pleins => _pleins ??= $PleinsTable(this);
  VehiculesDao _vehiculesDao;
  VehiculesDao get vehiculesDao =>
      _vehiculesDao ??= VehiculesDao(this as MyDatabase);
  PleinsDao _pleinsDao;
  PleinsDao get pleinsDao => _pleinsDao ??= PleinsDao(this as MyDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [vehicules, pleins];
}
