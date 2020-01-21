import 'package:duracellapp/ui/home.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ometa"),
        centerTitle: true,
        backgroundColor: Colors.amberAccent.shade700,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time), title: Text("Log")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Settings")),
        ],
        onTap: (int index) {
          switch(index) {
            case 0: {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
            }
            break;

            case 1: {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
            }
            break;

            default: {
            //statements;
            }
            break;
          }
        },
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomButton()
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () {
      final snackBar = SnackBar(
        content: Text("Settings"),
        backgroundColor: Colors.amberAccent.shade700,
      );

      Scaffold.of(context).showSnackBar(snackBar);
    },
    child: Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.pinkAccent, borderRadius: BorderRadius.circular(8.0)),
      child: Text("Button"),
    ),
  );
}
}
