import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shannon/setting_page.dart';
import 'package:shannon/globals/globals.dart';
import 'package:shannon/globals/strings.dart';
import 'package:shannon/login_page.dart';
import 'package:shannon/comment_page.dart';
import 'package:shannon/widgets/post.dart';
import 'package:shannon/profile_page.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shannon/builder/snackbar_builder.dart';
import 'package:android_intent/android_intent.dart';
import 'package:geolocator/geolocator.dart';

class FeedPage extends StatefulWidget {
  @override
  createState() => _FeedPage();
}

class _FeedPage extends State<FeedPage>
    with AutomaticKeepAliveClientMixin<FeedPage> {
  static final feedScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  bool get wantKeepAlive => true;

  static Position position;
  static List<Post> postList = [];
  static int entries = 20;

  List<Widget> drawerList;
  String username = "Guest";
  static Geolocator geoLocator = Geolocator();
  Post post;
  var pageLoadController;

  @override
  initState() {
    super.initState();

    pageLoadController = PagewiseLoadController(
        pageSize: entries,
        pageFuture: (index) {
          return fetchFeed(index);
        });

    setUsername();

    drawerList = [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
      ),
      ListTile(
          title: Text('Profile'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          }),
      ListTile(title: Text('Chats'), onTap: () => null),
      ListTile(
          title: Text('Settings'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingPage()));
          }),
      ListTile(title: Text('Log Out'), onTap: logout),
    ];
  }

  @override
  dispose() {
    pageLoadController.dispose();
    super.dispose();
  }

  displayDialog() {
    showDialog(
        context: context,

        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(locationDisabled),
            actions: <Widget>[
              RaisedButton(
                child: Text("Try again"),
                onPressed: ((){
                  Navigator.pop(context);
                  reset();
                }),
              ),
              RaisedButton(
                child: Text("Settings"),
                onPressed: (() {
                  Navigator.pop(context);
                  final AndroidIntent intent = new AndroidIntent(
                    action: 'android.settings.LOCATION_SOURCE_SETTINGS',
                  );
                  intent.launch();
                }),
              ),
            ],
          );
        });
  }

  Future<Position> updateLocation() async {
    var status = await geoLocator.checkGeolocationPermissionStatus();
    if (status == GeolocationStatus.disabled ||
        status == GeolocationStatus.denied) {
      displayDialog();
      position = await geoLocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } else if (status == GeolocationStatus.restricted ||
        status == GeolocationStatus.unknown) {
      buildSnackbar(
        key: feedScaffoldKey.currentState,
        color: "RED",
        text: invalidLocation,
      );
    } else if (status == GeolocationStatus.granted) {
      position = await geoLocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    }
    return position;
  }

  Future<List<Post>> fetchFeed(index) async {
    postList.clear();
    await updateLocation().then((response) async {
      if (response.latitude.isNaN) {
        buildSnackbar(
          key: feedScaffoldKey.currentState,
          color: "RED",
          text: invalidLocation,
        );
      } else {
        await http
            .get(
                "https://us-central1-shannon-26719.cloudfunctions.net/feed?lat=" +
                    response.latitude.toString() +
                    "&long=" +
                    response.longitude.toString() +
                    "&page=" +
                    index.toString() +
                    "&entries=" +
                    entries.toString() +
                    "&dist=" +
                    distance.toString())
            .then((response) {
          if (response.statusCode == 200) {
            String text = response.body;
            if (text.isEmpty) {
              return postList;
            } else {
              postList = PostList.fromJson(json.decode(response.body)).posts;
            }
          } else {
            print("Invalid status code");
          }
        }).catchError((e) {
          print(e.toString());
        });
      }
    });
    return postList;
  }

  Widget displayTile(context, content, username, post) {
    return ListTile(
      title: Text(content),
      subtitle: Text(username),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CommentPage(
                    post: post,
                  ))),
    );
  }

  logout() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("username", "");
      prefs.setString("flair", "");
      prefs.clear();
    });
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }

  setUsername() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        username =
            prefs.get('username') != null ? prefs.get('username') : 'Guest';
      });
    });
  }

  reset() async {
    await pageLoadController.reset();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MyCustomScaffold(
      key: feedScaffoldKey,
      appBar: AppBar(
        title: Text(username),
      ),
      endDrawer: SizedBox(
        width: 150.0,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: drawerList,
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: Slider(
              divisions: 14,
              min: 1.0,
              max: 15.0,
              onChanged: ((response) {
                setState(() {
                  if (distance != response) {
                    distance = response;
                  }
                });
              }),
              onChangeEnd: ((response) {
                // updateLocation();
                reset();
              }),
              value: distance,
              label: distance.round().toString(),
            ),
          ),
        ],
      ),
      body: PagewiseListView(
        pageLoadController: pageLoadController,
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, entry, index) {
          // return displayTile(context, entry.content, entry.username, entry);
          post = entry;
          return post.tile(context);
        },
      ),
    );
  }
}

