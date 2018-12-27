import 'package:flutter/material.dart';
import 'package:shannon/post_page.dart';
import 'package:shannon/feed_page.dart';

class LandingPage extends StatefulWidget {
  @override
  createState() => _LandingPage();
}

class _LandingPage extends State<LandingPage> with TickerProviderStateMixin {
  TabController tabController;

  final widgetList = [
    PostPage(),
    FeedPage(),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: widgetList.length,
      initialIndex: 1,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: TabBarView(
        controller: tabController,
        children: widgetList.map((e) {
          return Center(
            child: widgetList[widgetList.indexOf(e)],
          );
        }).toList(),
      ),
    );
  }
}
