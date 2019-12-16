import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/api/postApi.dart';
import 'package:news_app/pages/post_details.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class Posts extends StatefulWidget {
 /* final _PostsState post;
  Posts(this.post);*/
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {

  final api = PostApi();

  var posts = [];

  int page;

  RefreshController _refreshController =
  RefreshController(initialRefresh: true);

  fetchPosts() async{
    await api.getPosts().then((res) {
      var output = res.data['data'];
      setState(() {
        posts = output;
        //posts.addAll(output);
        page = res.data['meta']['current_page'];
      });
      _refreshController.refreshCompleted();
    }).catchError((error) {
      print(error.toString());
    });
  }

  loadMore() async{
    var nextPage = page + 1;
    await api.loadMorePosts(nextPage).then((res) {
      var output = res.data['data'];
      setState(() {
        posts.addAll(output);
        /*for(var i=0; i<output.length; i++) {
          posts.add(output[i]);
        }*/
        page = res.data['meta']['current_page'] + 1;
      });
      _refreshController.loadComplete();
    }).catchError((error) {
      print(error);
    });
  }


  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.loadFailed();
  }



  @override
  void initState() {
    super.initState();
    (() async {
      // await fetchPosts();
    })();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropMaterialHeader(
        color: Colors.lightBlue,
        backgroundColor: Colors.lightBlue,
      ),
      footer: CustomFooter(
        builder: (BuildContext context,LoadStatus mode){
          Widget body ;
          if(mode==LoadStatus.idle){
            body =  Text("pull up load");
          }
          else if(mode==LoadStatus.loading){
            body =  CupertinoActivityIndicator();
          }
          else if(mode == LoadStatus.failed){
            body = Text("Load Failed!Click retry!");
          }
          else if(mode == LoadStatus.canLoading){
            body = Text("release to load more");
          }
          else{
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child:body),
          );
        },
      ),
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return SinglePost(
            id: posts[index]['post_id'],
            title: posts[index]['title'],
            content: posts[index]['content'],
            postType: posts[index]['post_type'],
            author: posts[index]['author'],
            category: posts[index]['category'],
            image: posts[index]['image'],
          );
        },
      ),
      controller: _refreshController,
      onRefresh: fetchPosts,
      onLoading: loadMore,

    );
    /*return Loader(
      backgroundColor: Colors.lightBlue,
    );*/
  }
}

class SinglePost extends StatelessWidget {

  final id;
  final title;
  final content;
  final postType;
  final author;
  final category;
  final image;

  SinglePost({
    this.id,
    this.title,
    this.content,
    this.postType,
    this.author,
    this.category,
    this.image
  });

  final noPadding = EdgeInsets.all(0);
  final alignLeft = Alignment.centerLeft;
  double fontSize = 13;

  MoneyFormatterOutput comments = FlutterMoneyFormatter(
    amount: Random.secure().nextInt(7000).toDouble()
  ).output;

  MoneyFormatterOutput retweets = FlutterMoneyFormatter(
    amount: Random.secure().nextInt(1000000).toDouble()
  ).output;

  MoneyFormatterOutput likes = FlutterMoneyFormatter(
    amount: Random.secure().nextInt(1000000).toDouble()
  ).output;
  
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PostDetails(
                  id: id,
                  title: title,
                  content: content,
                  postType: postType,
                  author: author,
                  category: category,
                  image: image,
                );
              }));
            },
            child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage("${author['avatar']}"),
                  radius: 30,
                ),
                title: Text("${author['first_name']}", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13
                ),),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("$content", style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSize
                      ),),
                      
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            /* RaisedButton.icon(
                              icon: Icon(FontAwesomeIcons.comment, size: 14,),
                              label: Text("${comments.compactNonSymbol}", style: TextStyle(
                                fontSize: fo
                              ),),
                              onPressed: () {

                              },
                              color: Colors.transparent,
                              textColor: Colors.grey,
                              elevation: 0.0,
                              highlightElevation: 0,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              
                              ),*/
                            InkWell(
                              child: Row(
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.comment, size: 14,color: Colors.grey,),
                                  SizedBox(width: 7,),
                                  Text("${comments.compactNonSymbol}", style: TextStyle(fontSize: fontSize,),)
                                ],
                              ),
                              onTap: () async{
                                await Navigator.pushNamed(context, '/addComment', arguments: {
                                  'image': "denfieifneif"
                                });
                              },
                              //highlightColor: Colors.green,
                            ),
                            /* IconButton(
                              icon: Icon(Icons.chat_bubble_outline),
                              iconSize: 15,
                              color: Colors.grey,
                              padding: noPadding,
                              alignment: alignLeft,
                              onPressed: () {

                              },
                            ), */
                            InkWell(
                              child: Row(
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.retweet, size: 14,color: Colors.grey,),
                                  SizedBox(width: 7,),
                                  Text("${retweets.compactNonSymbol}", style: TextStyle(fontSize: fontSize))
                                ],
                              ),
                              onTap: () {
                                
                              },
                            ),
                            InkWell(
                              child: Row(
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.heart, size: 14,color: Colors.grey,),
                                  SizedBox(width: 7,),
                                  Text("${likes.compactNonSymbol}", style: TextStyle(fontSize: fontSize))
                                ],
                              ),
                              onTap: () {
                                
                              },
                            ),
                            InkWell(
                              child: Row(
                                children: <Widget>[
                                  Icon(FontAwesomeIcons.shareAlt, size: 15,color: Colors.grey,)
                                ],
                              ),
                              onTap: () {
                                
                              },
                            ),
                            InkWell(
                              child: Row(
                                children: <Widget>[
                                 // Icon(Icons.share, size: 15,)
                                ],
                              ),
                              onTap: () {
                                
                              },
                            ),

                          ],
                        ),
                      ),

                    ],
                  ),
                )
            ),
          ),
          Divider(
            color: Colors.grey,
            indent: 0,
          ),
        ],
      ),
    );
  }
}