// var options = ['A-Z', 'Z-A', 'Lowest Price First', 'Highest Price First'];

// class _FeedPage extends State<FeedPage> with TickerProviderStateMixin {
//   GlobalKey<ScaffoldState> feedKey = GlobalKey();
//   ScrollController scrollController;

//   List<DropdownMenuItem<String>> menuOptions;
//   List<Post> nodeList = [];
//   String currentOption;
//   var query;
//   var username = 'Guest';
//   var drawerList;

//   @override
//   initState() {
//     super.initState();
//     setUsername();
//     menuOptions = getOptions();
//     currentOption = menuOptions[0].value;
//     query = refresh();
//     // scrollController = new ScrollController()..addListener(_scrollListener);

//     drawerList = [
//       DrawerHeader(
//         decoration: BoxDecoration(
//           color: Colors.blue,
//         ),
//       ),
//       ListTile(
//           title: Text('Profile'),
//           onTap: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => ProfilePage()));
//           }),
//       ListTile(title: Text('Chats'), onTap: () => null),
//       ListTile(
//           title: Text('Settings'),
//           onTap: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => SettingPage()));
//           }),
//       ListTile(title: Text('Log Out'), onTap: logout),
//     ];
//   }

//   @override
//   dispose() {
//     // scrollController.removeListener(_scrollListener);
//     super.dispose();
//   }

//   // _scrollListener() {
//   //   print(scrollController.position.extentAfter);
//   //   if (scrollController.position.extentAfter < 500) {
//   //     setState(() {
//   //       items.addAll(new List.generate(42, (index) => 'Inserted $index'));
//   //     });
//   //   }
//   // }

//   logout() {
//     SharedPreferences.getInstance().then((prefs) {
//       prefs.setString("username", "");
//       prefs.setString("flair", "");
//       prefs.clear();
//     });
//     Navigator.pushReplacement(context,
//         MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
//   }

//   // refresh() {
//   //   switch (currentOption) {
//   //     case 'A-Z':
//   //       return Firestore().collection(storePath).orderBy('Name').snapshots();
//   //       break;
//   //     case 'Z-A':
//   //       return Firestore()
//   //           .collection(storePath)
//   //           .orderBy('Name', descending: true)
//   //           .snapshots();
//   //       break;
//   //     case 'Lowest Price First':
//   //       return Firestore()
//   //           .collection(storePath)
//   //           .orderBy('Discount')
//   //           .snapshots();
//   //       break;
//   //     case 'Highest Price First':
//   //       return Firestore()
//   //           .collection(storePath)
//   //           .orderBy('Discount', descending: true)
//   //           .snapshots();
//   //       break;
//   //     default:
//   //       break;
//   //   }
//   // }
//   refresh() {
//     return Firestore().collection(postPath).snapshots();
//   }

//   List<DropdownMenuItem<String>> getOptions() {
//     List<DropdownMenuItem<String>> items = new List();
//     for (var option in options) {
//       items.add(new DropdownMenuItem(
//         value: option,
//         child: Text(option),
//       ));
//     }
//     return items;
//   }

//   changeItems(String selected) {
//     setState(() {
//       currentOption = selected;
//       query = refresh();
//     });
//   }

