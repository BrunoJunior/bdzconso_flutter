import 'package:conso/blocs/bloc_provider.dart';
import 'package:conso/blocs/graph_bloc.dart';
import 'package:conso/blocs/pleins_bloc.dart';
import 'package:conso/blocs/vehicules_bloc.dart';
import 'package:conso/ui/composants/card_title.dart';
import 'package:conso/ui/composants/loader.dart';
import 'package:conso/ui/composants/page_vehicule.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GraphsVehicule extends StatefulWidget {
  @override
  _GraphsVehiculeState createState() => _GraphsVehiculeState();
}

class _GraphsVehiculeState extends State<GraphsVehicule> {
  GraphBloc graphBloc;

  List<LineChartBarData> _getLines(GraphData data) {
    List<FlSpot> spotsPrec =
        data.spotsAnneePrec?.where((element) => element.isNotNull())?.toList();
    List<LineChartBarData> lines = [];
    lines
      ..add(LineChartBarData(
        spots: data.spots,
        isCurved: true,
        dotData: FlDotData(show: false),
        barWidth: 3.0,
        isStrokeCapRound: true,
        colors: data.couleurs,
      ))
      ..add(LineChartBarData(
        spots: data.moyenne,
        dotData: FlDotData(show: false),
        barWidth: 2.0,
        colors: [Colors.blueAccent],
      ));
    if (null != spotsPrec && spotsPrec.length > 0) {
      lines.add(LineChartBarData(
        spots: spotsPrec,
        isCurved: true,
        dotData: FlDotData(show: false),
        barWidth: 1.0,
        isStrokeCapRound: true,
        colors: [Colors.black],
      ));
    }
    return lines;
  }

  @override
  void dispose() {
    graphBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    graphBloc = graphBloc ??
        GraphBloc(
          pleinsBloc: PleinsBloc(
            vehiculeBloc: BlocProvider.of<VehiculesBloc>(context),
          ),
        );

    return PageVehicule(
      bodyBuilder: (context, vehicule) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            CardTitle(
              title: 'Suivi graphique sur 1 an',
              icon: FaIcon(FontAwesomeIcons.chartLine),
              titleStyle: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10.0),
            StreamBuilder<bool>(
                stream: graphBloc.outComparaison,
                builder: (context, snapshot) => SwitchListTile(
                      title: Text('Comparaison année n-1'),
                      value: snapshot.data ?? false,
                      onChanged: graphBloc.inComparer.add,
                    )),
            StreamBuilder<GraphData>(
              stream: graphBloc.outData,
              builder: (context, snapshot) {
                final data = snapshot.data;
                if (null == data) {
                  return Loader();
                }
                final diffMinMax = data.max - data.min;
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                          fitInsideVertically: true,
                          fitInsideHorizontally: true,
                        ),
                        touchCallback: (LineTouchResponse touchResponse) {},
                        handleBuiltInTouches: true,
                      ),
                      gridData: FlGridData(
                        show: false,
                      ),
                      lineBarsData: _getLines(data),
                      titlesData: FlTitlesData(
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTitles: data.getTitle,
                          textStyle: TextStyle(color: Colors.white),
                        ),
                        leftTitles: SideTitles(
                          reservedSize: 35.0,
                          showTitles: true,
                          getTitles: (value) => '${value.toStringAsFixed(1)}',
                          textStyle: TextStyle(color: Colors.white),
                          interval: (diffMinMax / 5),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          bottom: BorderSide(
                            color: Color(0xff4e4965),
                            width: 4,
                          ),
                          left: BorderSide(
                            color: Colors.transparent,
                          ),
                          right: BorderSide(
                            color: Colors.transparent,
                          ),
                          top: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      minY: (1.1 * data.min) - (0.1 * data.max),
                      maxY: (1.1 * data.max) - (0.1 * data.min),
                    ),
                  ),
                );
              },
            ),
            StreamBuilder<GraphDataType>(
                stream: graphBloc.outDataType,
                builder: (context, snapshot) {
                  return Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    children: MapLabelTypes.entries.map((entry) {
                      return ActionChip(
                        label: Text(entry.value),
                        onPressed: () =>
                            graphBloc.inDefinirTypeGraph.add(entry.key),
                        backgroundColor: entry.key == snapshot.data
                            ? Colors.green
                            : Colors.black54,
                        labelStyle: TextStyle(color: Colors.white),
                      );
                    }).toList(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
