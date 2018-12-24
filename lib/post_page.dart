import 'package:flutter/material.dart';
import 'package:shannon/widgets/button.dart';
import 'package:shannon/handler/post_handler.dart';

class PostPage extends StatefulWidget {
  @override
  createState() => _PostPage();
}

class _PostPage extends State<PostPage> {
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
          autocorrect: false,
          controller: postController,
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

  submit() {
    postHandler.submit("text");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(32.0),
          child: ListView(
            children: <Widget>[
              title(),
              post(),
              circleButton(Icon(Icons.save), 'YELLOW', submit),
            ],
          )),
    );
  }
}
