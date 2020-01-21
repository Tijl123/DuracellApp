import 'package:duracellapp/ui/log.dart';
import 'package:duracellapp/ui/notification.dart';
import 'package:duracellapp/ui/settings.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ometa"),
        centerTitle: true,
        backgroundColor: Colors.amberAccent.shade700,
      ),
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
