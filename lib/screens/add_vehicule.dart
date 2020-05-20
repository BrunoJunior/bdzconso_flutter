import 'package:conso/database/database.dart';
import 'package:conso/enums/carburants.dart';
import 'package:conso/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart' show Value;

class AddVehicule extends StatefulWidget {
  static final String id = 'add_vehicule';
  static final int anneeCourante = DateTime.now().year;

  Iterable<int> annees() sync* {
    int k = anneeCourante - 50;
    while (k <= anneeCourante) yield k++;
  }

  @override
  _AddVehiculeState createState() => _AddVehiculeState();
}

class _AddVehiculeState extends State<AddVehicule> {
  String marque, modele = '';
  int annee = AddVehicule.anneeCourante;
  bool consoAffichee = true;
  Set<Carburants> carburantsCompatibles = Set<Carburants>();
  Carburants favoris;

  _save() async {
    try {
      VehiculesCompanion data = VehiculesCompanion(
        marque: Value(marque),
        modele: Value(modele),
        annee: Value(annee),
        consoAffichee: Value(consoAffichee),
        carburantsCompatibles: Value(carburantsCompatibles.toList()),
        carburantFavoris: favoris != null ? Value(favoris) : Value.absent(),
      );
      int id = await database.vehiculesDao.addOne(data);
      print(id);
      Navigator.pop(context);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Création véhicule"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _save,
          )
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Marque *',
                icon: Icon(Icons.location_city),
              ),
              onChanged: (String value) => marque = value,
              validator: (String value) {
                return value.isEmpty ? 'Champ requis' : null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Modèle *',
                icon: Icon(Icons.directions_car),
              ),
              onChanged: (String value) => modele = value,
              validator: (String value) {
                return value.isEmpty ? 'Champ requis' : null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 32.0),
                      child: Icon(Icons.calendar_today),
                    ),
                    Text(
                      'Année',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                DropdownButton<int>(
                  items: widget
                      .annees()
                      .map(
                        (value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        ),
                      )
                      .toList(),
                  value: annee,
                  onChanged: (value) => setState(() => annee = value),
                )
              ],
            ),
          ),
          SwitchListTile(
            title: Text('Consommation affichée'),
            value: consoAffichee,
            onChanged: (bool value) => setState(() => consoAffichee = value),
            secondary: const Icon(Icons.equalizer),
          ),
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 32.0),
                    child: Icon(Icons.local_gas_station),
                  ),
                  Text(
                    "Carburants compatibles",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Wrap(
                spacing: 20.0,
                alignment: WrapAlignment.center,
                children: Carburants.values.map((carburant) {
                  CarburantDisplayer displayer = CarburantDisplayer(carburant);
                  return ActionChip(
                    label: Text(displayer.libelle),
                    backgroundColor: carburantsCompatibles.contains(carburant)
                        ? displayer.background
                        : Colors.black26,
                    elevation: 10.0,
                    labelStyle: TextStyle(
                        color: carburantsCompatibles.contains(carburant)
                            ? displayer.color
                            : Colors.white),
                    onPressed: () => setState(() {
                      if (!carburantsCompatibles.remove(carburant)) {
                        carburantsCompatibles.add(carburant);
                        if (null == favoris) {
                          favoris = carburant;
                        }
                      } else if (carburant == favoris &&
                          carburantsCompatibles.length > 0) {
                        favoris = carburantsCompatibles.first;
                      }
                    }),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 32.0),
                          child: Icon(Icons.star),
                        ),
                        Text(
                          'Carburant favoris',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    DropdownButton<Carburants>(
                      items: Carburants.values
                          .map(
                            (carburant) => DropdownMenuItem<Carburants>(
                              value: carburant,
                              child:
                                  Text(CarburantDisplayer(carburant).libelle),
                            ),
                          )
                          .toList(),
                      value: favoris,
                      onChanged: (carburant) =>
                          setState(() => favoris = carburant),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
