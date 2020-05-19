import 'package:conso/components/vehicule_bloc.dart';
import 'package:conso/database.dart';
import 'package:conso/main.dart';
import 'package:conso/screens/add_vehicule.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  static final String id = 'home';

  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: database.watchAllVehicules(),
        builder: (context, AsyncSnapshot<List<Vehicule>> snapshot) => ListView(
          children: snapshot.data
                  ?.map((vehicule) => VehiculeBloc(vehicule))
                  ?.toList() ??
              [],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddVehicule.id);
        },
        tooltip: 'Ajouter un véhicule',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
