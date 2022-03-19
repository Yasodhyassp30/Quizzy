import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class loadfadingcube extends StatelessWidget {
  const loadfadingcube({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Container(
      color: Colors.blue[600],
      child: Center(
        child: SpinKitWave(
          color: Colors.lightBlue[200],
          size: 60.0,
        ),
      ),
    ));
  }
}