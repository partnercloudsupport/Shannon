import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {

  Widget title() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
          child: Text(
        "settings",
        style: TextStyle(fontSize: 50.0),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: title(),
    );
  }
}
