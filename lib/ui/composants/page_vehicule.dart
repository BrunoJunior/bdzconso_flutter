import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/blocs/vehicules_bloc.dart';
import 'package:conso/database/database.dart';
import 'package:conso/ui/composants/loader.dart';
import 'package:flutter/material.dart';

class PageVehicule extends StatelessWidget {
  final Widget Function(BuildContext context, Vehicule vehicule) bodyBuilder;
  final Widget fab;
  final String title;

  PageVehicule({this.bodyBuilder, this.fab, this.title});

  @override
  Widget build(BuildContext context) {
    final VehiculesBloc vehiculesBloc = BlocProvider.of<VehiculesBloc>(context);
    return StreamBuilder<Vehicule>(
        stream: vehiculesBloc.vehiculeSelectionne,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Loader();
          }
          final strVehicule =
              '${snapshot.data.marque} ${snapshot.data.modele} (${snapshot.data.annee})';
          final _title = (title ?? '').isEmpty
              ? Text(strVehicule)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(strVehicule, style: const TextStyle(fontSize: 10.0)),
                    Text(title),
                  ],
                );
          return Scaffold(
            appBar: AppBar(title: _title),
            body: null == bodyBuilder
                ? const SizedBox.shrink()
                : bodyBuilder(context, snapshot.data),
            floatingActionButton: fab,
          );
        });
  }
}
