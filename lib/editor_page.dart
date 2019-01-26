import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shannon/globals/globals.dart';
import 'package:shannon/widgets/entities.dart';
import 'package:shannon/handler/editor_handler.dart';
import 'package:shannon/landing_page.dart';

class EditorPage extends StatefulWidget {
  @override
  createState() => _EditorPage();
}

class _EditorPage extends State<EditorPage> {
  static final editorFormKey = GlobalKey<FormState>();
  static final editorScaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  List<DropdownMenuItem<String>> flairOption;

  EditorHandler editorHandler = new EditorHandler();

  String _user;
  String currentFlair;
  String _bio;

  @override
  initState() {
    super.initState();
    flairOption = getOptions();
    currentFlair = flairOption[0].value;
  }

  submit() async {
    if (editorFormKey.currentState.validate()) {
      editorFormKey.currentState.save();
      editorHandler.submit(_user, currentFlair, _bio).then((response) {
        print(response);
        if (response) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LandingPage()));
        } else {}
      });
    }
  }

  List<DropdownMenuItem<String>> getOptions() {
    List<DropdownMenuItem<String>> items = new List();
    // for (var flair in flairs) {
    // items.add(new DropdownMenuItem(
    // value: flair,
    // child: Text(flair),
    // ));

    // }
    flairs.forEach((key, value) {
      items.add(new DropdownMenuItem(
        value: key,
        child: Text(key),
      ));
    });
    return items;
  }

  changeItems(String selected) {
    setState(() {
      currentFlair = selected;
    });
  }

  Widget username() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: TextFormField(
          keyboardType: TextInputType.text,
          autocorrect: false,
          controller: usernameController,
          validator: (val) {
            if (val.isEmpty) {
              return "username cannot be empty";
            }
            if (val.length < 6) {
              return "username must be longer than 6 characters";
            }
          },
          onSaved: (val) => _user = val,
          inputFormatters: [
            WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9!.-_]")),
          ],
          decoration: InputDecoration(
            hintText: "pick a username",
            contentPadding: EdgeInsets.all(10.0),
          ),
          style: TextStyle(
            fontSize: 30.0,
          ),
        ),
      ),
    );
  }

  Widget flair() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("equip a flair"),
          DropdownButton(
            value: currentFlair,
            items: flairOption,
            onChanged: changeItems,
          )
        ],
      ),
    );
  }

  Widget bio() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          maxLength: 140,
          autocorrect: false,
          controller: bioController,
          onSaved: (val) => _bio = val,
          decoration: InputDecoration(
            hintText: "what is your story?",
            contentPadding: EdgeInsets.all(10.0),
          ),
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: editorScaffoldKey,
      body: Form(
        key: editorFormKey,
        child: Container(
          padding: EdgeInsets.all(32.0),
          child: ListView(
            children: <Widget>[
              username(),
              flair(),
              bio(),
              circleButton(Icon(Icons.save), 'YELLOW', submit),
            ],
          ),
        ),
      ),
    );
  }
}
