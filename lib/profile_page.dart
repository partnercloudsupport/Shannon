import 'package:flutter/material.dart';
import 'package:shannon/globals/globals.dart';
import 'package:shannon/widgets/entities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shannon/globals/strings.dart';

class ProfilePage extends StatefulWidget {
  @override
  createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  // var username;
  // var flair;
  // var bio;
  // var likes;

  @override
  initState() {
    super.initState();
    // setUsername();
  }

  Widget title() {
    var title = 'carrein';
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
          child: Text(
        title,
        style: TextStyle(fontSize: 50.0),
      )),
    );
  }

  Widget flair() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Computing",
            style: TextStyle(
              fontSize: 14.0,
              color: colors["LIGHT"],
            ),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: colors["YELLOW"]),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
        ),
      ),
    );
  }

  // Widget bio() {
  //   // return Container(
  //   //   margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
  //   //   padding: EdgeInsets.all(20.0),
  //   //   child: Center(
  //   //     child: Text(
  //   //       "See, what I want so much should never hurt this bad. Never did this before, that's what the virgin says. We've been generally warned, that's what the surgeon says. God, talk to me now, this is an emergency.",
  //   //       textAlign: TextAlign.left,
  //   //       style: TextStyle(
  //   //         fontSize: 18.0,
  //   //         height: 1.5,
  //   //       ),
  //   //     ),
  //   //   ),
  //   //   decoration: BoxDecoration(
  //   //     border: Border.all(color: colors["YELLOW"]),
  //   //     borderRadius: BorderRadius.all(Radius.circular(4.0)),
  //   //   ),
  //   // );
  // }

  Widget likes() {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.thumb_up)),
                  Container(padding: EdgeInsets.all(10.0), child: Text("12")),
                ],
              ),
            ),
            // Expanded(
            //   child: longButton(
            //     text: "DM",
            //     color: "YELLOW",
            //     action: () => null,
            //   ),
            // )
          ],
        ));
  }

  Profile buildProfile(AsyncSnapshot snapshot) {
    // return Profile(
    //TODO
    // );
  }

  Widget compiled() {
    return Container(
      padding: EdgeInsets.all(32.0),
      child: ListView(
        children: <Widget>[
          title(),
          flair(),
          // bio(),
          // contentBox(content: "Chopin", color: "YELLOW"),
          likes(),
          circleButton(Icon(Icons.arrow_back), 'YELLOW', () => null),
        ],
      ),
    );
  }

  // setProfile() async {
  //   await SharedPreferences.getInstance().then((prefs) async {
  //     await Firestore.instance
  //         .collection(userPath)
  //         .document(prefs.getString("uid"))
  //         .get()
  //         .then((snapshot) {


  //         });
  //   });
    // SharedPreferences.getInstance().then((prefs) {
    //   setState(() {
    //     username =
    //         prefs.get('username') != null ? prefs.get('username') : 'Guest';
    //   });
    // });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        // stream: query,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("An error occured."),
            );
          }

          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Text("No results."),
            );
          }

          if (snapshot.hasData) {
            // compiled(buildProfile(snapshot));
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class Profile {
  var username;
  var flair;
  var bio;
  var likes;

  Profile(this.flair, this.username, this.bio, this.likes);
}
