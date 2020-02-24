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
  int chartIndex = 0;
  String dropdownValue = 'One';

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
            Map<DateTime, double> line1 = {};
            Map<DateTime, double> line2 = {};
            Map<DateTime, double> line3 = {};
            Map<DateTime, double> line4 = {};
            snapshot.data.forEach((log) {
              var dateTime =
                  new DateFormat("dd/MM/yyyy HH:mm:ss").parse(log.datum);

              //data sensoren indelen naar de juiste grafieken
              switch (log.sensor) {
                case "sensor1":
                  {
                    line1[dateTime] = double.parse(log.waarde);
                  }
                  break;
                case "sensor2":
                  {
                    line2[dateTime] = double.parse(log.waarde);
                  }
                  break;
                case "sensor3":
                  {
                    line3[dateTime] = double.parse(log.waarde);
                  }
                  break;
                case "sensor4":
                  {
                    line4[dateTime] = double.parse(log.waarde);
                  }
                  break;
              }
            });

            //Nakijken of de grafiek leeg is
            if (line1.isEmpty) {
              line1[DateTime.now()] = 0.0;
            }
            if (line2.isEmpty) {
              line2[DateTime.now()] = 0.0;
            }
            if (line3.isEmpty) {
              line3[DateTime.now()] = 0.0;
            }
            if (line4.isEmpty) {
              line4[DateTime.now()] = 0.0;
            }

            LineChart chart;

            //Juiste grafiek tonen
            if (chartIndex == 0) {
              chart = LineChart.fromDateTimeMaps(
                  [line1], [Colors.red.shade900], ['']);
            } else if (chartIndex == 1) {
              chart = LineChart.fromDateTimeMaps(
                  [line2], [Colors.green.shade900], ['']);
            } else if (chartIndex == 2) {
              chart = LineChart.fromDateTimeMaps(
                  [line3], [Colors.yellow.shade900], ['']);
            } else {
              chart = LineChart.fromDateTimeMaps(
                  [line4], [Colors.blue.shade900], ['']);
            }
            return Container(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black45),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                            child: Text(
                              'Sensor 1',
                              style: TextStyle(
                                  color: chartIndex == 0
                                      ? Colors.black
                                      : Colors.black12),
                            ),
                            onPressed: () {
                              setState(() {
                                chartIndex = 0;
                              });
                            },
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black45),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                            child: Text('Sensor 2',
                                style: TextStyle(
                                    color: chartIndex == 1
                                        ? Colors.black
                                        : Colors.black12)),
                            onPressed: () {
                              setState(() {
                                chartIndex = 1;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black45),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                            child: Text('Sensor 3',
                                style: TextStyle(
                                    color: chartIndex == 2
                                        ? Colors.black
                                        : Colors.black12)),
                            onPressed: () {
                              setState(() {
                                chartIndex = 2;
                              });
                            },
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black45),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                            child: Text('Sensor 4',
                                style: TextStyle(
                                    color: chartIndex == 3
                                        ? Colors.black
                                        : Colors.black12)),
                            onPressed: () {
                              setState(() {
                                chartIndex = 3;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
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