import 'package:flutter/material.dart';
import 'package:fueltter/blocs/bloc_provider.dart';
import 'package:fueltter/blocs/vehicules_bloc.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/ui/composants/bouncing_fab.dart';
import 'package:fueltter/ui/composants/vehicules/vehicules_list.dart';
import 'package:fueltter/ui/router.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';

class Home extends StatelessWidget {
  final String title;
  Home(this.title);
  @override
  Widget build(BuildContext context) {
    final VehiculesBloc vehiculesBloc = BlocProvider.of<VehiculesBloc>(context);
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
        stream: vehiculesBloc.mesVehicules,
        builder: VehiculesList.fromStreamBuilder,
      ),
      floatingActionButton: StreamBuilder<List<Vehicule>>(
          stream: vehiculesBloc.mesVehicules,
          builder: (context, snapshot) {
            return BouncingFAB(
              deactivate: (snapshot.data?.length ?? 0) > 0,
              child: FloatingActionButton(
                onPressed: () =>
                    Navigator.pushNamed(context, EditVehiculeRoute),
                tooltip: 'Ajouter un véhicule',
                child: Icon(Icons.add),
              ),
            );
          }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
