import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fueltter/blocs/bloc.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/models/graph_data.dart';
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

  @override
  String toString() {
    return '${pleins?.length} pleins année n, ${pleinsPrec?.length} pleins années n-1, type : ${dataType.toString()}, comparer : ${comparer ? 'OUI' : 'NON'}';
  }
}

class GraphBloc extends Bloc {
  BehaviorSubject<GraphDataType> _bsDataType =
      BehaviorSubject.seeded(GraphDataType.CONSO_CALC);

  BehaviorSubject<bool> _bsComparaison = BehaviorSubject.seeded(true);

  BehaviorSubject<List<Plein>> _bsListePleins = BehaviorSubject();
  BehaviorSubject<List<Plein>> _bsListePleinsPrec = BehaviorSubject();

  Stream<_ListeType> get _listeType => CombineLatestStream.combine4(
      _bsListePleins,
      _bsListePleinsPrec,
      _bsDataType,
      _bsComparaison,
      (List<Plein> pleins, List<Plein> pleinsPrec, type, comparer) =>
          _ListeType(pleins, pleinsPrec, type, comparer));

  /// Sinks (=entrées)
  /// Pleins année courante
  Sink<List<Plein>> get inListePleins => _bsListePleins.sink;

  /// Pleins année prec
  Sink<List<Plein>> get inListePleinsPrec => _bsListePleinsPrec.sink;

  /// Changer le type de graph
  Sink<GraphDataType> get inDefinirTypeGraph => _bsDataType.sink;

  /// Comparer avec l'année précédente
  Sink<bool> get inComparer => _bsComparaison.sink;

  /// Streams (=sorties)
  /// Le type de données
  Stream<GraphDataType> get outDataType => _bsDataType.stream;

  /// Comparaison activée
  Stream<bool> get outComparaison => _bsComparaison.stream;

  /// Fournis les données
  Stream<GraphData> get outData => _listeType.map((listeType) {
        print(listeType);
        return GraphData(
          listeType.pleins,
          spotsAnneePrec: listeType.comparer
              ? _getSpots(listeType, anneePrec: true)
              : [FlSpot.nullSpot],
          spots: _getSpots(listeType),
          moyenne: _getSpots(listeType, moyenne: true),
          couleurs: _getColors(listeType),
        );
      });

  /// Récupère la bonne donnée suivant le type
  ValeurGenerator _generator(GraphDataType dataType) {
    switch (dataType) {
      case GraphDataType.CONSO_CALC:
        return (plein) => plein.consoCalculee;
      case GraphDataType.CONSO_AFF:
        return (plein) => plein.consoAffichee;
      case GraphDataType.MONTANT:
        return (plein) => plein.montant;
      case GraphDataType.DISTANCE:
        return (plein) => plein.distance;
      case GraphDataType.VOLUME:
        return (plein) => plein.volume;
      case GraphDataType.PRIX_LITRE:
        return (plein) => plein.prixLitre;
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
    if (0 == (liste?.length ?? 0)) {
      return [];
    }
    final DateTime start = liste.first.date;
    final valMoyenne =
        moyenne ? (_getMoyenne(listeType) * 100).round() / 100.0 : null;
    return liste
        .map(
          (plein) => FlSpot(
            plein.date.difference(start).inDays.toDouble(),
            moyenne ? valMoyenne : _generator(listeType.dataType)(plein),
          ),
        )
        .toList(growable: false);
  }

  @override
  void dispose() {
    _bsListePleins.close();
    _bsListePleinsPrec.close();
    _bsDataType.close();
    _bsComparaison.close();
  }
}
