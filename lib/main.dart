import 'package:camera/camera.dart';
import 'package:conso/database/database.dart';
import 'package:conso/screens/edit_vehicule.dart';
import 'package:conso/screens/home.dart';
import 'package:conso/screens/take_picture.dart';
import 'package:flutter/material.dart';

MyDatabase database;
List<CameraDescription> cameras;

void main() async {
  database = MyDatabase();
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
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
            TakePictureScreen(camera: cameras.first)
      },
    );
  }
}
