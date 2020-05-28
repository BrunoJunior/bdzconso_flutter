import 'package:conso/blocs/bloc.dart';
import 'package:conso/blocs/pleins_bloc.dart';
import 'package:conso/database/converters/numeric_converter.dart';
import 'package:conso/database/database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

enum GraphDataType {
  CONSO_CALC,
  CONSO_AFF,
  MONTANT,
  DISTANCE,
  VOLUME,
  PRIX_LITRE
}

const Map<GraphDataType, String> MapLabelTypes = {
  GraphDataType.CONSO_CALC: 'Consommation (L/100km)',
  GraphDataType.CONSO_AFF: 'Consommation affichée (L/100km)',
  GraphDataType.MONTANT: 'Montant (€)',
  GraphDataType.DISTANCE: 'Distance (km)',
  GraphDataType.VOLUME: 'Volume (L)',
  GraphDataType.PRIX_LITRE: 'Prix au litre (€/L)',
};

typedef ValeurGenerator = double Function(Plein plein);

class _PositionnedColor {
  final int position;
  final Color color;
  _PositionnedColor({this.position, this.color});
}

class _ListeType {
  final List<Plein> pleins;
  final List<Plein> pleinsPrec;
  final GraphDataType dataType;
  final bool comparer;
  _ListeType(this.pleins, this.pleinsPrec, this.dataType, this.comparer);
}

class GraphData {
  final List<FlSpot> moyenne;
  final List<FlSpot> spots;
  final List<FlSpot> spotsAnneePrec;
  final List<Color> couleurs;
  final List<Plein> pleins;
  GraphData(
    this.pleins, {
    @required this.spots,
    @required this.spotsAnneePrec,
    @required this.moyenne,
    @required this.couleurs,
  });

  String getTitle(double value) {
    final DateTime start = pleins?.first?.date;
    if (null == start) {
      return "";
    }
    final DateTime valueDate = start.add(Duration(days: value.toInt()));
    if (0.0 == value || 1 == valueDate.day) {
      return DateFormat(DateFormat.ABBR_MONTH).format(valueDate);
    }
    return '';
  }

  double get min => [...spots, ...spotsAnneePrec]
      .where((spot) => null != spot.y)
      .reduce((spot1, spot2) => spot1.y < spot2.y ? spot1 : spot2)
      .y;

  double get max => [...spots, ...spotsAnneePrec]
      .where((spot) => null != spot.y)
      .reduce((spot1, spot2) => spot1.y > spot2.y ? spot1 : spot2)
      .y;
}

class GraphBloc extends Bloc {
  final PleinsBloc pleinsBloc;
  GraphBloc({@required this.pleinsBloc});

  BehaviorSubject<GraphDataType> _bsDataType =
      BehaviorSubject.seeded(GraphDataType.CONSO_CALC);

  BehaviorSubject<bool> _bsComparaison = BehaviorSubject.seeded(true);

  Stream<_ListeType> get _listePleins => CombineLatestStream.combine4(
      pleinsBloc.outListeAnneeGlissante,
      pleinsBloc.outListeAnneePrec,
      _bsDataType,
      _bsComparaison,
      (pleins, pleinsPrec, type, comparer) =>
          _ListeType(pleins, pleinsPrec, type, comparer));

  /// Sinks (=entrées)
  /// Changer le type de graph
  Sink<GraphDataType> get inDefinirTypeGraph => _bsDataType.sink;

  /// Comparer avec l'année précédente
  Sink<bool> get inComparer => _bsComparaison.sink;

  /// Streams (=sorties)
  /// Le type de données
  Stream<GraphDataType> get outDataType => _bsDataType.stream;

  /// Conparaison activée
  Stream<bool> get outComparaison => _bsComparaison.stream;

  /// Fournis la moyenne
  Stream<double> get outMoyenne => _listePleins.map(_getMoyenne);

  /// Fournis les couleurs
  Stream<List<Color>> get outCouleurs => _listePleins.map(_getColors);

  /// Fournis les spots (points du graphique)
  Stream<List<FlSpot>> get outSpots => _listePleins.map(_getSpots);

  /// Fournis les données
  Stream<GraphData> get outData => _listePleins.map(
        (listeType) => GraphData(
          listeType.pleins,
          spotsAnneePrec: listeType.comparer
              ? _getSpots(listeType, anneePrec: true)
              : [FlSpot.nullSpot],
          spots: _getSpots(listeType),
          moyenne: _getSpots(listeType, moyenne: true),
          couleurs: _getColors(listeType),
        ),
      );

