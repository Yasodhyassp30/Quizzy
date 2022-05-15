import 'package:cloud/screen/student/studentLMS.dart';
import 'package:cloud/screen/student/userdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../loadingscreens/loadingscreen.dart';
import '../common/groupmsg.dart';
import '../common/messaging.dart';

class studentclassdetails extends StatefulWidget {
  final classdetails;
  const studentclassdetails({Key? key,this.classdetails}) : super(key: key);

  @override
  _studentclassdetailsState createState() => _studentclassdetailsState();
}

class _studentclassdetailsState extends State<studentclassdetails> {
  List studentdata = [];
  FirebaseFirestore store = FirebaseFirestore.instance;
  FirebaseAuth _auth =FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: store.collection('userdata').where(
            'uid', whereIn: widget.classdetails['students']).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadfadingcube();
          } else {
            studentdata = snapshot.data!.docs;
            return Scaffold(

                body: ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: MediaQuery
                        .of(context)
                        .size
                        .height,
                    minWidth: MediaQuery
                        .of(context)
                        .size
                        .width,
                  ),
                  child: SafeArea(
                    child: Container(
                      color: Colors.lightBlue[100],
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  color: Colors.blue[500],
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(100)),


                                ),
                                child: Row(
                                  children: [
                                    IconButton(onPressed: () {
                                      Navigator.pop(context);
                                    }, icon: Icon(
                                      Icons.arrow_back, size: 30,
                                      color: Colors.white,
                                    )),
                                    SizedBox(width: 10.0,),
                                    Text(widget.classdetails['title'],
                                      style: GoogleFonts.lato(
                                          textStyle: TextStyle(fontSize: 20,
                                              color: Colors.white)),),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text('Members (${widget.classdetails['students']
                                  .length+1})', style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 20, color: Colors.blue[800])),),
                              SizedBox(height: 10,),
                              FutureBuilder<DocumentSnapshot>(future:store.collection('userdata').doc(widget.classdetails['teacher']).get() ,builder: (context,snapshotdata){
                                Map ownerdata={};
                                if(snapshotdata.connectionState==ConnectionState.waiting){
                                  return Container();
                                }else{
                                  ownerdata=snapshotdata.data!.data() as Map;
                                  return Column(
                                    children: [

                                      Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.9,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.lightBlue[800],
                                              borderRadius: BorderRadius
                                                  .circular(15)

                                          ),
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: MediaQuery.of(context).size.width*0.15,
                                                        width: MediaQuery.of(context).size.width*0.15,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape
                                                                .circle,
                                                            color: Colors
                                                                .white,
                                                            image: DecorationImage(
                                                                image: (!ownerdata.containsKey('pic'))?AssetImage('assets/studentavatar.png'):NetworkImage(ownerdata['pic']) as ImageProvider,
                                                                fit: BoxFit
                                                                    .cover
                                                            )
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(context).size.width * 0.35,
                                                            height: MediaQuery.of(context).size.height * 0.1,
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  ownerdata['firstname'] +
                                                                      " " +
                                                                      ownerdata['lastname'],
                                                                  style: GoogleFonts
                                                                      .lato(
                                                                      textStyle: TextStyle(
                                                                          fontSize: 20,
                                                                          color: Colors
                                                                              .white,
                                                                          overflow: TextOverflow
                                                                              .ellipsis)),),
                                                                Text(
                                                                  '(Owner)',
                                                                  style: GoogleFonts
                                                                      .lato(
                                                                      textStyle: TextStyle(
                                                                          fontSize: 15,
                                                                          color: Colors
                                                                              .white,
                                                                          overflow: TextOverflow
                                                                              .ellipsis)),),
                                                              ],
                                                            )
                                                          ),
                                                        ],
                                                      ),
                                                      IconButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => messagingprivate(reciver: ownerdata,)),
                                                            );

                                                          }, icon: Icon(
                                                        Icons.messenger,
                                                        size: 30,
                                                        color: Colors
                                                            .lightBlue[100],
                                                      )),

                                                      IconButton(
                                                          onPressed: ()async {
                                                            var wait =await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => userdetails(details: snapshotdata.data,id: widget.classdetails.id,)),
                                                            );
                                                            setState(() {

                                                            });

                                                          }, icon: Icon(
                                                        Icons.more_horiz,
                                                        size: 30,
                                                        color: Colors
                                                            .lightBlue[100],
                                                      ))
                                                    ],
                                                  ),

                                                ],
                                              ),
                                            ],
                                          )
                                      ),
                                      SizedBox(height: 10.0,),
                                    ],
                                  );
                                }

                              }),
                              Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.5,
                                child: ListView.builder(
                                    itemCount: studentdata.length,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemBuilder: (context, i) {
                                      return Column(
                                        children: [

                                          Container(
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.9,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.lightBlue[800],
                                                  borderRadius: BorderRadius
                                                      .circular(15)

                                              ),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: MediaQuery.of(context).size.width*0.15,
                                                            width: MediaQuery.of(context).size.width*0.15,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .white,
                                                                image: DecorationImage(
                                                                    image: (!studentdata[i].data().containsKey('pic'))?AssetImage('assets/studentavatar.png'):NetworkImage(studentdata[i].get('pic')) as ImageProvider,
                                                                    fit: BoxFit
                                                                        .cover
                                                                )
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10.0,),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Container(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width *
                                                                    0.35,
                                                                height: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .height *
                                                                    0.05,
                                                                child: Text(
                                                                  studentdata[i]
                                                                      .get(
                                                                      'firstname') +
                                                                      " " +
                                                                      studentdata[i]
                                                                          .get(
                                                                          'lastname'),
                                                                  style: GoogleFonts
                                                                      .lato(
                                                                      textStyle: TextStyle(
                                                                          fontSize: 20,
                                                                          color: Colors
                                                                              .white,
                                                                          overflow: TextOverflow
                                                                              .ellipsis)),),
                                                              ),
                                                              (studentdata[i]['uid']==_auth.currentUser!.uid)?Text(
                                                               '(You)',
                                                                style: GoogleFonts
                                                                    .lato(
                                                                    textStyle: TextStyle(
                                                                        fontSize: 20,
                                                                        color: Colors
                                                                            .white,
                                                                        overflow: TextOverflow
                                                                            .ellipsis)),):Container()
                                                            ],
                                                          ),
                                                          (studentdata[i]['uid']!=_auth.currentUser!.uid)?
                                                          Row(
                                                            children: [
                                                              IconButton(
                                                                  onPressed: () {
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(builder: (context) => messagingprivate(reciver: studentdata[i],)),
                                                                    );
                                                                  }, icon: Icon(
                                                                Icons.messenger,
                                                                size: 30,
                                                                color: Colors
                                                                    .lightBlue[100],
                                                              )),
                                                              IconButton(
                                                                  onPressed: () async{
                                                                    var wait =await Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(builder: (context) => userdetails(details: studentdata[i],id: widget.classdetails.id,)),
                                                                    );
                                                                    setState(() {

                                                                    });
                                                                  }, icon: Icon(
                                                                Icons.more_horiz,
                                                                size: 30,
                                                                color: Colors
                                                                    .lightBlue[100],
                                                              ))
                                                            ],
                                                          ):Container()
                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                                ],
                                              )
                                          ),
                                          SizedBox(height: 10.0,),
                                        ],
                                      );
                                    }),
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => groupmsging(classroomid:widget.classdetails.id,classname: widget.classdetails['title'],)),
                                        );
                                      },
                                      child: Icon(
                                          Icons.messenger, color: Colors.white),
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(20),
                                        primary: Colors.lightBlue[300],
                                        onPrimary: Colors.yellow,
                                      ),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => lmsstudents(classdetails: widget.classdetails,)));
                                        }, child: Icon(
                                      Icons.my_library_books_outlined,
                                      size: 30,

                                    ),
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(20),
                                        primary: Colors.lightBlue[600],
                                        onPrimary: Colors.white,
                                      ),),

                                    ElevatedButton(
                                      onPressed: () {},
                                      child: Icon(Icons.more_horiz,
                                          color: Colors.white),
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(20),
                                        primary: Colors.lightBlue[900],
                                        onPrimary: Colors.red,
                                      ),
                                    ),

                                  ],
                                ),
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
