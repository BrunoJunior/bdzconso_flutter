import 'package:flutter/material.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/models/vehicules_list_data.dart';
import 'package:provider/provider.dart';

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
    return Selector<VehiculeListData, Vehicule>(
        selector: (_, data) => data.selectedVehicule,
        builder: (context, vehicule, __) {
          final strVehicule =
              '${vehicule.marque} ${vehicule.modele} (${vehicule.annee})';
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
              : bodyBuilder(context, vehicule);
          final _bottom = (null == bottomSheetBuilder)
              ? null
              : bottomSheetBuilder(context, vehicule);
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
                  vehicule,
                  _scaffold,
                );
        });
  }
}
