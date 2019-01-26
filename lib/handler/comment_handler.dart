import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shannon/globals/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentHandler {
  Future<bool> submit(String content, String id) async {
    bool value;

    final prefs = await SharedPreferences.getInstance();

    var data = {
      "content": content,
      "username": prefs.getString("username"),
    };

    await Firestore.instance
        .collection(postPath)
        .document(id)
        .collection(commentPath)
        .document()
        .setData(data)
        .whenComplete(() {
      value = true;
    }).catchError((e) {
      print(e.toString());
      value = false;
    });

    return value;
  }
}
