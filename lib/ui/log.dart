import 'package:flutter/material.dart';

class Log extends StatefulWidget {
  @override
  _Log createState() => _Log();
}

class _Log extends State<Log> {

  List<String> waardes = [];
  @override
  void initState() {
    super.initState();
    vulLijst();
  }

  void vulLijst() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> _testwaardes = [
      "12",
      "25",
      "50"
    ];
    final List<String> _waardes = prefs.getStringList('sensorwaardes');
    _waardes.split(";");

    if (_waardes != null) {
      setState(() {
        waardes = _waardes;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: waardes.length,
        itemBuilder: (BuildContext context, int index) {
      return Card(
        color: Colors.white,
        child: ListTile(
          title: Text("test"),
          subtitle: Text(waardes.elementAt(index)),
          trailing: Text("22/01/2020"),
        ),
      );
    });
  }
}
