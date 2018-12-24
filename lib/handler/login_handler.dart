import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shannon/feed_page.dart';
import 'package:shannon/feed_page.dart';

class LoginHandler {
  var path = "users";
  // GoogleSignIn _googleSignIn = new GoogleSignIn(scopes: [
  //   'email',
  //   'https://www.googleapis.com/auth/contacts.readonly',
  // ]);

  // doLogin() async {
  //   await _googleSignIn.signIn();
  // }

  // googleLogin() {
  //   _googleSignIn.onCurrentUserChanged
  //       .listen((GoogleSignInAccount account) async {
  //     if (account != null) {
  //       // user logged
  //     } else {
  //       // user NOT logged
  //     }
  //   });
  //   _googleSignIn.signInSilently();
  // }

  Future<int> login(email, password) async {
    var value;

    final prefs = await SharedPreferences.getInstance();

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((response) async {
      prefs.setString("uid", response.uid);
      prefs.setString("email", email);
      print(response.uid);
      await Firestore.instance
          .collection(path)
          .document(response.uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          print("doc exists");
          prefs.setString("username", doc.data["username"]);
          value = 1;
        } else {
          print("doc dont exists");
          value = 0;
        }
      });
    }).catchError((e) {
      print(e.toString());
      value = -1;
    });

    return value;
  }

  Future<bool> register(email, password) async {
    bool value;
    final prefs = await SharedPreferences.getInstance();

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((response) {
      prefs.setString("uid", response.uid);
      prefs.setString("email", email);
    }).whenComplete(() {
      value = true;
    }).catchError((e) {
      value = false;
    });

    return value;
  }
}
