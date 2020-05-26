import 'package:conso/database/dao/pleins_dao.dart';
import 'package:conso/database/database.dart';
import 'package:conso/ui/composants/stat_card.dart';
import 'package:conso/ui/router.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StatsVehicule extends StatefulWidget {
  final Vehicule vehicule;
  final Stream<Stats> stats;

  StatsVehicule({Key key, this.vehicule})
      : stats = MyDatabase.instance.pleinsDao.watchStats(vehicule.id),
        super(key: key);

  @override
  _StatsVehiculeState createState() => _StatsVehiculeState();
}

class _StatsVehiculeState extends State<StatsVehicule> {
  Widget _getGrid(Stats stats, Orientation orientation) {
    return GridView.count(
      crossAxisCount: Orientation.portrait == orientation ? 2 : 3,
      children: [
        StatCard.fromInt(
          title: 'Nb pleins',
          value: stats?.count ?? 0,
          icon: Icon(Icons.local_gas_station),
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
          title: 'Stats',
          child: Center(
            child: FaIcon(
              FontAwesomeIcons.chartPie,
              size: 80.0,
            ),
          ),
          onTap: () {},
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.vehicule.marque} ${widget.vehicule.modele} (${widget.vehicule.annee})'),
      ),
      body: StreamBuilder<Stats>(
          stream: widget.stats,
          builder: (context, snapshot) => OrientationBuilder(
              builder: (context, orientation) =>
                  _getGrid(snapshot.data, orientation))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, NouveauPleinRoute,
            arguments: widget.vehicule),
        tooltip: 'Ajouter un plein',
        child: Icon(Icons.local_gas_station),
      ),
    );
  }
}
