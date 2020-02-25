import 'package:duracellapp/Database.dart';
import 'package:duracellapp/LogModel.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Histogram extends StatefulWidget {
  Histogram({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Histogram createState() => _Histogram();
}

class _Histogram extends State<Histogram> {
  int b1 = 0;
  int b2 = 0;
  int b3 = 0;
  int b4 = 0;

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
        builder:
            (BuildContext context, AsyncSnapshot<List<LogModel>> snapshot) {
          if (snapshot.hasData) {
            snapshot.data.forEach((log) {
              //data sensoren indelen naar de juiste grafieken
              switch (log.sensor) {
                case "Lichtsensor":
                  {
                    b1 = b1 + 1;
                  }
                  break;
                case "Bewegingssensor":
                  {
                    b2 = b2 + 1;
                  }
                  break;
                case "Vlammensensor":
                  {
                    b3 = b3 + 1;
                  }
                  break;
                case "Geluidssensor":
                  {
                    b4 = b4 + 1;
                  }
                  break;
              }
            });

            var data = [
              ClicksPerYear('Sensor1', b1, Colors.blue.shade300),
              ClicksPerYear('Sensor2', b2, Colors.blue.shade500),
              ClicksPerYear('Sensor3', b3, Colors.blue.shade700),
              ClicksPerYear('Sensor4', b4, Colors.blue.shade900),
            ];

            var series = [
              charts.Series(
                domainFn: (ClicksPerYear clickData, _) => clickData.year,
                measureFn: (ClicksPerYear clickData, _) => clickData.clicks,
                colorFn: (ClicksPerYear clickData, _) => clickData.color,
                id: 'Clicks',
                data: data,
              ),
            ];

            var barChart = charts.BarChart(
              series,
              animate: true,
            );


            var chartWidget = Padding(
              padding: EdgeInsets.all(32.0),
              child: SizedBox(
                height: 200.0,
                child: barChart,
              ),
            );

            return Container(
              child: Column(
                children: <Widget>[
                  chartWidget,
              ],
            ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}