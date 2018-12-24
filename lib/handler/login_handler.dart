import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class LoginHandler {
  //Helper method to append mock email to pass Firebase Authentication requirements.
  String appendEmail(value) {
    return value + "@ruby.com";
  }

  GoogleSignIn _googleSignIn = new GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  doLogin() async {
    await _googleSignIn.signIn();
  }

  googleLogin() {
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      if (account != null) {
        // user logged
      } else {
        // user NOT logged
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<bool> login(username, password) async {
    bool value;
    var email = appendEmail(username); //Mock email.
    final prefs = await SharedPreferences.getInstance();

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((response) {
      prefs.setString("uid", response.uid);
      prefs.setString("username", username);
    }).whenComplete(() {
      value = true;
    }).catchError((e) {
      value = false;
    });

    return value;
  }

  Future<bool> register(username, password) async {
    bool value;
    var email = appendEmail(username); //Mock email.
    final prefs = await SharedPreferences.getInstance();

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((response) {
      prefs.setString("uid", response.uid);
      prefs.setString("username", username);
    }).whenComplete(() {
      value = true;
    }).catchError((e) {
      value = false;
    });

    return value;
  }
}
