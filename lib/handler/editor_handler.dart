import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class EditorHandler {
  var path = "users";

  Future<bool> submit(user, flair, bio) async {
    var value = false;

    final prefs = await SharedPreferences.getInstance();

    var data = {
      "user": user,
      "flair": flair,
      "bio": bio,
      "likes": 0,
    };

    await Firestore.instance
        .collection(path)
        .document(prefs.getString("uid"))
        .setData(data)
        .whenComplete(() {
      prefs.setString("user", user);
      prefs.setString("flair", flair);
      value = true;
    }).catchError((e) {
      value = false;
    });
    return value;
  }
}
