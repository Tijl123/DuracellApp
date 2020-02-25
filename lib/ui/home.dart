import 'package:device_info/device_info.dart';
import 'package:duracellapp/Database.dart';
import 'package:duracellapp/LogModel.dart';
import 'package:duracellapp/SensorModel.dart';
import 'package:duracellapp/ui/log.dart';
import 'package:duracellapp/ui/settings.dart';
import 'package:duracellapp/ui/grafiek.dart';
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

  //initialiseren navigatie-componenten
  final List<Widget> _children = [
    Log(),
    Grafiek(),
    Settings(),
  ];

  //kijkt constant na op messages van RabbitMQ
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

  // navigatie
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
              icon: Icon(Icons.timeline), title: Text("Grafiek")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Instellingen")),
        ],
      ),
    );
  }

  void onTabTapped(int index) async{
    setState(() {
      _currentIndex = index;
    });
  }
}

//kijkt na op messages van RabbitMQ
void receive (List<String> arguments, BuildContext context) async {

  // maakt connectie met RabbitMQ
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

  //vraagt sensoren op waar gebruiker op gesubscribed is en zet deze in de routing keys
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
    consumer.listen((AmqpMessage event) async {
      print(" [x] ${event.routingKey}:'${event.payloadAsString}'");
      var string = event.payloadAsString;
      var arr = string.split(";");
      print(arr);
      // toont dialoogvenster bij ontvangen van message van RabbitMQ
      showAlertDialog(context, arr[0], arr[1], arr[2]);

      // voegt log toe aan de database
      LogModel log = new LogModel(id: null, sensor: arr[0], waarde: arr[1], datum: arr[2], isConfirmed: 0);
      await DBProvider.db.insertLog(log);

      // stuurt push notificatie bij ontvangen van message van RabbitMQ
      showOngoingNotification(notifications, title: "Sensor: " + arr[0], body: "Waarde: " + arr[1], id: int.parse(arr[1]));
    });
  });
}

//toont dialoogvenster met gegevens van de RabbitMQ message
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
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}

// vraagt id van device op
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
