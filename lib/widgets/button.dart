import 'package:flutter/material.dart';
import 'package:shannon/globals/globals.dart';

Widget circleButton(icon, color, action) {
  return Container(
      padding: EdgeInsets.all(10.0),
      child: FloatingActionButton(
        child: icon,
        onPressed: action,
        // foregroundColor: colors[color],
      ));
}

Widget longButton(text, color, action) {
  return Container(
    padding: EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        RaisedButton(
          onPressed: action,
          child: Text(
            text,
            style: TextStyle(color: colors['DARK']),
          ),
          color: colors[color],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        ),
      ],
    ),
  );
}
