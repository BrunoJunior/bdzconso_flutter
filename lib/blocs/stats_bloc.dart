import 'package:conso/blocs/bloc.dart';
import 'package:conso/database/dao/pleins_dao.dart';
import 'package:conso/database/database.dart';
import 'package:flutter/material.dart';

class StatsBloc extends Bloc {
  final Vehicule vehicule;
  final Stream<Stats> outStats;

  StatsBloc({@required this.vehicule})
      : outStats = MyDatabase.instance.pleinsDao.watchStats(vehicule.id);

  @override
  void dispose() {}
}
