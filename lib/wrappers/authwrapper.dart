import 'dart:async';

import 'package:cloud/screen/login.dart';
import 'package:cloud/screen/teachers/teachershome.dart';
import 'package:cloud/wrappers/homewrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Usermodel.dart';

class authwrapper extends StatefulWidget {
  const authwrapper({Key? key}) : super(key: key);

  @override
  _authwrapperState createState() => _authwrapperState();
}

class _authwrapperState extends State<authwrapper> {

  @override

  Widget build(BuildContext context) {
    final currentuser =Provider.of<User?>(context);

    if(currentuser==null){
      return login();
    }else {

      return homewrapper();
    }

  }
}
