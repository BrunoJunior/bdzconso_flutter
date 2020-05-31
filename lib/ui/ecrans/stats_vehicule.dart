import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/blocs/stats_bloc.dart';
import 'package:conso/blocs/vehicules_bloc.dart';
import 'package:conso/models/stats.dart';
import 'package:conso/ui/composants/bouncing_fab.dart';
import 'package:conso/ui/composants/loader.dart';
import 'package:conso/ui/composants/page_vehicule.dart';
import 'package:conso/ui/composants/stat_card.dart';
import 'package:conso/ui/router.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StatsVehiculeScreen extends StatelessWidget {
  Widget _getGrid(BuildContext context, Stats stats, int nbColonnes) {
    return GridView.count(
      crossAxisCount: nbColonnes,
      children: [
        StatCard.fromInt(
          title: 'Nb pleins',
          value: stats?.count ?? 0,
          icon: Icon(Icons.local_gas_station),
          onTap: () => Navigator.pushNamed(context, ListePleinsRoute),
        ),
        StatCard.fromDouble(
          title: 'Moyenne',
          value: stats?.consoMoyenne ?? 0.0,
          suffix: 'L/100km',
          fractionDigits: 2,
          icon: FaIcon(FontAwesomeIcons.tachometerAlt),
        ),
        StatCard.fromDouble(
          title: 'Distance',
          value: stats?.distanceCumulee ?? 0,
          suffix: 'km',
          icon: FaIcon(FontAwesomeIcons.car),
          mainAxisSize: MainAxisSize.max,
        ),
        StatCard.fromDouble(
          title: 'Dépense',
          value: stats?.montantCumule ?? 0,
          suffix: '€',
          icon: FaIcon(FontAwesomeIcons.receipt),
        ),
        StatCard.fromDouble(
          title: 'Volume',
          value: stats?.volumeCumule ?? 0,
          suffix: 'L',
          icon: FaIcon(FontAwesomeIcons.water),
        ),
        Visibility(
          visible: (stats?.count ?? 0) > 0,
          child: StatCard(
            title: 'Graphs',
            icon: FaIcon(FontAwesomeIcons.chartLine),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.chartPie,
                size: 80.0,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, GraphsVehiculeRoute),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Stats>(
        stream: (BlocProvider.of<VehiculesBloc>(context))
            .vehiculeSelectionne
            .asyncExpand((v) => StatsBloc(vehicule: v).outStats),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loader();
          }
          return PageVehicule(
            title: 'Statistiques générales',
            bodyBuilder: (context, vehicule) {
              return OrientationBuilder(
                builder: (context, orientation) => _getGrid(
                  context,
                  snapshot.data,
                  Orientation.portrait == orientation ? 2 : 3,
                ),
              );
            },
            fab: BouncingFAB(
              deactivate: snapshot.hasData && snapshot.data.count > 0,
              child: FloatingActionButton(
                onPressed: () =>
                    Navigator.pushNamed(context, NouveauPleinRoute),
                tooltip: 'Ajouter un plein',
                child: Icon(Icons.local_gas_station),
              ),
            ),
          );
        });
  }
}
