import 'package:flutter/material.dart';
import 'package:shannon/widgets/button.dart';
import 'package:shannon/handler/post_handler.dart';
import 'package:shannon/builder/snackbar_builder.dart';
import 'package:shannon/globals/strings.dart';

class PostPage extends StatefulWidget {
  @override
  createState() => _PostPage();
}

class _PostPage extends State<PostPage> {
  static final postScaffoldKey = GlobalKey<ScaffoldState>();
  static final postFormKey = GlobalKey<FormState>();

  final TextEditingController postController = TextEditingController();
  PostHandler postHandler = new PostHandler();
  var header = "post";
  var _post;

  Widget title() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
          child: Text(
        header,
        style: TextStyle(fontSize: 50.0),
      )),
    );
  }

  Widget post() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          maxLength: 140,
          controller: postController,
          validator: (val) {
            if (val.length < 10) {
              return minLength;
            }
          },
          onSaved: (val) => _post = val,
          decoration: InputDecoration(
            hintText: "time to confess.",
            contentPadding: EdgeInsets.all(10.0),
          ),
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  submit() async {
    var form = postFormKey.currentState;
    if (form.validate()) {
      form.save();
      await postHandler.submit(_post).then((response) {
        if (!response) {
          buildSnackbar(
            key: postScaffoldKey.currentState,
            color: "LIGHT",
            text: invalidLocation,
          );
        } else {
          form.reset();
          buildSnackbar(
            key: postScaffoldKey.currentState,
            color: "LIGHT",
            text: postSuccess,
          );
        }
      }).catchError((e) {
        buildSnackbar(
          key: postScaffoldKey.currentState,
          color: "LIGHT",
          text: invalidLocation,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: postScaffoldKey,
      body: Form(
        key: postFormKey,
        child: Container(
            padding: EdgeInsets.all(32.0),
            child: ListView(
              children: <Widget>[
                title(),
                post(),
                circleButton(Icon(Icons.save), 'YELLOW', submit),
              ],
            )),
      ),
    );
  }
}
