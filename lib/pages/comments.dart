import 'package:flutter/material.dart';
import 'package:news_app/api/postApi.dart';

class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {

  var comments;
  final api = PostApi();
  Map route;

  getComments(id) async{
    await api.getComments(id).then((res) {
      var output = res.data['data'];
      this.comments = output;
      print(this.comments);
      /*setState(() {
        comments = output;
        print(comments);
      });*/
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    //this.getComments();
  }

  @override
  Widget build(BuildContext context) {

    route = ModalRoute.of(context).settings.arguments;

    this.getComments(route['postId']);

    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
      ),
    );
  }
}

class Comment extends StatelessWidget {

  final id;
  final comment;
  final author;
  final post;

  Comment({
    this.id,
    this.comment,
    this.author,
    this.post
  });

  @override
  Widget build(BuildContext context) {
    return Container(
    );
  }
}

