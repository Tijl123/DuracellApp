import 'dart:io';

import 'package:duracellapp/local_notification_helper.dart';
import 'package:duracellapp/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

void main() {
  runApp(new MaterialApp(
    home: Home(),
  ));
  Workmanager.initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
  );
  Workmanager.registerPeriodicTask(
    "1",
    "checkWifi",
  );
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
      showOngoingNotification(notifications, title: 'Geen Wifi', body: 'Er kunnen geen notificaties ontvangen worden.');
      print('not connected');
    }
    return Future.value(true);
  });
}
