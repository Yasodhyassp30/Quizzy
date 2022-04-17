import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../loadingscreens/loadingscreen.dart';
import 'groupmsg.dart';
import 'messaging.dart';

class chatstudents extends StatefulWidget {
  const chatstudents({Key? key}) : super(key: key);

  @override
  _chatstudentsState createState() => _chatstudentsState();
}

class _chatstudentsState extends State<chatstudents> {
  bool private=true,groups=false;
  FirebaseAuth _auth =FirebaseAuth.instance;
  FirebaseFirestore store =FirebaseFirestore.instance;
  Map data={};
  @override
  Widget build(BuildContext context) {

    if(private){
      return StreamBuilder<DocumentSnapshot>(stream: store.collection('messages').doc(_auth.currentUser!.uid).snapshots(),builder: (context, snapshot) {
        List order=[];
        List profiles =[];
        if(snapshot.connectionState==ConnectionState.waiting){
          return loadfadingcube();
        }else{
          if(snapshot.data?.data()!=null){
            data=snapshot.data!.data() as Map;

            data.forEach((key, value) {
              profiles.add(key);
              Map map =new Map();
              map['reciver']=key;
              map['messages']=value;
              order.add(map);
            });
            order.sort((a,b){
              var date1=a['messages'][a['messages'].length-1]['time'];
              var date2=b['messages'][b['messages'].length-1]['time'];
              return date2.compareTo(date1);
            });
          }
          return Scaffold(
            body: ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: SafeArea(
                child:Container(
                  color: Colors.lightBlue[100],
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
                            Text('Conversations',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(onPressed: (){
                            setState(() {
                              groups=false;
                              private=true;
                            });
                          }, child: Text('Private',style: TextStyle(
                              color: (private)?Colors.blue:Colors.grey,fontSize: 20
                          ),)),
                          TextButton(onPressed: (){
                            setState(() {
                              groups=true;
                              private=false;
                            });
                          }, child: Text('Group',style: TextStyle(
                              color: (groups)?Colors.blue:Colors.grey,fontSize: 20
                          ),))
                        ],
                      ),
                      (order.length>0)?Container(
                          height: MediaQuery.of(context).size.height*0.7,
                          width: MediaQuery.of(context).size.width*0.9,
                          padding: EdgeInsets.all(20),

                          child: FutureBuilder<QuerySnapshot>(future:store.collection('userdata').where('uid',whereIn: profiles).get(),builder: (context,snap){
                            if(snap.connectionState==ConnectionState.waiting){
                              return Container();
                            }else{
                              List details =snap.data!.docs;
                              return ListView.builder(itemCount:profiles.length,itemBuilder: (context, index){
                                var profile={};
                                for(int i=0;i<details.length;i++){
                                  if(details[i]['uid']==profiles[index]){
                                    profile=details[i].data();
                                    break;
                                  }
                                }
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
                                                Row(
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
                                                    SizedBox(width: 10.0,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width:MediaQuery.of(context).size.width*0.4,
                                                          height: MediaQuery.of(context).size.height*0.05,
                                                          child: Text(profile['firstname']+" "+profile['lastname'],style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white,overflow:TextOverflow.ellipsis)),),
                                                        ),
                                                      ],
                                                    ),
                                                    IconButton(onPressed: (){
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => messagingprivate(reciver:profile,)),
                                                      );

                                                    }, icon: Icon(
                                                      Icons.messenger,size: 30,color: Colors.lightBlue[100],
                                                    )),

                                                  ],
                                                ),

                                              ],
                                            ),
                                          ],
                                        )
                                    ),
                                    SizedBox(height: 10,),
                                  ],
                                );
                              });
                            }

                          })

                      ):Container()
                    ],
                  ),
                ),
              ),
            ),
          );
        }

      });
    }else{
      return FutureBuilder<QuerySnapshot>(future: store.collection('classrooms').where('students',arrayContains:_auth.currentUser!.uid).get(),builder: (context,classdetails){
        if(classdetails.connectionState==ConnectionState.waiting){
          return loadfadingcube();

        }else{
          List id=[];
          List classes =[];
          try{
            classes=classdetails.data!.docs;
            classes.forEach((element) {
              id.add(element.id);
            });
          }catch(e){
            classes=[];
          }
          return StreamBuilder<QuerySnapshot>(stream: store.collection('messages').where(FieldPath.documentId,whereIn: id).snapshots(),builder: (context, snapshot) {
            List classorder=[];
            List classdata=[];
            if(snapshot.connectionState==ConnectionState.waiting){
              return loadfadingcube();
            }else{
              classdata=snapshot.data!.docs as List;
              classorder =[];
              if(classdata.length>0){
                classdata.sort((a,b){
                  return b['messages'][b['messages'].length-1]['time'].compareTo(a['messages'][a['messages'].length-1]['time']);
                });
              }
              classdata.forEach((element) {
                classorder.add(element.id);
              });
              return Scaffold(
                body: ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: SafeArea(
                    child:Container(
                      color: Colors.lightBlue[100],
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(25),
                            height: MediaQuery.of(context).size.height*0.1,
                            decoration: BoxDecoration(
                              color: Colors.blue[500],
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),


                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 10.0,),
                                Text('Conversations',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(onPressed: (){
                                setState(() {
                                  private=true;
                                  groups=false;
                                });
                              }, child: Text('Private',style: TextStyle(
                                  color: (private)?Colors.blue:Colors.grey,fontSize: 20
                              ),)),
                              TextButton(onPressed: (){
                                setState(() {
                                  groups=true;
                                  private=false;
                                });
                              }, child: Text('Group',style: TextStyle(
                                  color: (groups)?Colors.blue:Colors.grey,fontSize: 20
                              ),))
                            ],
                          ),
                          Container(
                              height: MediaQuery.of(context).size.height*0.7,
                              width: MediaQuery.of(context).size.width*0.9,
                              padding: EdgeInsets.all(20),

                              child: FutureBuilder<QuerySnapshot>(future:store.collection('classrooms').where('students',arrayContains: _auth.currentUser!.uid).get(),builder: (context,snap){
                                if(snap.connectionState==ConnectionState.waiting){
                                  return Container();
                                }else{
                                  List details =snap.data!.docs;
                                  return ListView.builder(itemCount:classorder.length,itemBuilder: (context, index){
                                    var profile={};
                                    for(int i=0;i<details.length;i++){
                                      if(details[i].id==classorder[index]){
                                        profile=details[i].data();
                                        break;
                                      }
                                    }
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
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: 80,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.white,
                                                              image: DecorationImage(
                                                                  image: AssetImage('assets/groupchat.png'),
                                                                  fit: BoxFit.contain
                                                              )
                                                          ),
                                                        ),
                                                        SizedBox(width: 10.0,),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              width:MediaQuery.of(context).size.width*0.4,
                                                              height: MediaQuery.of(context).size.height*0.05,
                                                              child: Text(profile['title'],style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white,overflow:TextOverflow.ellipsis)),),
                                                            ),
                                                          ],
                                                        ),
                                                        IconButton(onPressed: (){
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => groupmsging(classroomid:classorder[index],classname: profile['title'],)),
                                                          );

                                                        }, icon: Icon(
                                                          Icons.messenger,size: 30,color: Colors.lightBlue[100],
                                                        )),

                                                      ],
                                                    ),

                                                  ],
                                                ),
                                              ],
                                            )
                                        ),
                                        SizedBox(height: 10,),
                                      ],
                                    );
                                  });
                                }

                              })

                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

          });

        }

      });

    }
  }
}
