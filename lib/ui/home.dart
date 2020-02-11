import 'package:device_info/device_info.dart';
import 'package:duracellapp/Database.dart';
import 'package:duracellapp/LogModel.dart';
import 'package:duracellapp/SensorModel.dart';
import 'package:duracellapp/ui/log.dart';
import 'package:duracellapp/ui/settings.dart';
import 'package:flutter/material.dart';
import "dart:io";
import "package:dart_amqp/dart_amqp.dart";
import 'package:duracellapp/local_notification_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

final notifications = FlutterLocalNotificationsPlugin();

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Log(),
    Settings(),
  ];

  @override
  void initState() {
    _getThingsOnStartup().then((value){
      receive(new List<String>(), context);
    });
    super.initState();

    final settingsAndroid = AndroidInitializationSettings('ic_launcher');
    final settingsIOS = IOSInitializationSettings();

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS));
  }

  Future _getThingsOnStartup() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time), title: Text("Log")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Settings")),
        ],
      ),
    );
  }

  void onTabTapped(int index) async{
    setState(() {
      _currentIndex = index;
    });
  }

  void receive (List<String> arguments, BuildContext context) async {

    ConnectionSettings settings = new ConnectionSettings(
        host: "81.82.52.102",
        virtualHost: "team1vhost",
        authProvider: const PlainAuthenticator("team1", "team1")
    );

    Client client = new Client(settings: settings);

    ProcessSignal.sigint.watch().listen((_) {
      client.close().then((_) {
        print("close client");
        exit(0);
      });
    });
    List<String> routingKeys = [];
    List<SensorModel> sensoren = await DBProvider.db.getAllSensors();
    for (var i=0; i<sensoren.length; i++) {
      if(sensoren[i].isSubscribed == 1){
        routingKeys.add(sensoren[i].sensor);
      }
    }
    print(routingKeys);

    client
        .channel()
        .then((Channel channel) {
      return channel.exchange("C1direct", ExchangeType.DIRECT, durable: true);
    })
        .then((Exchange exchange) async{
      print(" [*] Waiting for messages in logs. To Exit press CTRL+C");
      return exchange.bindQueueConsumer(await _getId(context), routingKeys,
          consumerTag: "C1direct", noAck: true
      );
    })
        .then((Consumer consumer) {
      consumer.listen((AmqpMessage event) {
        print(" [x] ${event.routingKey}:'${event.payloadAsString}'");
        var string = event.payloadAsString;
        var arr = string.split(";");
        print(arr);
        showAlertDialog(context, arr[0], arr[1], arr[2]);
        LogModel log = new LogModel(id: null, sensor: arr[0], waarde: arr[1], datum: arr[2], isChecked: 0);
        DBProvider.db.insertLog(log);
        showOngoingNotification(notifications, title: "Sensor: " + arr[0], body: "Waarde: " + arr[1], id: int.parse(arr[1]));
        new Future.delayed(const Duration(seconds: 1));
      });
    });
  }

  showAlertDialog(BuildContext context, String sensor, String waarde, String datum) {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {},
          child: new AlertDialog(
            title: Text("Notificatie voor " + sensor),
            content: Text(sensor + " heeft een waarde van " + waarde),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  sent(new List<String>(), sensor, datum, waarde);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> _getId(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  void sent (List<String> arguments, String sensor, String datum, String waarde) {
    ConnectionSettings settings = new ConnectionSettings(
        host: "81.82.52.102",
        virtualHost: "team1vhost",
        authProvider: const PlainAuthenticator("team1", "team1")
    );

    Client client = new Client(settings: settings);

    String consumeTag = "C1direct";
    String msg = sensor + ";" + waarde + ";" + datum + ";confirmed";
    client
        .channel()
        .then((Channel channel) {
      return channel.queue(consumeTag, durable: true);
    })
        .then((Queue queue) {
      queue.publish(msg);
      print(" [x] Sent ${msg}");
      client.close();
    });
  }
}

