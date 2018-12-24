import 'package:flutter/material.dart';
import 'package:shannon/globals/globals.dart';

class ScaffoldBuilder {
  void buildScaffold(key, text, color, duration, textColor) {
    key.showSnackBar(SnackBar(
      backgroundColor: colors[color],
      duration: new Duration(seconds: duration),
      content: Text(
        text,
        style: new TextStyle(
          color: textColor ? colors['LIGHT'] : colors['DARK'],
        ),
      ),
    ));
  }
}
