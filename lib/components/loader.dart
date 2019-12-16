import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  final Color backgroundColor;
  Loader({
    this.backgroundColor
  });
  @override
  Widget build(BuildContext context) {
    return new Center(
        child: Container(
          color: backgroundColor,
          child: SpinKitFoldingCube(
            color: Colors.white,
            size: 80,
          ),
        )
    );
  }
}
