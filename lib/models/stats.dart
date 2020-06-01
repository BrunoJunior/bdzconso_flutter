import 'package:flutter/foundation.dart';
import 'package:fueltter/database/database.dart';

class Stats {
  final double volumeCumule;
  final double montantCumule;
  final double distanceCumulee;
  final int count;

  const Stats({
    @required this.volumeCumule,
    @required this.montantCumule,
    @required this.distanceCumulee,
    @required this.count,
  });

  const Stats.vide()
      : count = 0,
        distanceCumulee = 0,
        montantCumule = 0,
        volumeCumule = 0;

  factory Stats.fromPlein(Plein plein) {
    return Stats(
        volumeCumule: plein.volume,
        montantCumule: plein.montant,
        distanceCumulee: plein.distance,
        count: 1);
  }

  double get consoMoyenne {
    if (0 == (distanceCumulee ?? 0)) {
      return 0.0;
    }
    return 100 * (volumeCumule ?? 0) / distanceCumulee;
  }

  Stats operator +(Stats other) {
    return Stats(
      volumeCumule: (volumeCumule ?? 0.0) + (other?.volumeCumule ?? 0.0),
      montantCumule: (montantCumule ?? 0.0) + (other?.montantCumule ?? 0.0),
      distanceCumulee:
          (distanceCumulee ?? 0.0) + (other?.distanceCumulee ?? 0.0),
      count: (count ?? 0) + (other.count ?? 0),
    );
  }

  Stats operator -(Stats other) {
    return Stats(
      volumeCumule: (volumeCumule ?? 0.0) - (other?.volumeCumule ?? 0.0),
      montantCumule: (montantCumule ?? 0.0) - (other?.montantCumule ?? 0.0),
      distanceCumulee:
          (distanceCumulee ?? 0.0) - (other?.distanceCumulee ?? 0.0),
      count: (count ?? 0) - (other.count ?? 0),
    );
  }
}
