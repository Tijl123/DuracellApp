import 'package:duracellapp/Database.dart';
import 'package:duracellapp/LogModel.dart';
import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Grafiek extends StatefulWidget {
  Grafiek({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Grafiek createState() => _Grafiek();
}

class _Grafiek extends State<Grafiek> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grafiek"),
        centerTitle: true,
        backgroundColor: Colors.brown.shade600,
      ),
      body: FutureBuilder<List<LogModel>>(
        future: DBProvider.db.getAllLogs(),
        builder: (BuildContext context, AsyncSnapshot<List<LogModel>> snapshot) {
          if (snapshot.hasData) {
            Map<DateTime, double> line1 = {};
            snapshot.data.forEach((log) {
              var dateTime = new DateFormat("dd/MM/yyyy HH:mm:ss").parse(log.datum);
              line1[dateTime] = double.parse(log.waarde);
            });
            LineChart chart = LineChart.fromDateTimeMaps([line1], [Colors.red.shade900], ['']);
            return Container(
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
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
