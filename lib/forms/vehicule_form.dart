import 'dart:collection';
import 'dart:io';

import 'package:fueltter/database/database.dart';
import 'package:fueltter/forms/form.dart';
import 'package:fueltter/forms/form_element.dart';
import 'package:fueltter/forms/form_validators.dart';
import 'package:fueltter/models/carburant.dart';
import 'package:fueltter/services/vehicule_photo_service.dart';

/// Clés des champs du formulaire
enum VehiculeField {
  MARQUE,
  MODELE,
  ANNEE,
  CONSO_AFFICHEE,
  CARBURANTS_COMPATIBLES,
  CARBURANT_FAVORIS,
  PHOTO,
}

class VehiculeForm extends Form<VehiculeField> {
  final Vehicule _initial;

  VehiculeForm({Vehicule vehicule}) : _initial = vehicule {
    addField<String>(FormElement(
      VehiculeField.MARQUE,
      initialValue: _initial?.marque,
      validator: StringValidator.required,
      errorMsg: 'Marque requise',
    ));
    addField<String>(FormElement(
      VehiculeField.MODELE,
      initialValue: _initial?.modele,
      validator: StringValidator.required,
      errorMsg: 'Modèle requis',
    ));
    addField<int>(FormElement(
      VehiculeField.ANNEE,
      initialValue: _initial?.annee,
      validator: (a) => null != a && a <= DateTime.now().year,
      errorMsg: 'Modèle trop futuriste !',
      errorValue: DateTime.now().year,
    ));
    addField<bool>(FormElement(
      VehiculeField.CONSO_AFFICHEE,
      initialValue: _initial?.consoAffichee ?? true,
    ));
    addField<List<Carburant>>(FormElement(
      VehiculeField.CARBURANTS_COMPATIBLES,
      initialValue: _initial?.carburantsCompatibles,
      validator: ListValidator.isNotEmpty,
      errorValue: [],
    ));
    addField<Carburant>(FormElement(
      VehiculeField.CARBURANT_FAVORIS,
      initialValue: _initial?.carburantFavoris,
      validator: ListValidator.isIn(() => carburantsCompatibles),
    ));
    addField<String>(
        FormElement(VehiculeField.PHOTO, initialValue: _initial?.photo));
  }

  /// Getters
  FormElement<VehiculeField, String> get photoPath =>
      getField(VehiculeField.PHOTO);
  FormElement<VehiculeField, String> get marque =>
      getField(VehiculeField.MARQUE);
  FormElement<VehiculeField, String> get modele =>
      getField(VehiculeField.MODELE);
  FormElement<VehiculeField, int> get annee => getField(VehiculeField.ANNEE);
  FormElement<VehiculeField, bool> get consoAffichee =>
      getField(VehiculeField.CONSO_AFFICHEE);
  UnmodifiableListView<Carburant> get carburantsCompatibles =>
      UnmodifiableListView(
          getField(VehiculeField.CARBURANTS_COMPATIBLES).value ?? []);
  FormElement<VehiculeField, Carburant> get carburantFavoris =>
      getField(VehiculeField.CARBURANT_FAVORIS);
  File get photo => File(photoPath.value ?? '__');

  /// Setters
  void toggleCarburantCompatible(Carburant carburant) {
    final compatibles = [...?carburantsCompatibles];
    bool favorisRemoved = false;
    // On essaie d'enlever l'élément de la liste
    if (!compatibles.remove(carburant)) {
      // Il n'a pas été enlevé, c'est qu'il n'y était pas, on l'ajoute
      compatibles.add(carburant);
    } else if (carburant == carburantFavoris.value) {
      // C'est le favoris qui a été enlevé de la liste
      favorisRemoved = true;
    }
    Carburant favoris = carburantFavoris.value;
    if (compatibles.isEmpty) {
      // Plus de carburant compatible, on supprime le favoris
      favoris = null;
    } else if (1 == compatibles.length || favorisRemoved) {
      // Un seul élément ou on a supprimé le favoris, le favoris devient le 1er de la liste
      favoris = compatibles.first;
    }
    getField(VehiculeField.CARBURANTS_COMPATIBLES).change(compatibles);
    carburantFavoris.change(favoris);
  }

  @override
  Future<void> onSubmit() async {
    // La photo a été modifiée
    if (_initial?.photo != photoPath.value) {
      // On supprime la photo initiale
      final filePhoto = File(_initial?.photo ?? '__');
      if (filePhoto.existsSync()) {
        filePhoto.deleteSync();
      }
      if (null != photoPath.value) {
        // On déplace la photo temporaire et on renseigne le chemin final
        photoPath.change(await VehiculePhotoService.instance
            .movePhotoInFinalPath(photoPath.value));
      }
    }
    // Sauvegarde en BDD
    await MyDatabase.instance.vehiculesDao.upsert(Vehicule(
      id: _initial?.id,
      marque: marque.value,
      modele: modele.value,
      consoAffichee: consoAffichee.value,
      annee: annee.value,
      carburantFavoris: carburantFavoris.value,
      carburantsCompatibles: carburantsCompatibles,
      photo: photoPath.value,
    ).toCompanion(true));
  }
}