//   getItems(AsyncSnapshot snapshot) {
//     nodeList.clear();
//     snapshot.data.documents.forEach((response) {
//       nodeList.add(Post(
//         response.documentID,
//         response['content'],
//         response['date'],
//         response['flair'],
//         response['location'],
//         response['username'],
//       ));
//     });
//   }

//   setUsername() {
//     SharedPreferences.getInstance().then((prefs) {
//       setState(() {
//         username =
//             prefs.get('username') != null ? prefs.get('username') : 'Guest';
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MyCustomScaffold(
//       bottomNavigationBar: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: EdgeInsets.all(10.0),
//             child: Slider(
//               divisions: 14,
//               min: 1.0,
//               max: 15.0,
//               onChanged: ((response) {
//                 setState(() {
//                   if (distance != response) {
//                     distance = response;
//                   }
//                 });
//               }),
//               onChangeEnd: ((response) {
//                 changeItems(currentOption);
//               }),
//               value: distance,
//               label: distance.round().toString(),
//             ),
//           ),
//         ],
//       ),
//       key: feedKey,
//       appBar: AppBar(
//         title: Text(username),
//         actions: <Widget>[
//           DropdownButton(
//             value: currentOption,
//             items: menuOptions,
//             onChanged: changeItems,
//           ),
//         ],
//       ),
//       endDrawer: SizedBox(
//         width: 150.0,
//         child: Drawer(
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: drawerList,
//           ),
//         ),
//       ),
//       body: StreamBuilder(
//         stream: query,
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('An error occured.'),
//             );
//           }

//           if (!snapshot.hasData &&
//               snapshot.connectionState == ConnectionState.done) {
//             return Center(
//               child: Text('No results.'),
//             );
//           }

//           if (snapshot.hasData) {
//             getItems(snapshot);
//             return ListView.builder(
//               itemCount: nodeList.length,
//               itemBuilder: (context, index) {
//                 // return ListTile(
//                 //   title: Text(nodeList[index].content.toString()),
//                 //   subtitle: Text(nodeList[index].date.toString()),
//                 //   onTap: () => Navigator.push(
//                 //       context,
//                 //       MaterialPageRoute(
//                 //           builder: (context) => CommentPage(
//                 //               post: snapshot.data.documents[index]))),
//                 // );
//                 return nodeList[index].tile(context);
//               },
//             );
//           }

//           if (snapshot.connectionState != ConnectionState.done) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// // class Post {
// //   var content;
// //   var date;
// //   var username;

// //   Post(this.content, this.date, this.username);
// // }

class MyCustomScaffold extends Scaffold {
  MyCustomScaffold({
    AppBar appBar,
    Widget body,
    GlobalKey<ScaffoldState> key,
    Widget floatingActionButton,
    FloatingActionButtonLocation floatingActionButtonLocation,
    FloatingActionButtonAnimator floatingActionButtonAnimator,
    List<Widget> persistentFooterButtons,
    Widget drawer,
    Widget endDrawer,
    Widget bottomNavigationBar,
    Widget bottomSheet,
    Color backgroundColor,
    bool resizeToAvoidBottomPadding = true,
    bool primary = true,
  })  : assert(key != null),
        super(
          key: key,
          appBar: endDrawer != null &&
                  appBar.actions != null &&
                  appBar.actions.isNotEmpty
              ? _buildEndDrawerButton(appBar, key)
              : appBar,
          body: body,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButtonAnimator: floatingActionButtonAnimator,
          persistentFooterButtons: persistentFooterButtons,
          drawer: drawer,
          endDrawer: endDrawer,
          bottomNavigationBar: bottomNavigationBar,
          bottomSheet: bottomSheet,
          backgroundColor: backgroundColor,
          resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,
          primary: primary,
        );

  static AppBar _buildEndDrawerButton(
      AppBar myAppBar, GlobalKey<ScaffoldState> _keyScaffold) {
    myAppBar.actions.add(IconButton(
        icon: Icon(Icons.menu),
        onPressed: () => !_keyScaffold.currentState.isEndDrawerOpen
            ? _keyScaffold.currentState.openEndDrawer()
            : null));
    return myAppBar;
  }
}
