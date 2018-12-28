import 'package:flutter/material.dart';
import 'package:shannon/globals/globals.dart';

buildSnackbar({key, text, color, duration: 4}) {
  key.showSnackBar(SnackBar(
    backgroundColor: colors[color],
    duration: new Duration(seconds: duration),
    content: Text(
      text,
      style: new TextStyle(
        color: colors['DARK'],
      ),
    ),
  ));
}
