import 'package:duracellapp/ui/home.dart';
import 'package:flutter/material.dart';

final ThemeData _appTheme = _buildAppTheme();

ThemeData _buildAppTheme() {
  final ThemeData base = ThemeData.dark();

  return base.copyWith(
      brightness: Brightness.dark,
      accentColor: Colors.amber,
      primaryColor: Colors.grey[800],
      scaffoldBackgroundColor: Colors.red,
      backgroundColor: Colors.amber,
      textTheme: _appTextTheme(base.textTheme));
}

TextTheme _appTextTheme(TextTheme base) {
  return base
      .copyWith(
      headline: base.headline.copyWith(
        fontWeight: FontWeight.w500,
      ),
      title:
      base.title.copyWith(fontSize: 18.0, fontStyle: FontStyle.italic),
      caption: base.caption
          .copyWith(fontWeight: FontWeight.w400, fontSize: 14.0),
      button: base.button.copyWith(
        //fontSize: 23.9,

      ),
      body1: base.body1.copyWith(
        fontSize: 16.9,
        fontFamily: "Lobster",
        color: Colors.white,
      ))
      .apply(
    fontFamily: "Lobster",
    displayColor: Colors.amber,
    //bodyColor: Colors.red
  );
}

void main() => runApp(new MaterialApp(
  home: Home(),
));
