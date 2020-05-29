import 'package:conso/blocs/bloc.dart';
import 'package:conso/database/database.dart';
import 'package:conso/models/liste_pleins_annuels.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class PleinsBloc extends Bloc {
  final Vehicule vehicule;

  PleinsBloc({@required this.vehicule});

  Stream<List<Plein>> get outListe =>
      MyDatabase.instance.pleinsDao.watchAllForVehicule(vehicule.id);

  Stream<List<Plein>> get _listeAnneePrec {
    DateTime now = DateTime.now();
    return MyDatabase.instance.pleinsDao.watchAnneeGlissante(
      vehicule.id,
      dateMax: DateTime(now.year - 1, now.month, now.day),
    );
  }

  Stream<List<Plein>> get _listeAnnee =>
      MyDatabase.instance.pleinsDao.watchAnneeGlissante(vehicule.id);

  Stream<ListePleinsAnnuels> get outListePleinsAnnuels => MergeStream([
        _listeAnnee.map((pleins) => ListePleinsAnnuels(pleins)),
        _listeAnneePrec.map(
          (pleins) => ListePleinsAnnuels(pleins, anneePrec: true),
        ),
      ]);

  @override
  void dispose() {}
}
