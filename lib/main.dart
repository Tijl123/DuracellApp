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
    "syncWithTheBackEnd",
  );
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) {
    print("Native called background task"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}
