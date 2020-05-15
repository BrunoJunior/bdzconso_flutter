import 'package:conso/screens/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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
      home: MyHomePage(title: 'Mes véhicules'),
    );
  }
}
