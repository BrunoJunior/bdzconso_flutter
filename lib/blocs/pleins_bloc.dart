import 'package:conso/blocs/bloc.dart';
import 'package:conso/database/database.dart';
import 'package:flutter/foundation.dart';

class PleinsBloc extends Bloc {
  final Vehicule vehicule;

  PleinsBloc({@required this.vehicule});

  Stream<List<Plein>> get outListe =>
      MyDatabase.instance.pleinsDao.watchAllForVehicule(vehicule.id);

  Stream<List<Plein>> get outListeAnneePrec {
    DateTime now = DateTime.now();
    return MyDatabase.instance.pleinsDao.watchAnneeGlissante(
      vehicule.id,
      dateMax: DateTime(now.year - 1, now.month, now.day),
    );
  }

  Stream<List<Plein>> get outListeAnnee =>
      MyDatabase.instance.pleinsDao.watchAnneeGlissante(vehicule.id);

  @override
  void dispose() {}
}
