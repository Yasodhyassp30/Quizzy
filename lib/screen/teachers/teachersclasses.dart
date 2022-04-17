import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud/screen/teachers/classdetails.dart';
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
  bool added=false;
  TextEditingController title =TextEditingController();
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(future:store.collection('userdata').doc(_auth.currentUser!.uid).get() ,builder: (context,snap){
      if(snap.connectionState==ConnectionState.waiting){
        return loadfadingcube();
      }else{
        Map data= snap.data!.data()as Map;

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              showDialog(context: context, builder: (BuildContext context) {
                return  AlertDialog(
                  title: Text("Create Classroom"),
                  content: TextField(
                    controller: title,
                    decoration: InputDecoration(
                        border:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Classroom name",
                        hintStyle:
                        TextStyle(color: Colors.grey, fontSize: 18.0)
                    ),
                  ),
                  actions: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(child: ElevatedButton(onPressed: ()async{
                            if(title.text.isNotEmpty){
                              store.collection('classrooms').add({
                                'title':title.text.trim(),
                                'teacher':_auth.currentUser!.uid,
                                'students':[],
                                'invited':[],
                                'requested':[]
                              });
                              setState(() {
                                added=true;
                              });
                            }
                            Navigator.pop(context);

                          }, child: Container(
                            padding: EdgeInsets.all(20),
                            child: Text("Create"),
                          )))
                        ],
                      ),
                    )
                  ],
                );
              });
             if(added){
               setState(() {
                added =!added;
               });
             }
            },
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
                            decoration: BoxDecoration(
                              color: Colors.blue[500],
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),

                            ),
                            child:Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.width*0.15,
                                  width: MediaQuery.of(context).size.width*0.15,
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

                        SizedBox(height: 40,),

                        Text('Groups',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 30,color: Colors.lightBlue[300])),),

                       Container(
                         height: MediaQuery.of(context).size.height*0.6,
                         padding: EdgeInsets.all(20),
                         child:  FutureBuilder<QuerySnapshot>(future: store.collection('classrooms').where('teacher',isEqualTo: _auth.currentUser!.uid).get(),builder: (context,snap){
                           if(snap.connectionState==ConnectionState.waiting){
                             return loadfadingcube();
                           }else{
                             List classdata=[];
                             if(snap.data!=null){
                               classdata =snap.data!.docs as List;
                             }
                             return ListView.builder(itemCount: classdata.length,
                                 scrollDirection: Axis.vertical,
                                 shrinkWrap: true,
                                 physics: ScrollPhysics(),
                                 itemBuilder: (context,i){
                                   return Column(
                                     children: [

                                       Container(
                                         width: MediaQuery.of(context).size.width*0.9,
                                         padding: EdgeInsets.all(10),
                                         decoration: BoxDecoration(
                                             color: Colors.lightBlue[800],
                                             borderRadius: BorderRadius.circular(15)

                                         ),
                                         child:Row(
                                           children: [
                                             Column(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Container(
                                                   width:MediaQuery.of(context).size.width*0.6,
                                                   height: MediaQuery.of(context).size.height*0.05,
                                                   child: Text(classdata[i]['title'],style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white,overflow:TextOverflow.ellipsis)),),
                                                 ),
                                                 Text('Students : ${classdata[i]['students'].length}',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 15,color: Colors.white)),),
                                               ],
                                             ),
                                            Expanded(child: SizedBox()),
                                             IconButton(onPressed: ()async{
                                              await Navigator.push(
                                                 context,
                                                 MaterialPageRoute(builder: (context) => classroomdetails(classdetails: classdata[i],)),
                                               );
                                               setState(() {

                                               });

                                             }, icon: Icon(
                                                 Icons.more_horiz,size: 40,color: Colors.lightBlue[100],
                                             ))
                                           ],
                                         )
                                       ),
                                       SizedBox(height: 10.0,),
                                     ],
                                   );
                                 });

                           }
                         }),
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

    });
  }

}
