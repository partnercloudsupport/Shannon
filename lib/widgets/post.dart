import 'package:flutter/material.dart';
import 'package:shannon/comment_page.dart';
import 'package:shannon/widgets/entities.dart';
import 'package:shannon/globals/globals.dart';

class Post {
  final String id;
  final String content;
  final String username;
  final String flair;
  final double latitude;
  final double longitude;
  final int likes;
  final int time;

  Post(
      {this.id,
      this.content,
      this.latitude,
      this.longitude,
      this.time,
      this.username,
      this.flair,
      this.likes
      });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      time: json['time'],
      username: json['username'],
      flair: json['flair']
    );
  }

  Widget tile(context) {
    return postBox(
      content: content,
      username: username,
      time: time,
      color: flairs[flair],
      action: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CommentPage(
                    post: this,
                  ))),
    );
  } 
}

class PostList {
  final List<Post> posts;

  PostList({this.posts});

  factory PostList.fromJson(List<dynamic> parsedJson) {
    List<Post> posts = new List<Post>();
    posts = parsedJson.map((i) => Post.fromJson(i)).toList();

    return new PostList(posts: posts);
  }
}

// class Post {
//   var id;
//   var content;
//   var date;
//   var flair;
//   var location;
//   var username;

//   Post(this.id, this.content, this.date, this.flair, this.location,
//       this.username);

//   Widget tile(var context) {
//     return ListTile(
//       title: Text(content),
//       subtitle: Text(username),
//       onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => CommentPage(
//                     post: this,
//                   ))),
//     );
//   }
// }
