import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:fueltter/database/database.dart';

class VehiculeListData with ChangeNotifier {
  List<Vehicule> _vehicules = [];
  Vehicule _selectedVehicule;
  List<StreamSubscription> _subs = [];

  VehiculeListData() {
    // Écoute les modifications de vehicules de la BDD
    _subs.add(MyDatabase.instance.vehiculesDao.watchAll().listen((liste) {
      _vehicules = liste;
      notifyListeners();
    }));
  }

  UnmodifiableListView<Vehicule> get vehicules =>
      UnmodifiableListView(_vehicules);

  Vehicule get selectedVehicule => _selectedVehicule;

  set selectedVehicule(Vehicule vehicule) {
    _selectedVehicule = vehicule;
    notifyListeners();
  }

  void addNewVehicule(Vehicule newVehicule) async {
    await MyDatabase.instance.vehiculesDao
        .addOne(newVehicule.toCompanion(false));
  }

  void update(Vehicule vehicule) async {
    await MyDatabase.instance.vehiculesDao.upsert(vehicule.toCompanion(false));
  }

  @override
  void dispose() {
    _subs
      ..forEach((element) => element.cancel())
      ..clear();
    super.dispose();
  }
}
