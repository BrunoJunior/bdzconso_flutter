import 'package:conso/screens/edit_vehicule.dart';
import 'package:conso/screens/home.dart';
import 'package:conso/screens/take_picture.dart';
import 'package:conso/services/camera_service.dart';
import 'package:flutter/material.dart';

// TODO - Étape 1 : Créer un écran de saisie d'un plein (simple formulaire)
// TODO - Étape 2 : Naviguer sur l'écran (accès à définir)
// TODO - Étape 3 : Calculer la distance et la conso moyenne du véhicule
// TODO - Étape 4 : Créer un écran affichant les stats du véhicule (accès ? à déterminer)
// TODO - Étape ultime : utiliser la caméra pour remplir automatiquement les valeurs d'un plein (ML de Google Firebase ?)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CameraService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ma conso',
      theme: ThemeData.dark().copyWith(
        backgroundColor: Color(0xFF212121),
        accentColor: Color(0xFFbbe1fa),
        primaryColor: Color(0xFF0f4c75),
        buttonColor: Color(0xFF3282b8),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color(0xFFbbe1fa),
            foregroundColor: Color(0xFF1b262c)),
      ),
      initialRoute: Home.id,
      routes: {
        Home.id: (context) => Home('Mes véhicules'),
        EditVehicule.id: (context) => EditVehicule(),
        TakePictureScreen.id: (context) =>
            TakePictureScreen(camera: CameraService.instance.cameras.first)
      },
    );
  }
}
