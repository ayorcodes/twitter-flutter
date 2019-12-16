import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app/api/authApi.dart';
import 'package:news_app/components/loader.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void setupNewsApp() async {

    await Auth().checkAuth().then((response) {
      Navigator.pushReplacementNamed(context, '/home');
    }).catchError((error) {
      Navigator.pushReplacementNamed(context, '/login');
    });
    /* if (checkAuth) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    } */


  }

  @override
  void initState() {
    super.initState();
    setupNewsApp();
  }

  @override
  Widget build(BuildContext context) {
    return Loader(
      backgroundColor: Colors.lightBlue,
    );
  }
}
