import 'package:fueltter/database/database.dart';
import 'package:fueltter/forms/form.dart';
import 'package:fueltter/forms/form_element.dart';
import 'package:fueltter/forms/form_validators.dart';
import 'package:fueltter/models/carburant.dart';
import 'package:intl/intl.dart';

/// Énum permettant de retrouver facilement les champs par leur clé
enum PleinField {
  DATE,
  DISTANCE,
  CONSO_AFFICHEE,
  CARBURANT,
  ADDITIVE,
  PRIX,
  VOLUME,
  PARTIEL,
}

/// Un formulaire, les clés des champs sont présentes dans l'énum PleinField
class PleinForm extends Form<PleinField> {
  /// Véhicule concerné
  final Vehicule vehicule;

  /// Initialisation des champs
  PleinForm(this.vehicule) {
    addField<String>(FormElement(
      PleinField.DATE,
      validator: DateValidator.isNotInFuture,
      initialValue: DateFormat.yMd().format(DateTime.now()),
      errorMsg: 'Revient dans le présent McFly !',
      errorValue: DateFormat.yMd().format(DateTime.now()),
    ));
    addField<String>(FormElement(
      PleinField.DISTANCE,
      validator: DoubleValidator.isGreaterThan(0.0),
      errorMsg: 'Valeur décimale positive requise (42 / 4,2 / 4.2) !',
    ));
    if (vehicule.consoAffichee) {
      addField<String>(FormElement(
        PleinField.CONSO_AFFICHEE,
        validator: DoubleValidator.isGreaterThan(0.0),
        errorMsg: 'Valeur décimale positive requise (42 / 4,2 / 4.2) !',
      ));
    }
    addField<Carburant>(FormElement(
      PleinField.CARBURANT,
      validator: ListValidator.isIn(() => vehicule.carburantsCompatibles),
      errorMsg: 'Carburant non compatible !',
      initialValue: vehicule.carburantFavoris,
    ));
    addField<bool>(FormElement(PleinField.ADDITIVE, initialValue: false));
    addField<String>(FormElement(
      PleinField.PRIX,
      validator: DoubleValidator.isGreaterThan(0.0),
      errorMsg: 'Valeur décimale positive requise (42 / 4,2 / 4.2) !',
    ));
    addField<String>(FormElement(
      PleinField.VOLUME,
      validator: DoubleValidator.isGreaterThan(0.0),
      errorMsg: 'Valeur décimale positive requise (42 / 4,2 / 4.2) !',
    ));
    addField<bool>(FormElement(PleinField.PARTIEL, initialValue: false));
  }

  ///Getters
  FormElement<PleinField, String> get date => getField(PleinField.DATE);
  FormElement<PleinField, Carburant> get carburant =>
      getField(PleinField.CARBURANT);
  FormElement<PleinField, String> get volume => getField(PleinField.VOLUME);
  FormElement<PleinField, String> get montant => getField(PleinField.PRIX);
  FormElement<PleinField, String> get distance => getField(PleinField.DISTANCE);
  FormElement<PleinField, bool> get additif => getField(PleinField.ADDITIVE);
  FormElement<PleinField, String> get consoAffichee =>
      getField(PleinField.CONSO_AFFICHEE);
  FormElement<PleinField, bool> get partiel => getField(PleinField.PARTIEL);
  double get prixLitre {
    final dbVolume = DoubleValidator.parse(volume.value) ?? 0;
    final dbPrix = DoubleValidator.parse(montant.value) ?? 0;
    if (dbVolume == 0 || dbPrix == 0) {
      return null;
    }
    return dbPrix / dbVolume;
  }

  double get consoCalculee {
    final dbVolume = DoubleValidator.parse(volume.value) ?? 0;
    final dbDist = DoubleValidator.parse(distance.value) ?? 0;
    if (dbVolume == 0 || dbDist == 0) {
      return null;
    }
    return 100.0 * dbVolume / dbDist;
  }

  @override
  Future<void> onSubmit() async {
    final plein = Plein(
      id: null,
      idVehicule: vehicule.id,
      date: DateFormat.yMd().parse(date.value),
      carburant: carburant.value,
      volume: DoubleValidator.parse(volume.value),
      montant: DoubleValidator.parse(montant.value),
      distance: DoubleValidator.parse(distance.value),
      prixLitre: prixLitre,
      additif: additif.value,
      consoAffichee: DoubleValidator.parse(consoAffichee.value),
      consoCalculee: consoCalculee,
      partiel: partiel.value,
      traite: !partiel.value,
    );
    await MyDatabase.instance.pleinsDao.addOne(plein);
  }
}
