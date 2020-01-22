import 'package:duracellapp/ui/log.dart';
import 'package:duracellapp/ui/notification.dart';
import 'package:duracellapp/ui/settings.dart';
import 'package:flutter/material.dart';
import "dart:io";
import "package:dart_amqp/dart_amqp.dart";
import 'package:duracellapp/local_notification_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


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

  List<String> routingKeys = ["sensor1", "sensor2"];
  client
      .channel()
      .then((Channel channel) {
    return channel.exchange("hello_direct", ExchangeType.DIRECT, durable: false);
  })
      .then((Exchange exchange) {
    print(" [*] Waiting for messages in logs. To Exit press CTRL+C");
    return exchange.bindPrivateQueueConsumer(routingKeys,
        consumerTag: "hello_direct", noAck: true
    );
  })
      .then((Consumer consumer) {
    consumer.listen((AmqpMessage event) {
      print(" [x] ${event.routingKey}:'${event.payloadAsString}'");
      showAlertDialog(context, event.payloadAsString);
      var string = event.payloadAsString;
      var arr = string.split(";");
      print(string);
      print(arr);
      showOngoingNotification(notifications, title: arr[0], body: arr[1], id: int.parse(arr[1]));
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
