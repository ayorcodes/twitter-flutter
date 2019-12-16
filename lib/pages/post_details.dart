import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/postApi.dart';


class PostDetails extends StatefulWidget {

  final id;
  final title;
  final content;
  final postType;
  final author;
  final category;
  final image;

  PostDetails({
    this.id,
    this.title,
    this.content,
    this.postType,
    this.author,
    this.category,
    this.image
  });

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {

  final api = PostApi();
  var comments = [];
  var loading = false;

  getComments(id) async{
    this.loading = true;
    await api.getComments(id).then((res) {
      var output = res.data['data'];
      setState(() {
        comments = output;
        this.loading = false;
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    this.getComments(widget.id);
  }

  @override
  Widget build(BuildContext context) {

    Widget commentView() {
      if (this.loading){
        return Center(child: CircularProgressIndicator());
      }

      List<Widget> list = [];
      for (var i=0; i<comments.length; i++) {
        list.add(SingleComment(
          id: comments[i]['comment_id'],
          comment: comments[i]['comment'],
          author: comments[i]['author'],
          post: comments[i]['post'],
        ));
      }
      return Column(children: list);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          PostDetail(
            id: widget.id,
            title: widget.title,
            content: widget.content,
            image: widget.image,
            author: widget.author,
          ),
          commentView()
//          Container(
//            height: MediaQuery.of(context).size.height/1.7,
//            child: ListView.builder(
//              scrollDirection: Axis.vertical,
//              itemCount: comments.length,
//              itemBuilder: (context, index) {
//                return SingleComment(
//                  id: comments[index]['comment_id'],
//                  comment: comments[index]['comment'],
//                  author: comments[index]['author'],
//                  post: comments[index]['post'],
//                );
//              },
//            ),
//          ),
        ],
      ),
    );

  }
}

class SingleComment extends StatelessWidget {

  final id;
  final comment;
  final author;
  final post;

  SingleComment({
    this.id,
    this.comment,
    this.author,
    this.post
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      child: Column(
        children: <Widget>[
          ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage("${author['avatar']}"),
                radius: 30,
              ),
              title: Text("${author['first_name']}", style: TextStyle(
                  fontWeight: FontWeight.bold
              ),),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("$comment", style: TextStyle(
                      color: Colors.black
                  ),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.chat_bubble),
                        onPressed: () {

                        },
                        iconSize: 18,
                      ),
                      IconButton(
                        icon: Icon(Icons.loop),
                        iconSize: 18,
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite),
                        iconSize: 18,
                      ),

                    ],
                  ),

                ],
              )
          ),
          Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

class PostDetail extends StatelessWidget {

  final id;
  final title;
  final content;
  final postType;
  final author;
  final category;
  final image;

  PostDetail({
    this.id,
    this.title,
    this.content,
    this.postType,
    this.author,
    this.category,
    this.image
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage("${author['avatar']}"),
                  radius: 30,
                ),
                title: Text("${author['first_name']}", style: TextStyle(
                    fontWeight: FontWeight.bold
                ),),
                //subtitle: Text(""),

            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("$content", style: TextStyle(
                      color: Colors.black
                  ),),
                  SizedBox(height: 10,),
                  Divider(
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.chat_bubble),
                        onPressed: () {

                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.loop),
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite),
                      ),

                    ],
                  ),

                ],
              )
          ),
          Divider(
            color: Colors.grey,
          ),

        ],
      ),
    );
  }
}
