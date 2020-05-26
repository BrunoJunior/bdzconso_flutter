import 'package:conso/database/database.dart';
import 'package:flutter/material.dart';

class GraphsVehicule extends StatelessWidget {
  final Vehicule vehicule;
  final Stream<List<Plein>> pleins;

  GraphsVehicule(this.vehicule)
      : pleins = MyDatabase.instance.pleinsDao.watchAllForVehicule(vehicule.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${vehicule.marque} ${vehicule.modele} (${vehicule.annee})'),
      ),
      body: Container(),
    );
  }
}
