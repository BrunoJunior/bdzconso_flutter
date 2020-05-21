import 'package:conso/components/vehicule_bloc.dart';
import 'package:conso/database/database.dart';
import 'package:conso/screens/edit_vehicule.dart';
import 'package:flutter/material.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';

class Home extends StatelessWidget {
  static final String id = 'home';
  final String title;
  final Stream<List<Vehicule>> tousVehicules =
      MyDatabase.instance.vehiculesDao.watchAll();
  Home(this.title);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.bug_report),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MoorDbViewer(MyDatabase.instance),
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: tousVehicules,
        builder: (context, AsyncSnapshot<List<Vehicule>> snapshot) => ListView(
          children: snapshot.data
                  ?.map((vehicule) => VehiculeBloc(vehicule))
                  ?.toList() ??
              [],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, EditVehicule.id),
        tooltip: 'Ajouter un véhicule',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
