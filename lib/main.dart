import 'package:flutter/material.dart';
import 'package:news_app/components/add_comment.dart';
import 'package:news_app/components/new_post.dart';
import 'package:news_app/pages/comments.dart';
import 'package:news_app/pages/home.dart';
import 'package:news_app/pages/loading.dart';
import 'package:news_app/pages/login.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryTextTheme: TextTheme(
        
      )
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
     
      '/login': (context) => Login(),
      '/comments': (context) => Comments(),
      '/newPost': (context) => NewPostModal(),
      '/addComment': (context) => NewCommentModal()

    },
  ));
}