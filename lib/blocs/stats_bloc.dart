import 'package:fueltter/blocs/bloc.dart';
import 'package:fueltter/database/database.dart';
import 'package:fueltter/models/stats.dart';
import 'package:flutter/material.dart';

class StatsBloc extends Bloc {
  final Vehicule vehicule;
  final Stream<Stats> outStats;

  StatsBloc({@required this.vehicule})
      : outStats = MyDatabase.instance.pleinsDao.watchStats(vehicule.id);

  @override
  void dispose() {}
}
