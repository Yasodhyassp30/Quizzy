import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud/screen/teachers/quizcreation.dart';
import 'package:cloud/screen/teachers/viewassement.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class typeselection extends StatefulWidget {
  const typeselection({Key? key}) : super(key: key);

  @override
  State<typeselection> createState() => _typeselectionState();
}

class _typeselectionState extends State<typeselection> {
  FirebaseFirestore store =FirebaseFirestore.instance;
  FirebaseAuth _auth =FirebaseAuth.instance;
  bool loading =false;
  @override

  Widget build(BuildContext context) {
    if(loading){
      return loadfadingcube();
    }else{
      return Scaffold(
        body: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Container(
            color: Colors.lightBlue[100],
            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height*0.4,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: Colors.blue[500],
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),


                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 10.0,),
                                  Text('Quizzy Assesments',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            ElevatedButton(onPressed: ()async{
                              QuerySnapshot ? result;
                              if(result==null){
                                loading=true;
                                setState(() {

                                });
                              }
                              result=await store.collection('classrooms').where('teacher',isEqualTo: _auth.currentUser!.uid).get();
                              if(result!=null){
                                loading=false;
                                setState(() {

                                });
                              }
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>quizcreation(classlist: result!.docs,)));

                            },child: Container(
                              width: MediaQuery.of(context).size.width*0.8,
                              padding: EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  Icon(Icons.create),
                                  Text(' Create a Quiz')
                                ],
                              ),
                            ),),
                            SizedBox(height: 20,),
                            ElevatedButton(onPressed: ()async{
                              QuerySnapshot ? result;
                              if(result==null){
                                loading=true;
                                setState(() {

                                });
                              }
                              result=await store.collection('classrooms').where('teacher',isEqualTo: _auth.currentUser!.uid).get();
                              if(result!=null){
                                loading=false;
                                setState(() {

                                });
                              }

                              Navigator.push(context, MaterialPageRoute(builder: (context)=>quizview(classlist: result!.docs,)));
                            },child: Container(
                              padding: EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.width*0.8,
                              child: Row(
                                children: [
                                  Icon(Icons.remove_red_eye),
                                  Text(' View Assesments')
                                ],
                              ),
                            ),),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: MediaQuery.of(context).size.height*0.4,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/Quizhome.png')
                            )
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
