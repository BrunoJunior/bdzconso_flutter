import 'package:conso/blocs/bloc.dart';
import 'package:conso/blocs/vehicules_bloc.dart';
import 'package:conso/database/database.dart';

class PleinsBloc extends Bloc {
  final VehiculesBloc vehiculeBloc;

  PleinsBloc({this.vehiculeBloc});

  Stream<List<Plein>> get outListe => MyDatabase.instance.pleinsDao
      .watchAllForVehicule(vehiculeBloc.derinerVehiculeSelectionne.id);

  Stream<List<Plein>> get outListeAnneeGlissante =>
      MyDatabase.instance.pleinsDao
          .watchAnneeGlissante(vehiculeBloc.derinerVehiculeSelectionne.id);

  Stream<List<Plein>> get outListeAnneePrec {
    DateTime now = DateTime.now();
    return MyDatabase.instance.pleinsDao.watchAnneeGlissante(
      vehiculeBloc.derinerVehiculeSelectionne.id,
      dateMax: DateTime(now.year - 1, now.month, now.day),
    );
  }

  @override
  void dispose() {}
}
