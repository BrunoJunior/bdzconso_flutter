import 'package:conso/services/camera_service.dart';
import 'package:conso/ui/ecrans/edit_vehicule.dart';
import 'package:conso/ui/ecrans/form_plein.dart';
import 'package:conso/ui/ecrans/graphs_vehicule.dart';
import 'package:conso/ui/ecrans/home.dart';
import 'package:conso/ui/ecrans/liste_pleins.dart';
import 'package:conso/ui/ecrans/stats_vehicule.dart';
import 'package:conso/ui/ecrans/take_picture.dart';
import 'package:flutter/material.dart';

const String HomeRoute = '/';
const String EditVehiculeRoute = 'edit-vehicule';
const String TakePictureRoute = 'take-picture';
const String StatsVehiculeRoute = 'stats-vehicule';
const String NouveauPleinRoute = 'nouveau-plein';
const String ListePleinsRoute = 'liste-pleins';
const String GraphsVehiculeRoute = 'graphs-vehicule';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeRoute:
      return MaterialPageRoute(builder: (context) => Home('Mes véhicules'));
    case EditVehiculeRoute:
      var vehicule = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => EditVehicule(vehicule: vehicule));
    case TakePictureRoute:
      return MaterialPageRoute(
          builder: (context) =>
              TakePictureScreen(camera: CameraService.instance.cameras.first));
    case StatsVehiculeRoute:
      return MaterialPageRoute(builder: (context) => StatsVehiculeScreen());
    case NouveauPleinRoute:
      return MaterialPageRoute(builder: (context) => FormPlein());
    case ListePleinsRoute:
      return MaterialPageRoute(builder: (context) => ListePleins());
    case GraphsVehiculeRoute:
      return MaterialPageRoute(builder: (context) => GraphsVehicule());
    default:
      return MaterialPageRoute(builder: (context) => Home('Mes véhicules'));
  }
}
