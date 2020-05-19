import 'package:conso/database.dart';
import 'package:conso/screens/add_vehicule.dart';
import 'package:conso/screens/home.dart';
import 'package:flutter/material.dart';

MyDatabase database;

void main() {
  database = MyDatabase();
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
      initialRoute: MyHomePage.id,
      routes: {
        MyHomePage.id: (context) => MyHomePage(title: 'Mes véhicules'),
        AddVehicule.id: (context) => AddVehicule()
      },
    );
  }
}
