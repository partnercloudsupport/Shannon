import 'package:flutter/material.dart';
import 'package:shannon/globals/globals.dart';

// class Button {
Widget circleButton(icon, color, action){
  return Container(
    padding: EdgeInsets.all(10.0),
    child: FloatingActionButton(
      child: icon,
      onPressed: action,
      // foregroundColor: colors[color],
    )
  );
}


// Widget regularButton(text, color, action, textColor) {
//   return Container(
//     padding: EdgeInsets.all(10.0),
//     child: RaisedButton(
//       onPressed: action,
//       child: Text(
//         text,
//         style: TextStyle(color: textColor ? colors['LIGHT'] : colors['DARK']),
//       ),
//       color: colors[color],
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
//     ),
//   );
// }

Widget longButton(text, color, action, textColor) {
  return Container(
    padding: EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        RaisedButton(
          onPressed: action,
          child: Text(
            text,
            style:
                TextStyle(color: textColor ? colors['LIGHT'] : colors['DARK']),
          ),
          color: colors[color],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        ),
      ],
    ),
  );
}
// }
