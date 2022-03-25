import 'package:cloud/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class notifcationsstudents extends StatefulWidget {
  const notifcationsstudents({Key? key}) : super(key: key);

  @override
  _notifcationsstudentsState createState() => _notifcationsstudentsState();
}

class _notifcationsstudentsState extends State<notifcationsstudents> {
  FirebaseAuth _auth =FirebaseAuth.instance;
  FirebaseFirestore store =FirebaseFirestore.instance;
  List notifications=[];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(future:store.collection('notifications').doc(_auth.currentUser!.uid).get() ,builder: (context,snap){
     if(snap.connectionState==ConnectionState.waiting){

     }else{
      if(snap.data?.data()!=null){
        notifications=snap.data!.get('notifications');
      }
     }
      return Scaffold(
        body: ConstrainedBox(
          constraints: new BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width,

          ),
          child: Container(
            color: Colors.lightBlue[100],
            child: SafeArea(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [

                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
                            color: Colors.blue
                          ),
                          padding: EdgeInsets.all(20),
                          child:Row(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.pop(context);
                              }, icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,)),
                              Text('Notifications!',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25,color: Colors.white)),),
                              Expanded(child: SizedBox()),
                              Icon(Icons.notifications,size: 25,color: Colors.white,),
                              SizedBox(width: 30,)
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30,),
                    Container(
                      child:(notifications.length>0)?ListView.builder(itemCount: notifications.length,
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
                                              width:MediaQuery.of(context).size.width*0.8,
                                              child: Text('You are invited to join ${notifications[i]['title']} Group',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white,)),),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(

                                              children: [
                                                ElevatedButton(onPressed: ()async{
                                                  databaseService d1=databaseService(uid: _auth.currentUser!.uid);
                                                  await d1.accpetinvite(notifications[i]['classroomid'], _auth.currentUser!.uid, notifications[i]);
                                                  setState(() {

                                                  });
                                                },  child: Text("Accept")),
                                                SizedBox(width: 20,),
                                                ElevatedButton(onPressed: (){},  child: Text("Reject"),
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Colors.redAccent,
                                                  ),
                                                )
                                              ],
                                            )

                                          ],
                                        ),
                                      ],
                                    )
                                ),
                                SizedBox(height: 10.0,),
                              ],
                            );
                          }):Container(
                        child: Center(
                         child: Text("No new Notifications",style: TextStyle(fontSize: 25,color: Colors.blue),)
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });

  }
}
