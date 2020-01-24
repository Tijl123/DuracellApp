import 'dart:io';

import 'package:duracellapp/local_notification_helper.dart';
import 'package:duracellapp/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:workmanager/workmanager.dart';



void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
  Workmanager.initialize(
      callbackDispatcher,// If enabled it will post a notification whenever the task is running. Handy for debugging tasks
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

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 6,
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
        photoSize: 100.0,
        onClick: ()=>print("Flutter Egypt"),
        loaderColor: Colors.white
    );
  }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Home(

    );
  }
}


void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      final notifications = FlutterLocalNotificationsPlugin();
      showOngoingNotification(notifications, title: 'Geen internet connectie', body: 'Er kunnen geen notificaties ontvangen worden.');
      print('not connected');
    }
    return Future.value(true);
  });
}
