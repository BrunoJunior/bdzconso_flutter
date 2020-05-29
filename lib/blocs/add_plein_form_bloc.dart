import 'package:conso/blocs/bloc.dart';
import 'package:conso/database/database.dart';
import 'package:conso/enums/carburants.dart';
import 'package:conso/filters/number_filter.dart';
import 'package:conso/transformers/datetime_transformer.dart';
import 'package:conso/transformers/double_transformer.dart';
import 'package:conso/validators/double_validator.dart';
import 'package:conso/validators/not_in_future_validator.dart';
import 'package:conso/validators/number_validator.dart';
import 'package:conso/validators/required_validator.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class AddPleinFormBloc
    with
        RequiredValidator,
        DoubleValidator,
        NotInFutureValidator,
        DateTimeTransformer,
        DoubleTransformer,
        NumberValidator,
        NumberFilter
    implements Bloc {
  final Vehicule vehicule;

  AddPleinFormBloc(this.vehicule)
      : _pleinController = BehaviorSubject<Plein>.seeded(
          Plein(
            id: null,
            idVehicule: vehicule.id,
            date: null,
            carburant: null,
            volume: null,
            montant: null,
            distance: null,
            prixLitre: null,
            additif: null,
            consoAffichee: null,
            consoCalculee: null,
            partiel: null,
            depuisPartiel: null,
          ),
        ) {
    _dateController.add(DateFormat.yMd().format(DateTime.now()));
    _carburantController.add(vehicule.carburantFavoris);
    if (!vehicule.consoAffichee) {
      _consoController.add(null);
    }
    _additiveController.add(false);
    _partielController.add(false);
    pleinFiller();
  }

  void pleinFiller() {
    date.listen(
      (val) => _pleinController.add(_pleinController.value.copyWith(date: val)),
    );
    carburant.listen(
      (val) =>
          _pleinController.add(_pleinController.value.copyWith(carburant: val)),
    );
    volume.listen(
      (val) =>
          _pleinController.add(_pleinController.value.copyWith(volume: val)),
    );
    prix.listen(
      (val) =>
          _pleinController.add(_pleinController.value.copyWith(montant: val)),
    );
    distance.listen(
      (val) =>
          _pleinController.add(_pleinController.value.copyWith(distance: val)),
    );
    prixLitre.listen(
      (prix) => _pleinController
          .add(_pleinController.value.copyWith(prixLitre: prix)),
    );
    additive.listen(
      (val) =>
          _pleinController.add(_pleinController.value.copyWith(additif: val)),
    );
    consoAffichee.listen(
      (val) => _pleinController
          .add(_pleinController.value.copyWith(consoAffichee: val)),
    );
    consoCalculee.listen(
      (val) => _pleinController
          .add(_pleinController.value.copyWith(consoCalculee: val)),
    );
  }

  /// Internal controllers
  final BehaviorSubject<String> _dateController = BehaviorSubject<String>();
  final BehaviorSubject<String> _distanceController = BehaviorSubject<String>();
  final BehaviorSubject<String> _consoController = BehaviorSubject<String>();
  final BehaviorSubject<Carburants> _carburantController =
      BehaviorSubject<Carburants>();
  final BehaviorSubject<bool> _additiveController = BehaviorSubject<bool>();
  final BehaviorSubject<String> _prixController = BehaviorSubject<String>();
  final BehaviorSubject<String> _volumeController = BehaviorSubject<String>();
  final BehaviorSubject<bool> _partielController = BehaviorSubject<bool>();
  final BehaviorSubject<Plein> _pleinController;
  final BehaviorSubject<bool> _submitController = BehaviorSubject<bool>();

  /// Inputs
  Function(String) get onDateChanged => _dateController.add;
  Function(String) get onDistanceChanged => _distanceController.add;
  Function(String) get onConsoAfficheeChanged => _consoController.add;
  Function(Carburants) get onCarburantChanged => _carburantController.add;
  Function(bool) get onAdditiveChanged => _additiveController.add;
  Function(String) get onPrixChanged => _prixController.add;
  Function(String) get onVolumeChanged => _volumeController.add;
  Function(bool) get onPartielChanged => _partielController.add;
  void get onSubmit => _submitController.add(true);

  /// Outputs (with validators)
  Stream<DateTime> get date => _dateController
      .transform(validateRequired)
      .transform(stringToDateTime(DateFormat.yMd()))
      .transform(validateNotInFuture);
  Stream<double> get distance => _distanceController
      .transform(validateRequired)
      .transform(validateDouble)
      .transform(stringToDouble)
      .transform(validatePositive);
  Stream<double> get prix => _prixController
      .transform(validateRequired)
      .transform(validateDouble)
      .transform(stringToDouble)
      .transform(validatePositive);
  Stream<double> get volume => _volumeController
      .transform(validateRequired)
      .transform(validateDouble)
      .transform(stringToDouble)
      .transform(validatePositive);
  Stream<double> get prixLitre => CombineLatestStream.combine2(
      volume.where(isPositive),
      prix.where(isPositive),
      (double vol, double prix) => prix / vol);
  Stream<double> get consoAffichee => _consoController
      .transform(validateRequired)
      .transform(validateDouble)
      .transform(stringToDouble);
  Stream<Carburants> get carburant => _carburantController.stream;
  Stream<bool> get additive => _additiveController.stream;
  Stream<bool> get partiel => _partielController.stream;
  Stream<double> get consoCalculee => CombineLatestStream.combine2(
      volume.where(isPositive),
      distance.where(isPositive),
      (double vol, double dist) => vol * 100.0 / dist);
  Stream<bool> get isValid => CombineLatestStream(
      [date, distance, prix, volume, prixLitre, consoAffichee],
      (values) => true);

  Stream<PleinsCompanion> get _pleinToSave => CombineLatestStream.combine3(
        _submitController.where((sub) => sub ?? false),
        isValid,
        _pleinController.stream,
        (submit, valid, plein) => plein.toCompanion(true),
      );

  Stream<bool> get isSaved => _pleinToSave
      .asyncMap(
        (PleinsCompanion plein) => MyDatabase.instance.pleinsDao.addOne(plein),
      )
      .mapTo(true);

  @override
  void dispose() {
    _dateController.close();
    _distanceController.close();
    _consoController.close();
    _carburantController.close();
    _additiveController.close();
    _prixController.close();
    _volumeController.close();
    _partielController.close();
    _submitController.close();
    _pleinController.close();
  }
}
