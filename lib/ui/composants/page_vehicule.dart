import 'package:flutter/material.dart';
import 'package:fueltter/blocs/bloc_provider.dart';
import 'package:fueltter/blocs/vehicules_bloc.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/ui/composants/loader.dart';

typedef PageVehiculeBuilder = Widget Function(
    BuildContext context, Vehicule vehicule);

class PageVehicule extends StatelessWidget {
  final PageVehiculeBuilder bodyBuilder;
  final PageVehiculeBuilder bottomSheetBuilder;
  final Widget Function(
          BuildContext context, Vehicule vehicule, Scaffold scaffold)
      scaffoldBuilder;
  final Widget fab;
  final String title;

  PageVehicule({
    this.bodyBuilder,
    this.fab,
    this.title,
    this.bottomSheetBuilder,
    this.scaffoldBuilder,
  });

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
          final _body = null == bodyBuilder
              ? const SizedBox.shrink()
              : bodyBuilder(context, snapshot.data);
          final _bottom = (null == bottomSheetBuilder || !snapshot.hasData)
              ? null
              : bottomSheetBuilder(context, snapshot.data);
          final _scaffold = Scaffold(
            appBar: AppBar(title: _title),
            body: _body,
            floatingActionButton: fab,
            bottomSheet: _bottom,
          );
          return (null == scaffoldBuilder)
              ? _scaffold
              : scaffoldBuilder(
                  context,
                  snapshot.data,
                  _scaffold,
                );
        });
  }
}
