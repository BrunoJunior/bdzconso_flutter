import 'package:conso/screens/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ma conso',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.pink, foregroundColor: Colors.white),
      ),
      home: MyHomePage(title: 'Mes véhicules'),
    );
  }
}
