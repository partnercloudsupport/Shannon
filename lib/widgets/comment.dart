import 'package:flutter/material.dart';
import 'package:shannon/widgets/entities.dart';
import 'package:shannon/globals/globals.dart';

class Comment {
  final String id;
  final String content;
  final String username;
  final String flair;

  Comment({this.id, this.content, this.username, this.flair});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      username: json['username'],
      flair: json['flair'],
    );
  }

  Widget tile() {
    return contentBox(
      color: flairs[flair],
      content: content,
      username: username,
    );
  }
}

class CommentList {
  final List<Comment> posts;

  CommentList({this.posts});

  factory CommentList.fromJson(List<dynamic> parsedJson) {
    List<Comment> posts = new List<Comment>();
    posts = parsedJson.map((i) => Comment.fromJson(i)).toList();

    return new CommentList(posts: posts);
  }
}
