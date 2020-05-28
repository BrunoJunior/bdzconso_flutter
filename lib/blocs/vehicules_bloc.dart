import 'dart:async';

import 'package:conso/blocs/bloc.dart';
import 'package:conso/database/database.dart';
import 'package:rxdart/rxdart.dart';

class VehiculesBloc extends Bloc {
  /// Controllers
  BehaviorSubject<Vehicule> _vehiculeController = BehaviorSubject<Vehicule>();
  StreamController<Vehicule> _addVehiculeController =
      StreamController<Vehicule>.broadcast();
  StreamController<Vehicule> _updateVehiculeController =
      StreamController<Vehicule>.broadcast();

  /// Inputs (Sinks)
  StreamSink<Vehicule> get selectionner => _vehiculeController.sink;
  StreamSink<Vehicule> get ajouter => _addVehiculeController.sink;
  StreamSink<Vehicule> get modifier => _updateVehiculeController.sink;

  /// Output (Streams)
  Stream<Vehicule> get vehiculeSelectionne => _vehiculeController.stream;
  Stream<List<Vehicule>> get mesVehicules =>
      MyDatabase.instance.vehiculesDao.watchAll();
  Stream<Vehicule> get vehiculeAjoute =>
      _addVehiculeController.stream.asyncMap((vehicule) async {
        final id = await MyDatabase.instance.vehiculesDao
            .addOne(vehicule.toCompanion(false));
        return vehicule.copyWith(id: id);
      });
  Stream<Vehicule> get vehiculeModifie =>
      _updateVehiculeController.stream.asyncMap((vehicule) async {
        final id = await MyDatabase.instance.vehiculesDao
            .upsert(vehicule.toCompanion(false));
        return vehicule.copyWith(id: id);
      });

  Vehicule get derinerVehiculeSelectionne => _vehiculeController.value;

  @override
  void dispose() {
    _vehiculeController.close();
    _addVehiculeController.close();
    _updateVehiculeController.close();
  }
}
