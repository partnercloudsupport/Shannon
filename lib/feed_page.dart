import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shannon/post_page.dart';
import 'package:shannon/setting_page.dart';

class FeedPage extends StatefulWidget {
  @override
  createState() => _FeedPage();
}

var options = ['A-Z', 'Z-A', 'Lowest Price First', 'Highest Price First'];

class _FeedPage extends State<FeedPage> with TickerProviderStateMixin {
  List<DropdownMenuItem<String>> menuOptions;
  List<Node> nodeList = [];
  String currentOption;
  var query;
  var storePath = 'vouchers';
  var username = 'Guest';
  var drawerList;

  @override
  initState() {
    super.initState();
    setUser();
    menuOptions = getOptions();
    currentOption = menuOptions[0].value;
    query = refresh();

    drawerList = [
      DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
      ListTile(title: Text('Profile'), onTap: () => null),
      ListTile(title: Text('Chats'), onTap: () => null),
      ListTile(
          title: Text('Settings'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingPage()));
          }),
      ListTile(title: Text('Log Out'), onTap: () => null),
    ];
  }

  refresh() {
    switch (currentOption) {
      case 'A-Z':
        return Firestore().collection(storePath).orderBy('Name').snapshots();
        break;
      case 'Z-A':
        return Firestore()
            .collection(storePath)
            .orderBy('Name', descending: true)
            .snapshots();
        break;
      case 'Lowest Price First':
        return Firestore()
            .collection(storePath)
            .orderBy('Discount')
            .snapshots();
        break;
      case 'Highest Price First':
        return Firestore()
            .collection(storePath)
            .orderBy('Discount', descending: true)
            .snapshots();
        break;
      default:
        break;
    }
  }

  List<DropdownMenuItem<String>> getOptions() {
    List<DropdownMenuItem<String>> items = new List();
    for (var option in options) {
      items.add(new DropdownMenuItem(
        value: option,
        child: Text(option),
      ));
    }
    return items;
  }

  changeItems(String selected) {
    setState(() {
      currentOption = selected;
      query = refresh();
    });
  }

  getItems(AsyncSnapshot snapshot) {
    nodeList.clear();
    snapshot.data.documents.forEach((response) {
      nodeList.add(Node(response['Name'], response['Discount']));
    });
  }

  setUser() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        username = prefs.get('user') != null ? prefs.get('user') : 'Guest';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyCustomScaffold(
      appBar: AppBar(
        title: Text(username),
        actions: <Widget>[
          DropdownButton(
            value: currentOption,
            items: menuOptions,
            onChanged: changeItems,
          ),
        ],
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
      body: StreamBuilder(
        stream: query,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('An error occured.'),
            );
          }

          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Text('No results.'),
            );
          }

          if (snapshot.hasData) {
            getItems(snapshot);
            return ListView.builder(
              itemCount: nodeList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(nodeList[index].name.toString()),
                  subtitle: Text(nodeList[index].discount.toString()),
                );
              },
            );
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

class Node {
  var name;
  var discount;

  Node(this.name, this.discount);
}

class MyCustomScaffold extends Scaffold {
  static GlobalKey<ScaffoldState> _keyScaffold = GlobalKey();

  MyCustomScaffold({
    AppBar appBar,
    Widget body,
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
  }) : super(
          key: _keyScaffold,
          appBar: endDrawer != null &&
                  appBar.actions != null &&
                  appBar.actions.isNotEmpty
              ? _buildEndDrawerButton(appBar)
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

  static AppBar _buildEndDrawerButton(AppBar myAppBar) {
    myAppBar.actions.add(IconButton(
        icon: Icon(Icons.menu),
        onPressed: () => !_keyScaffold.currentState.isEndDrawerOpen
            ? _keyScaffold.currentState.openEndDrawer()
            : null));
    return myAppBar;
  }
}
