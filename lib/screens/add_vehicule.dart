import 'package:conso/database.dart';
import 'package:conso/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart' show Value;

class AddVehicule extends StatefulWidget {
  static final String id = 'add_vehicule';
  @override
  _AddVehiculeState createState() => _AddVehiculeState();
}

class _AddVehiculeState extends State<AddVehicule> {
  String marque, modele = '';
  int annee = 2020;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Création véhicule"),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: "Marque"),
            onChanged: (value) => marque = value,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Modèle"),
            onChanged: (value) => modele = value,
          ),
          RaisedButton(
            child: Text("Ajouter"),
            onPressed: () {
              database
                  .addVehicule(
                    VehiculesCompanion(
                      marque: Value(marque),
                      modele: Value(modele),
                      annee: Value(annee),
                    ),
                  )
                  .then((id) => Navigator.pop(context))
                  .catchError((err) => print(err));
            },
          )
        ],
      ),
    );
  }
}
