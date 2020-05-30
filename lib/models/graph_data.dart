import 'package:conso/database/database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  Iterable<FlSpot> get _allSpots =>
      [...spots, ...spotsAnneePrec].where((spot) => null != spot.y);

  double get min {
    final all = _allSpots;
    return all.isEmpty
        ? 0.0
        : all.reduce((spot1, spot2) => spot1.y < spot2.y ? spot1 : spot2).y;
  }

  double get max {
    final all = _allSpots;
    return all.isEmpty
        ? 1.0
        : all.reduce((spot1, spot2) => spot1.y > spot2.y ? spot1 : spot2).y;
  }
}
