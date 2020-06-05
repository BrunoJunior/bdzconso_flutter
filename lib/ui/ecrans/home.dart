import 'package:flutter/material.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/models/vehicules_list_data.dart';
import 'package:fueltter/ui/composants/bouncing_fab.dart';
import 'package:fueltter/ui/composants/vehicules/vehicules_list.dart';
import 'package:fueltter/ui/router.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes véhicules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MoorDbViewer(MyDatabase.instance),
              ),
            ),
          )
        ],
      ),
      body: VehiculesList(),
      floatingActionButton:
          Consumer<VehiculeListData>(builder: (context, model, __) {
        return BouncingFAB(
          deactivate: model.vehicules.length > 0,
          child: FloatingActionButton(
            onPressed: () {
              Provider.of<VehiculeListData>(context, listen: false)
                  .selectedVehicule = null;
              Navigator.pushNamed(context, EditVehiculeRoute);
            },
            tooltip: 'Ajouter un véhicule',
            child: const Icon(Icons.add),
          ),
        );
      }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
