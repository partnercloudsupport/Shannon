import 'package:flutter/material.dart';
import 'package:shannon/globals/strings.dart';
import 'package:shannon/widgets/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shannon/widgets/post.dart';
import 'package:shannon/widgets/comment.dart';
import 'package:shannon/handler/comment_handler.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentPage extends StatefulWidget {
  final Post post;

  CommentPage({Key key, @required this.post}) : super(key: key);

  @override
  createState() => _CommentPage();
}

class _CommentPage extends State<CommentPage> {
  static final commentFormKey = GlobalKey<FormState>();
  static final feedScaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController commentController = TextEditingController();

  CommentHandler commentHandler = CommentHandler();

  static List<Comment> commentList = [];
  var query;
  var comment;
  bool headerEnabled = false;
  Comment commentTile;
  static Post value;
  static int entries = 1000;

  static final pageLoadController = PagewiseLoadController(
      pageSize: 1001,
      pageFuture: (index) {
        return fetchComment(index);
      });

  @override
  initState() {
    super.initState();
    value = widget.post;
  }

  static Future<List<Comment>> fetchComment(index) async {
    commentList.clear();
    await http
        .get(
            "https://us-central1-shannon-26719.cloudfunctions.net/comment?page=" +
                index.toString() +
                "&entries=" +
                entries.toString() +
                "&uid=" +
                value.id.toString())
        .then((response) {
      if (response.statusCode == 200) {
        String text = response.body;
        if (text.isNotEmpty) {
          commentList = CommentList.fromJson(json.decode(response.body)).posts;
        }
        if (index == 0) {
          //Header tile.
          commentList.insert(
              0, Comment(content: value.content, username: value.username, flair: value.flair));
        }
      } else {
        print("Invalid status code");
      }
    }).catchError((e) {
      print(e.toString());
    });
    return commentList;
  }

  Widget commentField() {
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 140,
                autocorrect: false,
                controller: commentController,
                validator: (val) {
                  if (val.length <= 0) {
                    return "don't be shy, write something";
                  }
                },
                onSaved: (val) => comment = val,
                decoration: InputDecoration(
                  hintText: "join the fray",
                  contentPadding: EdgeInsets.all(10.0),
                ),
              ),
            ),
          ),
          circleButton(Icon(Icons.first_page), "YELLOW", submit),
        ],
      ),
    );
  }

  submit() async {
    var form = commentFormKey.currentState;
    if (form.validate()) {
      form.save();
      await commentHandler.submit(comment, widget.post.id).then((response) {
        if (response) {
          form.reset();
          print("Commented");
        } else {
          print("Unsucessful");
        }
      }).catchError((e) {
        print(e.toString());
      });
    }
  }

  refresh() {
    return Firestore()
        .collection(postPath)
        .document(widget.post.id)
        .collection(commentPath)
        .snapshots();
  }
  
  Tile(context, content, username) {
    return ListTile(
      title: Text(content),
      subtitle: Text(username),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("sample"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: PagewiseListView(
                    pageLoadController: pageLoadController,
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, entry, index) {
                      commentTile = entry;
                      return commentTile.tile();
                    })
                // child: StreamBuilder(
                //   stream: query,
                //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                //     if (snapshot.hasError) {
                //       return Center(
                //         child: Text('An error occurred.'),
                //       );
                //     }
                //     if (!snapshot.hasData &&
                //         snapshot.connectionState == ConnectionState.done) {
                //       return Center(
                //         child: Text('Only silence here.'),
                //       );
                //     }

                //     if (snapshot.hasData) {
                //       getItems(snapshot);
                //       if (commentList.length == 0) {
                //         return Center(child: Text('Only silence here...'));
                //       } else {
                //         return ListView.builder(
                //           // shrinkWrap: true,
                //           // physics: AlwaysScrollableScrollPhysics(),
                //           itemCount: commentList.length,
                //           itemBuilder: (context, index) {
                //             return commentList[index].tile();
                //           },
                //         );
                //       }
                //     }

                //     if (snapshot.connectionState != ConnectionState.done) {
                //       return Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     }
                //   },
                // ),
                ),
            Form(
              key: commentFormKey,
              child: commentField(),
            ),
          ],
        ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         title: Text(widget.post.username),
  //       ),
  //       body: Column(
  //         children: <Widget>[
  //           Expanded(
  //             child: StreamBuilder(
  //               stream: query,
  //               builder: (BuildContext context, AsyncSnapshot snapshot) {
  //                 if (snapshot.hasError) {
  //                   return Center(
  //                     child: Text('An error occurred.'),
  //                   );
  //                 }
  //                 if (!snapshot.hasData &&
  //                     snapshot.connectionState == ConnectionState.done) {
  //                   return Center(
  //                     child: Text('Only silence here.'),
  //                   );
  //                 }

  //                 if (snapshot.hasData) {
  //                   getItems(snapshot);
  //                   if (commentList.length == 0) {
  //                     return Center(child: Text('Only silence here...'));
  //                   } else {
  //                     return ListView.builder(
  //                       // shrinkWrap: true,
  //                       // physics: AlwaysScrollableScrollPhysics(),
  //                       itemCount: commentList.length,
  //                       itemBuilder: (context, index) {
  //                         return commentList[index].tile();
  //                       },
  //                     );
  //                   }
  //                 }

  //                 if (snapshot.connectionState != ConnectionState.done) {
  //                   return Center(
  //                     child: CircularProgressIndicator(),
  //                   );
  //                 }
  //               },
  //             ),
  //           ),
  //           Form(
  //             key: commentFormKey,
  //             child: commentField(),
  //           ),
  //         ],
  //       )
  //       // body: Column(
  //       //   children: <Widget>[
  //       //     Flexible(
  //       //       child: Column(
  //       //         children: <Widget>[
  //       //           // contentBox(
  //       //           //   content: widget.post.content,
  //       //           //   color: "YELLOW",
  //       //           // ),
  //       //           StreamBuilder(
  //       //             stream: query,
  //       //             builder: (BuildContext context, AsyncSnapshot snapshot) {
  //       //               if (snapshot.hasError) {
  //       //                 return Center(
  //       //                   child: Text('An error occurred.'),
  //       //                 );
  //       //               }
  //       //               if (!snapshot.hasData &&
  //       //                   snapshot.connectionState == ConnectionState.done) {
  //       //                 return Center(
  //       //                   child: Text('Only silence here.'),
  //       //                 );
  //       //               }

  //       //               if (snapshot.hasData) {
  //       //                 getItems(snapshot);
  //       //                 if (commentList.length == 0) {
  //       //                   return Center(child: Text('Only silence here...'));
  //       //                 } else {
  //       //                   return ListView.builder(
  //       //                     shrinkWrap: true,
  //       //                     physics: AlwaysScrollableScrollPhysics(),
  //       //                     itemCount: commentList.length,
  //       //                     itemBuilder: (context, index) {
  //       //                       return commentList[index].tile();
  //       //                     },
  //       //                   );
  //       //                 }
  //       //               }

  //       //               if (snapshot.connectionState != ConnectionState.done) {
  //       //                 return Center(
  //       //                   child: CircularProgressIndicator(),
  //       //                 );
  //       //               }
  //       //             },
  //       //           ),
  //       //         ],
  //       //       ),
  //       //     ),
  //       //     // Form(
  //       //     //   key: commentFormKey,
  //       //     //   child: commentField(),
  //       //     // ),
  //       //   ],
  //       // ),
  //       );
  // }
}
