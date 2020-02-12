import 'package:fl_animated_linechart/chart/area_line_chart.dart';
import 'package:fl_animated_linechart/common/pair.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:flutter/material.dart';

class Grafiek extends StatefulWidget {
  Grafiek({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Grafiek createState() => _Grafiek();
}

class _Grafiek extends State<Grafiek> {
  int chartIndex = 0;

  @override
  Widget build(BuildContext context) {
    Map<DateTime, double> line1 = createLine1();

    LineChart chart;

    chart = LineChart.fromDateTimeMaps([line1], [Colors.red.shade900], ['']);

    return Scaffold(
      appBar: AppBar(
        title: Text("Grafiek"),
        centerTitle: true,
        backgroundColor: Colors.brown.shade600,
      ),
      body: Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedLineChart(
                      chart,
                      key: UniqueKey(),
                    ), //Unique key to force animations
                  )),
              SizedBox(width: 200, height: 50, child: Text('')),
            ]),
      ),
    );
  }
}
