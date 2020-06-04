import 'package:flutter/material.dart';
import 'package:fueltter/services/camera_service.dart';

import 'ecrans/edit_vehicule.dart';
import 'ecrans/form_plein.dart';
import 'ecrans/graphs_vehicule.dart';
import 'ecrans/home.dart';
import 'ecrans/liste_pleins.dart';
import 'ecrans/stats_vehicule.dart';
import 'ecrans/take_picture.dart';

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
      return MaterialPageRoute(builder: (context) => const Home());
    case EditVehiculeRoute:
      return MaterialPageRoute(builder: (context) => EditVehicule());
    case TakePictureRoute:
      return MaterialPageRoute(
          builder: (context) =>
              TakePictureScreen(camera: CameraService.instance.cameras.first));
    case StatsVehiculeRoute:
      return MaterialPageRoute(builder: (context) => StatsVehiculeScreen());
    case NouveauPleinRoute:
      return MaterialPageRoute(builder: (context) => FormPlein());
    case ListePleinsRoute:
      return MaterialPageRoute(builder: (context) => EcranListePleins());
    case GraphsVehiculeRoute:
      return MaterialPageRoute(builder: (context) => GraphsVehicule());
    default:
      return MaterialPageRoute(builder: (context) => const Home());
  }
}
