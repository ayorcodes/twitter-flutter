import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app/api/authApi.dart';
import 'package:news_app/components/loader.dart';
import 'package:news_app/components/new_post.dart';
import 'package:news_app/components/posts.dart';
import 'package:news_app/pages/login.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final api = Auth();

  var user;

  var _currentTab = 0;

  var _children = [
    Posts(),
    Login()
  ];

  logout() async{
    await api.logout().then((response) async{
      await api.deleteToken();
      Navigator.pushReplacementNamed(context, '/login');
    }).catchError((error) async{
      await api.deleteToken();
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  getUser() async{
    await api.checkAuth().then((res) async{
      var output = res.data;
      //await api.setUser(output.toString());
      setState(() {
        user = output;
      });
    }).catchError((error) {
      print(error);
    });
  }

  tabTapped(int index) {
    setState(() {
      _currentTab = index;
    });
  }


  @override
  void initState() {
    super.initState();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {




    if(user != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Home', style: TextStyle(
            color: Colors.black,

          ),),
          iconTheme: new IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          actions: <Widget>[
            InkWell(
              child: Icon(Icons.exit_to_app),
              onTap: () async{
                logout();
                //Navigator.pushReplacementNamed(context, '/login');
              },
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("${user['first_name']}"),
                accountEmail: Text("${user['email']}"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage("${user['avatar']}"),
                ),
              ),
              InkWell(
                  onTap: () {

                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.home,
                      color: Colors.black,
                    ),
                    title: Text("Home"),
                  )
              ),
              InkWell(
                  onTap: () {

                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.comment,
                      color: Colors.black,
                    ),
                    title: Text("Posts"),
                  )
              ),
              InkWell(
                  onTap: () {

                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.favorite,
                      color: Colors.black,
                    ),
                    title: Text("Favorites"),
                  )
              ),
              InkWell(
                  onTap: () {

                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                    title: Text("Settings"),
                  )
              ),
            ],
          ),
        ),
        body: _children[_currentTab],
        bottomNavigationBar: BottomNavigationBar(
          onTap: tabTapped,
          currentIndex: _currentTab,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text("")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                title: Text("")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text("")
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.create),
          onPressed: () async{
            dynamic result = await Navigator.pushNamed(context, '/newPost', arguments: {
              'image': user['avatar']
            });
            if (result['refresh']){

            }
          },
        )
      );
    }
    return Loader(
      backgroundColor: Colors.lightBlue,
    );
  }
}


