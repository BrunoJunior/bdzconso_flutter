import 'package:conso/blocs/stats_bloc.dart';
import 'package:conso/database/dao/pleins_dao.dart';
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
          fractionDigits: 2,
          suffix: 'km',
          icon: FaIcon(FontAwesomeIcons.car),
          mainAxisSize: MainAxisSize.max,
        ),
        StatCard.fromDouble(
          title: 'Dépense',
          value: stats?.montantCumule ?? 0,
          fractionDigits: 2,
          suffix: '€',
          icon: FaIcon(FontAwesomeIcons.receipt),
        ),
        StatCard.fromDouble(
          title: 'Volume',
          value: stats?.volumeCumule ?? 0,
          fractionDigits: 2,
          suffix: 'L',
          icon: FaIcon(FontAwesomeIcons.water),
        ),
        StatCard(
          title: 'Graphs',
          icon: FaIcon(FontAwesomeIcons.chartLine),
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.chartPie,
              size: 80.0,
            ),
          ),
          onTap: () => Navigator.pushNamed(context, GraphsVehiculeRoute),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageVehicule(
      bodyBuilder: (context, vehicule) {
        final statsBloc = StatsBloc(vehicule: vehicule);
        return StreamBuilder<Stats>(
          stream: statsBloc.outStats,
          builder: (context, snapshot) => OrientationBuilder(
            builder: (context, orientation) => _getGrid(
              context,
              snapshot.data,
              Orientation.portrait == orientation ? 2 : 3,
            ),
          ),
        );
      },
      fab: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, NouveauPleinRoute),
        tooltip: 'Ajouter un plein',
        child: Icon(Icons.local_gas_station),
      ),
    );
  }
}
