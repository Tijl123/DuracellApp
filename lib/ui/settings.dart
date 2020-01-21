import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Show alert'),
              onPressed: () {
                showAlertDialog(context);
              },
            ),
          ],
        ),
    );
  }
}

showAlertDialog(BuildContext context) {

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Notificatie"),
        content: Text("Sensor overflow"),
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
