import 'package:conso/database/database.dart';
import 'package:conso/ui/router.dart';
import 'package:flutter/material.dart';

class StatsVehicule extends StatefulWidget {
  final Vehicule vehicule;

  StatsVehicule({Key key, this.vehicule}) : super(key: key);
  @override
  _StatsVehiculeState createState() => _StatsVehiculeState();
}

class _StatsVehiculeState extends State<StatsVehicule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.vehicule.marque} ${widget.vehicule.modele} (${widget.vehicule.annee})'),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, NouveauPleinRoute,
            arguments: widget.vehicule),
        tooltip: 'Ajouter un plein',
        child: Icon(Icons.local_gas_station),
      ),
    );
  }
}