  /// Récupère le bon convertisseur suivant le type
  NumericConverter _converter(GraphDataType dataType) {
    switch (dataType) {
      case GraphDataType.PRIX_LITRE:
        return NumericConverter.milli;
      default:
        return NumericConverter.cents;
    }
  }

  /// Récupère la bonne donnée suivant le type
  ValeurGenerator _generator(GraphDataType dataType) {
    final converter = _converter(dataType).getNumberFromString;
    switch (dataType) {
      case GraphDataType.CONSO_CALC:
        return (plein) => converter(plein.consoCalculee);
      case GraphDataType.CONSO_AFF:
        return (plein) => converter(plein.consoAffichee);
      case GraphDataType.MONTANT:
        return (plein) => converter(plein.montant);
      case GraphDataType.DISTANCE:
        return (plein) => converter(plein.distance);
      case GraphDataType.VOLUME:
        return (plein) => converter(plein.volume);
      case GraphDataType.PRIX_LITRE:
        return (plein) => converter(plein.prixLitre);
    }
    return (plein) => 0.0;
  }

  /// Calcul de la moyenne suivant le type
  double _getMoyenne(_ListeType listeType) {
    final nbPleins = listeType.pleins?.length ?? 0;
    if (0 == nbPleins) {
      return 0.0;
    }
    switch (listeType.dataType) {
      /*
       * La consommation moyenne n'est pas la moyenne des consommations
       * Mais la somme du volume divisé par la somme des distances
       */
      case GraphDataType.CONSO_CALC:
        final sumVol = listeType.pleins.fold(0,
            (value, plein) => value + _generator(GraphDataType.VOLUME)(plein));
        final sumDist = listeType.pleins.fold(
            0,
            (value, plein) =>
                value + _generator(GraphDataType.DISTANCE)(plein));
        return sumVol / sumDist * 100.0;
      case GraphDataType.CONSO_AFF:
        final sumVol = listeType.pleins.fold(
          0,
          (value, plein) => (value +
              (_generator(GraphDataType.CONSO_AFF)(plein) *
                  _generator(GraphDataType.DISTANCE)(plein) /
                  100.0)),
        );
        final sumDist = listeType.pleins.fold(
            0,
            (value, plein) =>
                value + _generator(GraphDataType.DISTANCE)(plein));
        return sumVol / sumDist * 100.0;
      /*
       * Calcul de la moyenne
       */
      default:
        return listeType.pleins.fold(
                0,
                (value, plein) =>
                    (value + _generator(listeType.dataType)(plein))) /
            nbPleins;
    }
  }

  /// Récupération des couleurs du graphique
  List<Color> _getColors(_ListeType listeType) {
    if ((listeType.pleins?.length ?? 0) < 2) {
      return [Colors.red];
    }
    final moyenne = _getMoyenne(listeType);
    final firstDate = listeType.pleins.first.date;

    List<_PositionnedColor> positions = listeType.pleins
        .map((plein) => _PositionnedColor(
              position: plein.date.difference(firstDate).inDays,
              color: _generator(listeType.dataType)(plein) > moyenne
                  ? Colors.redAccent
                  : Colors.greenAccent,
            ))
        .toList();

    List<Color> couleurs = [];
    int margeBasse = 0;
    for (int i = 0; i < positions.length; i++) {
      final positionnedColor = positions[i];
      final margeHaute = (i == (positions.length - 1))
          ? positionnedColor.position
          : ((positions[i + 1].position - positionnedColor.position) / 2)
                  .truncate() +
              positionnedColor.position;
      for (int j = margeBasse; j <= margeHaute; j++) {
        couleurs.add(positionnedColor.color);
      }
      margeBasse = (margeHaute + 1);
    }
    return couleurs;
  }

  /// Calcul des points pour le graphique
  List<FlSpot> _getSpots(_ListeType listeType,
      {bool moyenne = false, bool anneePrec = false}) {
    final List<Plein> liste =
        anneePrec ? listeType.pleinsPrec : listeType.pleins;
    final DateTime start = liste?.first?.date;
    if (null == start) {
      return [FlSpot(0, 0)];
    }
    return liste
        .map(
          (plein) => FlSpot(
            plein.date.difference(start).inDays.toDouble(),
            moyenne
                ? (_getMoyenne(listeType) * 100).round() / 100.0
                : _generator(listeType.dataType)(plein),
          ),
        )
        .toList(growable: false);
  }

  @override
  void dispose() {
    pleinsBloc.dispose();
    _bsDataType.close();
    _bsComparaison.close();
  }
}
