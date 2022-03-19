import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../login.dart';

class teacherclasses extends StatefulWidget {
  const teacherclasses({Key? key}) : super(key: key);

  @override
  _teacherclassesState createState() => _teacherclassesState();
}

class _teacherclassesState extends State<teacherclasses> {
  @override
  FirebaseFirestore store =FirebaseFirestore.instance;
  FirebaseAuth _auth =FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(future:store.collection('userdata').doc(_auth.currentUser!.uid).get() ,builder: (context,snap){
      if(snap.connectionState==ConnectionState.waiting){
        return loadfadingcube();
      }else{
        Map data= snap.data!.data()as Map;

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: (){},
            child: Icon(
              Icons.add,size: 30,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
              minWidth: MediaQuery.of(context).size.width,

            ),
            child: Container(
              color: Colors.lightBlue[100],
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(25),
                            height: MediaQuery.of(context).size.height*0.15,
                            decoration: BoxDecoration(
                              color: Colors.blue[500],
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),

                            ),
                            child:Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      image: DecorationImage(
                                          image: AssetImage('assets/studentavatar.png'),
                                          fit: BoxFit.fill
                                      )
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Welcome!',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                                      Text(data['firstname']+" "+data['lastname'],style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 15,color: Colors.white)),),
                                    ],
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                OutlinedButton(onPressed: ()async{
                                  FirebaseAuth _auth =FirebaseAuth.instance;
                                  await _auth.signOut();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>login(),
                                    ),
                                        (route) => false,
                                  );
                                }, child: Text('Sign out',style: TextStyle(
                                  color: Colors.white,

                                ),),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(width: 2.0, color: Colors.white),
                                  ),
                                )
                              ],
                            )
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }

    });
  }
}
