import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _State createState() => new _State();

}

class _State extends State<Settings> {

  @override
  void initState() {
    super.initState();
  }

  bool _value1 = false;
  bool _value2 = false;

  void _onChanged1(bool value){
    setState(() {
      _value1 = value;
    });

  }

  void _onChanged2(bool value){
    setState(() {
      _value2 = value;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(32.0),
      child: new Column(
        children: <Widget>[
          new SwitchListTile(
              title: new Text("sensor1"),
              activeColor: Colors.red,
              secondary: const Icon(Icons.adb),
              value: _value1,
              onChanged: (bool value){_onChanged1(value);}),
          new SwitchListTile(
            title: new Text("sensor2"),
              activeColor: Colors.red,
              secondary: const Icon(Icons.adb),
              value: _value2,
              onChanged: (bool value){_onChanged2(value);}),
          new SwitchListTile(
              title: new Text("sensor3"),
              activeColor: Colors.red,
              secondary: const Icon(Icons.adb),
              value: _value2,
              onChanged: (bool value){_onChanged2(value);})
        ],
      ),
    );
  }
}