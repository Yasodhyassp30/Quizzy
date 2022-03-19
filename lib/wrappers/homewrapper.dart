import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud/screen/student/studentshome.dart';
import 'package:cloud/screen/teachers/teachershome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class homewrapper extends StatefulWidget {
  const homewrapper({Key? key}) : super(key: key);

  @override
  _homewrapperState createState() => _homewrapperState();
}

class _homewrapperState extends State<homewrapper> {
  FirebaseFirestore store =FirebaseFirestore.instance;
  FirebaseAuth _auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(future:store.collection('userdata').doc(_auth.currentUser!.uid).get(),builder: (context,snapshot){
      if(snapshot.connectionState==ConnectionState.waiting){
        return loadfadingcube();
      }else{
          if(snapshot.data!.get('type')==1){
            return teachershome();
          }else{
            return studentshome();
          }

      }

    });
  }
}
