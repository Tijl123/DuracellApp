import 'dart:io';

import 'package:duracellapp/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

void main() {
  runApp(new MaterialApp(
    home: Home(),
  ));
  Workmanager.initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
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
      print('not connected');
    }
    return Future.value(true);
  });
}
