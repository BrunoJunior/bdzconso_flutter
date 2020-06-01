import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fueltter/blocs/bloc_provider.dart';
import 'package:fueltter/blocs/graph_bloc.dart';
import 'package:fueltter/models/graph_data.dart';
import 'package:fueltter/ui/composants/loader.dart';

class VehiculeGraph extends StatelessWidget {
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
  Widget build(BuildContext context) {
    GraphBloc graphBloc = BlocProvider.of<GraphBloc>(context);
    return StreamBuilder<GraphData>(
      stream: graphBloc.outData,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (null == data) {
          return Loader();
        }
        final min = data.min;
        final max = data.max;
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
                  interval: min == max ? 1 : ((max - min) / 5),
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
              minY: min == max ? min - 1 : ((1.1 * min) - (0.1 * max)),
              maxY: min == max ? min + 1 : ((1.1 * max) - (0.1 * min)),
            ),
          ),
        );
      },
    );
  }
}
