import 'dart:html';

import 'package:flutter/material.dart';

class uploadprogress extends StatefulWidget {
  final File ? file;
  final String? title;
  final String ? message;
  const uploadprogress({Key? key,this.file,this.title,this.message}) : super(key: key);

  @override
  _uploadprogressState createState() => _uploadprogressState();
}

class _uploadprogressState extends State<uploadprogress> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
