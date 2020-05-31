import 'dart:async';

import 'package:conso/blocs/bloc.dart';
import 'package:conso/database/database.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class PleinsBloc implements Bloc {
  final Vehicule vehicule;

  final BehaviorSubject<Plein> _supprController = BehaviorSubject();
  final Stream<List<Plein>> _liste;

  PleinsBloc({@required this.vehicule})
      : _liste = MyDatabase.instance.pleinsDao.watchAllForVehicule(vehicule.id);

  Stream<List<Plein>> get outListe => _liste;

  Stream<String> get outSupprError => outSupprime.transform(
        StreamTransformer.fromHandlers(
            handleError: (err, stack, EventSink<String> sink) =>
                sink.add(err.toString()),
            handleData: (data, EventSink<String> sink) => sink.add(null)),
      );

  Stream<List<Plein>> get outListeAnneePrec {
    DateTime now = DateTime.now();
    return MyDatabase.instance.pleinsDao.watchAnneeGlissante(
      vehicule.id,
      dateMax: DateTime(now.year - 1, now.month, now.day),
    );
  }

  Stream<Plein> get outSupprime => _supprController
      .asyncMap((plein) => MyDatabase.instance.pleinsDao.deleteOne(plein));

  Stream<List<Plein>> get outListeAnnee =>
      MyDatabase.instance.pleinsDao.watchAnneeGlissante(vehicule.id);

  Sink<Plein> get inSupprimer => _supprController.sink;

  @override
  void dispose() {
    _supprController.close();
  }
}
