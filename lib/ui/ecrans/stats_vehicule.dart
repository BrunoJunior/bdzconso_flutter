import 'package:conso/database/dao/pleins_dao.dart';
import 'package:conso/database/database.dart';
import 'package:conso/ui/composants/stat_card.dart';
import 'package:conso/ui/router.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StatsVehicule extends StatelessWidget {
  final Vehicule vehicule;
  final Stream<Stats> stats;

  StatsVehicule(this.vehicule, {Key key})
      : stats = MyDatabase.instance.pleinsDao.watchStats(vehicule.id),
        super(key: key);

  Widget _getGrid(BuildContext context, Stats stats, Orientation orientation) {
    return GridView.count(
      crossAxisCount: Orientation.portrait == orientation ? 2 : 3,
      children: [
        StatCard.fromInt(
          title: 'Nb pleins',
          value: stats?.count ?? 0,
          icon: Icon(Icons.local_gas_station),
          onTap: () => Navigator.pushNamed(
            context,
            ListePleinsRoute,
            arguments: vehicule,
          ),
        ),
        StatCard.fromDouble(
          title: 'Moyenne',
          value: stats?.consoMoyenne ?? 0.0,
          suffix: 'L/100km',
          fractionDigits: 2,
          icon: FaIcon(FontAwesomeIcons.tachometerAlt),
        ),
        StatCard.fromInt(
          title: 'Distance',
          value: stats?.distanceCumulee ?? 0,
          fractionDigits: 2,
          suffix: 'km',
          icon: FaIcon(FontAwesomeIcons.car),
          mainAxisSize: MainAxisSize.max,
        ),
        StatCard.fromInt(
          title: 'Dépense',
          value: stats?.montantCumule ?? 0,
          fractionDigits: 2,
          suffix: '€',
          icon: FaIcon(FontAwesomeIcons.receipt),
        ),
        StatCard.fromInt(
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
          onTap: () => Navigator.pushNamed(
            context,
            GraphsVehiculeRoute,
            arguments: vehicule,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${vehicule.marque} ${vehicule.modele} (${vehicule.annee})'),
      ),
      body: StreamBuilder<Stats>(
          stream: stats,
          builder: (context, snapshot) => OrientationBuilder(
              builder: (context, orientation) =>
                  _getGrid(context, snapshot.data, orientation))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(
          context,
          NouveauPleinRoute,
          arguments: vehicule,
        ),
        tooltip: 'Ajouter un plein',
        child: Icon(Icons.local_gas_station),
      ),
    );
  }
}
