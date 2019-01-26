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

Widget postBox({content, username, time, flair, color, action}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10.0),
    child: ListTile(
      title: Text(
        content,
        maxLines: null,
      ),
      subtitle: Text(username),
      trailing: Text(time.toString()),
      onTap: action,
    ),
    decoration: BoxDecoration(
        border: Border(
      top: BorderSide(width: 2.0, color: color),
    )),
  );
}

Widget contentBox({content, username, color}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      Container(
        margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 7.0),
        padding: EdgeInsets.all(12.0),
        child: Text(
          content,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 14.0,
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 8.0),
        child: Text(
          username,
          textAlign: TextAlign.right,
        ),
      ),
    ],
  );
}
