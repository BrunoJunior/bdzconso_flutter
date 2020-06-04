import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/enums/carburants.dart';
import 'package:fueltter/enums/form_statuses.dart';
import 'package:fueltter/services/vehicule_photo_service.dart';
import 'package:fueltter/validators/item_validator.dart';
import 'package:moor/moor.dart' show Value;

class VehiculeForm with ChangeNotifier {
  Vehicule _vehicule;
  final Vehicule _initial;
  FormStatus _status = FormStatus.INVALID;

  VehiculeForm({Vehicule vehicule})
      : _initial = vehicule,
        _vehicule = vehicule ??
            Vehicule(
              id: null,
              marque: '',
              modele: '',
              consoAffichee: true,
              annee: DateTime.now().year,
              carburantsCompatibles: [],
            );

  /// Validators
  ItemValidator<String> get _marqueValidator => ItemValidator.stringRequired;
  ItemValidator<String> get _modeleValidator => ItemValidator.stringRequired;
  ItemValidator<int> get _anneeValidator => ItemValidator(
      validation: (a) => a <= DateTime.now().year,
      errorMsg: 'Modèle trop futuriste !');
  ItemValidator<UnmodifiableListView<Carburant>> get _compatiblesValidator =>
      ItemValidator(
          validation: (c) => c.length > 0,
          errorMsg: 'Sélectionner au moins un carburant !');
  ItemValidator<Carburant> get _favorisValidator => ItemValidator(
      validation: (f) => (_vehicule.carburantsCompatibles ?? []).contains(f),
      errorMsg: 'Carburant non compatible !');

  /// Getters
  ValidatedItem<String> get marque => _marqueValidator.check(_vehicule.marque);
  ValidatedItem<String> get modele => _modeleValidator.check(_vehicule.modele);
  ValidatedItem<int> get annee => _anneeValidator.check(_vehicule.annee);
  bool get consoAffichee => _vehicule.consoAffichee ?? false;
  ValidatedItem<UnmodifiableListView<Carburant>> get carburantsCompatibles =>
      _compatiblesValidator
          .check(UnmodifiableListView(_vehicule.carburantsCompatibles ?? []));
  ValidatedItem<Carburant> get carburantFavoris =>
      _favorisValidator.check(_vehicule.carburantFavoris);
  String get pathPhoto => _vehicule.photo;
  File get photo => File(pathPhoto ?? '__');
  FormStatus get status => _status;

  void _check() {
    final noErrors = [
      marque,
      modele,
      annee,
      carburantsCompatibles,
      carburantFavoris,
    ].where((el) => el.hasError()).isEmpty;
    _status = noErrors ? FormStatus.VALID : FormStatus.INVALID;
    notifyListeners();
  }

  /// Setters
  void changeMarque(String marque) {
    _vehicule = _vehicule.copyWith(marque: marque);
    _check();
  }

  void changeModele(String modele) {
    _vehicule = _vehicule.copyWith(modele: modele);
    _check();
  }

  void changeAnnee(int annee) {
    _vehicule = _vehicule.copyWith(annee: annee);
    _check();
  }

  void changeConsoAffichee(bool consoAffichee) {
    _vehicule = _vehicule.copyWith(consoAffichee: consoAffichee);
    _check();
  }

  void toggleCarburantCompatible(Carburant carburant) {
    final compatibles = [...?_vehicule.carburantsCompatibles];
    bool favorisRemoved = false;
    // On essaie d'enlever l'élément de la liste
    if (!compatibles.remove(carburant)) {
      // Il n'a pas été enlevé, c'est qu'il n'y était pas, on l'ajoute
      compatibles.add(carburant);
    } else if (carburant == _vehicule.carburantFavoris) {
      // C'est le favoris qui a été enlevé de la liste
      favorisRemoved = true;
    }
    Carburant favoris = _vehicule.carburantFavoris;
    if (compatibles.isEmpty) {
      // Plus de carburant compatible, on supprime le favoris
      favoris = null;
    } else if (1 == compatibles.length || favorisRemoved) {
      // Un seul élément ou on a supprimé le favoris, le favoris devient le 1er de la liste
      favoris = compatibles.first;
    }
    _vehicule = _vehicule.copyWith(
      carburantsCompatibles: compatibles,
      carburantFavoris: favoris,
    );
    _check();
  }

  void changeCarburantFavoris(Carburant carburantFavoris) {
    _vehicule = _vehicule.copyWith(carburantFavoris: carburantFavoris);
    _check();
  }

  void changePathPhoto(String path) {
    _vehicule = _vehicule.copyWith(photo: path);
    _check();
  }

  Future<void> onSubmit() async {
    if (FormStatus.VALID != _status) {
      return;
    }
    // En cours de soumission
    _status = FormStatus.SUBMITTING;
    notifyListeners();
    VehiculesCompanion companion = _vehicule.toCompanion(true);
    // La photo a été modifiée
    if (_initial?.photo != _vehicule.photo) {
      // On supprime la photo initiale
      final filePhoto = File(_initial?.photo ?? '__');
      if (filePhoto.existsSync()) {
        filePhoto.deleteSync();
      }
      if (null != pathPhoto) {
        // On déplace la photo temporaire et on renseigne le chemin final
        companion = companion.copyWith(
            photo: Value(await VehiculePhotoService.instance
                .movePhotoInFinalPath(_vehicule.photo)));
      }
    }
    // Sauvegarde en BDD
    await MyDatabase.instance.vehiculesDao.upsert(companion);
    // Soumis
    _status = FormStatus.SUBMITTED;
    notifyListeners();
  }
}
