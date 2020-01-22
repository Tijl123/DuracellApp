import 'package:duracellapp/ui/log.dart';
import 'package:duracellapp/ui/notification.dart';
import 'package:duracellapp/ui/settings.dart';
import 'package:flutter/material.dart';
import "dart:io";
import "package:dart_amqp/dart_amqp.dart";
import 'package:duracellapp/local_notification_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


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
    LocalNotificationWidget(),
  ];

  @override
  void initState() {
    _getThingsOnStartup().then((value){
      receive(new List<String>(), context);
    });
    super.initState();
  }

  Future _getThingsOnStartup() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ometa"),
        centerTitle: true,
        backgroundColor: Colors.amberAccent.shade700,
      ),
      backgroundColor: Colors.amberAccent.shade200,
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time), title: Text("Log")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Settings")),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_location), title: Text("LocalNotificationWidget")),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

void receive (List<String> arguments, BuildContext context) {
  final notifications = FlutterLocalNotificationsPlugin();
  
  ConnectionSettings settings = new ConnectionSettings(
      host: "10.148.22.219"
  );

  Client client = new Client(settings: settings);

  ProcessSignal.sigint.watch().listen((_) {
    client.close().then((_) {
      print("close client");
      exit(0);
    });
  });

  String msg = arguments.isEmpty ? "Hello World!": arguments[0];

  String queueTag = "hello";

  client
      .channel()
      .then((Channel channel) => channel.queue(queueTag, durable: false))
      .then((Queue queue) {
    print(" [*] Waiting for messages in ${queueTag}. To Exit press CTRL+C");
    return queue.consume(consumerTag: queueTag, noAck: true);
  })
      .then((Consumer consumer) {
    consumer.listen((AmqpMessage event) {
      print(" [x] Received ${event.payloadAsString}");
      showAlertDialog(context, event.payloadAsString);
      showOngoingNotification(notifications, title: event.payloadAsString, body: event.payloadAsString);
      addToLocalStorage(event.payloadAsString);
    });
  });
}

showAlertDialog(BuildContext context, String waardes) {

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Notificatie"),
        content: Text("De sensor heeft waarde " + waardes),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

final Future<Database> database = openDatabase(
    // Set the path to the database.
    join(await getDatabasesPath(), 'log_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
      "CREATE TABLE logs(id INTEGER PRIMARY KEY, sensor TEXT, waarde TEXT, datum TEXT)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
);

Future<Null> addToLocalStorage(String waarde) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> waardes = prefs.getStringList('sensorwaardes');
  waardes.add(waarde);
  prefs.setStringList('sensorwaardes', waardes);
}
