import 'dart:io';

import 'package:duracellapp/local_notification_helper.dart';
import 'package:duracellapp/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:workmanager/workmanager.dart';

BuildContext _context;

//initialiseren applicatie
void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
  Workmanager.initialize(
      callbackDispatcher,
  );
  Workmanager.registerPeriodicTask(
    "1",
    "checkWifi",
  );
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

//toont splashscreen bij opstarten app
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 3,
        navigateAfterSeconds: new AfterSplash(),
        title: new Text('Welkom!',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35.0,
              color: Colors.white
          ),),
        image: new Image.asset('assets/images/splash.png'),
        backgroundColor: Colors.black,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 70.0,
        loaderColor: Colors.white
    );
  }
}

// toont home screen na splashscreen
class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _context = context;
    return new Home();
  }
}

// achtergrondproces
void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    //kijkt na op internetconnectie
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //kijkt na op messages van RabbitMQ
        receive(new List<String>(), _context);
        print('connected');
      }
    } on SocketException catch (_) {
      //stuurt notificatie dat er geen internet connectie is
      final notifications = FlutterLocalNotificationsPlugin();
      showOngoingNotification(notifications, title: 'Geen internet connectie', body: 'Er kunnen geen notificaties ontvangen worden.');
      print('not connected');
    }
    return Future.value(true);
  });
}
