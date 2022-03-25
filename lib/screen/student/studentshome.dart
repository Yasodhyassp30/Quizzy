import 'package:cloud/screen/common/chatlist.dart';
import 'package:cloud/screen/common/chatliststudent.dart';
import 'package:cloud/screen/student/classesstudent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login.dart';

class studentshome extends StatefulWidget {
  const studentshome({Key? key}) : super(key: key);

  @override
  _studentshomeState createState() => _studentshomeState();
}

class _studentshomeState extends State<studentshome> {
  int _selected=0;
  static const List<Widget> _options=<Widget>[
    studentclasses(),
    chatstudents()


  ];
  void _ontapped(int index){
    setState(() {
      _selected=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Container(

            child:_options.elementAt(_selected)
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue[300],
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          currentIndex:_selected ,
          onTap: _ontapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,),
              label: "Home",



            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.messenger),
              label: "Messages",

            ),


            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: "Classes",

            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: "Quizzes",

            )
          ],
        ),
      );
  }
}
