import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud/screen/student/joinclass.dart';
import 'package:cloud/screen/student/studentclassdetails.dart';
import 'package:cloud/screen/student/studentnotifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../login.dart';
import '../teachers/classdetails.dart';

class studentclasses extends StatefulWidget {
  const studentclasses({Key? key}) : super(key: key);

  @override
  _studentclassesState createState() => _studentclassesState();
}

class _studentclassesState extends State<studentclasses> {
  @override
  FirebaseFirestore store =FirebaseFirestore.instance;
  FirebaseAuth _auth =FirebaseAuth.instance;
  bool changed=false;
 final  CollectionReference ref= FirebaseFirestore.instance.collection('notifications');
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(future:store.collection('userdata').doc(_auth.currentUser!.uid).get() ,builder: (context,snap){
      if(snap.connectionState==ConnectionState.waiting){
        return loadfadingcube();
      }else{
        Map data= snap.data!.data()as Map;

        return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => joinclass()),
                );
              },
              child: Icon(Icons.add),
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
                                StreamBuilder<DocumentSnapshot>(stream:ref.doc(data['uid']).snapshots(),builder: (context,snapdata){
                                  if(snapdata.connectionState==ConnectionState.waiting){
                                  }else{
                                    try{
                                      for(int i=0;i<snapdata.data!.get('notifications').length;i++){

                                        if(snapdata.data!.get('notifications')[i]['new']) {
                                          changed = true;
                                          break;
                                        }
                                      }}catch(e){
                                      changed=false;
                                    }
                                  }
                                  if(changed){
                                    return IconButton(onPressed: ()async{
                                      List notify = snapdata.data!.get('notifications');
                                      notify.forEach((element) {element['new']=false; });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => notifcationsstudents()),
                                      );
                                      await store.collection('notifications').doc(data['uid']).set({'notifications':notify});

                                    }, icon: Icon(Icons.notifications_active));
                                  }else {
                                    return IconButton(onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => notifcationsstudents()),
                                      );
                                      setState(() {

                                      });
                                    },
                                        icon: Icon(Icons.notifications));
                                  }
                                }),
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
                        Container(
                          height: MediaQuery.of(context).size.height*0.6,
                          padding: EdgeInsets.all(20),
                          child:  FutureBuilder<QuerySnapshot>(future: store.collection('classrooms').where('students',arrayContains: _auth.currentUser!.uid).get(),builder: (context,snap){
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
                                                IconButton(onPressed: (){
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => studentclassdetails(classdetails: snap.data!.docs[i],)),
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
          )
        );
      }

    });
  }
}
