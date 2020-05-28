import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/blocs/vehicules_bloc.dart';
import 'package:conso/database/database.dart';
import 'package:conso/ui/composants/loader.dart';
import 'package:flutter/material.dart';

class PageVehicule extends StatelessWidget {
  final Widget Function(BuildContext context, Vehicule vehicule) bodyBuilder;
  final Widget fab;

  PageVehicule({this.bodyBuilder, this.fab});

  @override
  Widget build(BuildContext context) {
    final VehiculesBloc vehiculesBloc = BlocProvider.of<VehiculesBloc>(context);
    return StreamBuilder<Vehicule>(
      stream: vehiculesBloc.vehiculeSelectionne,
      builder: (context, snapshot) => null == snapshot.data
          ? Loader()
          : Scaffold(
              appBar: AppBar(
                title: Text(
                    '${snapshot.data.marque} ${snapshot.data.modele} (${snapshot.data.annee})'),
              ),
              body: null == bodyBuilder
                  ? SizedBox.shrink()
                  : bodyBuilder(context, snapshot.data),
              floatingActionButton: fab,
            ),
    );
  }
}
