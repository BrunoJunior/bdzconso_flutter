import 'dart:async';

import 'package:conso/blocs/bloc.dart';
import 'package:conso/database/database.dart';
import 'package:rxdart/rxdart.dart';

class VehiculesBloc extends Bloc {
  /// Controllers
  BehaviorSubject<Vehicule> _vehiculeController = BehaviorSubject<Vehicule>();
  StreamController<Vehicule> _addController = StreamController<Vehicule>();
  StreamController<Vehicule> _updateController = StreamController<Vehicule>();

  /// Inputs (Sinks)
  StreamSink<Vehicule> get selectionner => _vehiculeController.sink;
  StreamSink<Vehicule> get ajouter => _addController.sink;
  StreamSink<Vehicule> get modifier => _updateController.sink;

  /// Output (Streams)
  Stream<Vehicule> get vehiculeSelectionne => _vehiculeController.stream;
  Stream<List<Vehicule>> get mesVehicules =>
      MyDatabase.instance.vehiculesDao.watchAll();

  VehiculesBloc() {
    _addController.stream.listen(
      (vehicule) => MyDatabase.instance.vehiculesDao.addOne(
        vehicule.toCompanion(false),
      ),
    );
    _updateController.stream.listen(
      (vehicule) => MyDatabase.instance.vehiculesDao.upsert(
        vehicule.toCompanion(false),
      ),
    );
  }

  @override
  void dispose() {
    _vehiculeController.close();
    _addController.close();
    _updateController.close();
  }
}
