import 'package:cloud/screen/teachers/classdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../service/messaging.dart';

class groupmsging extends StatefulWidget {
  final classroomid,classname;
  const groupmsging({Key? key,this.classroomid,this.classname}) : super(key: key);

  @override
  _groupmsgingState createState() => _groupmsgingState();
}

class _groupmsgingState extends State<groupmsging> {
  FirebaseFirestore store =FirebaseFirestore.instance;
  FirebaseAuth _auth =FirebaseAuth.instance;
  var con = ScrollController();
  TextEditingController msg =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Container(
          color: Colors.lightBlue[100],
          child: SafeArea(
            child:SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height*0.96-MediaQuery.of(context).viewInsets.bottom,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      child:  Container(
                        height: MediaQuery.of(context).size.height*0.1,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.blue,
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            IconButton(onPressed: (){Navigator.pop(context);} , icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,)),
                            SizedBox(width: 10,),
                            Text(widget.classname,style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25,color: Colors.white)),),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top:MediaQuery.of(context).size.height*0.1,
                      child: StreamBuilder<DocumentSnapshot>(stream: store.collection('messages').doc(widget.classroomid).snapshots(),builder: (context,snapshot){

                        List msgs =[];
                        if(snapshot.connectionState==ConnectionState.waiting){
                        }else {
                         if(snapshot.data?.data()!=null){
                           msgs=snapshot.data!.get('messages');
                         }
                        }
                        return Container(
                          padding: EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height*0.7-MediaQuery.of(context).viewInsets.bottom,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(itemCount:msgs.length ,
                              controller: con,
                              itemBuilder: (context,index){
                                return Align(
                                    alignment:(msgs[index]['sender']==_auth.currentUser!.uid ? Alignment.topRight : Alignment.topLeft),
                                    child:Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ((index==0&&msgs[index]['sender']!=_auth.currentUser!.uid)||(index>0&&msgs[index]['sender']!=_auth.currentUser!.uid&&msgs[index]['sender']!=msgs[index-1]['sender']))?
                                            Text(msgs[index]['name'],style: TextStyle(fontSize: 10),):Text("",style: TextStyle(fontSize: 8),),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context).size.width*0.4
                                          ),
                                          child:  Container(
                                            child: Text(msgs[index]['message'],style: TextStyle(fontSize: 15.0,color: Colors.white),),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: (msgs[index]['sender']==_auth.currentUser!.uid ? Colors.blue[500]:Colors.lightBlue[400] ),
                                            ),
                                            padding: EdgeInsets.all(10),

                                          ),
                                        ),

                                        SizedBox(height: 5,),
                                      ],
                                    )

                                );

                              }),
                        );

                      }),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width*0.9,
                              padding: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height*0.1,

                              child:TextField(
                                controller: msg,
                                decoration: InputDecoration(
                                    border:OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: "Message",
                                    hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 18.0),
                                    suffixIcon: InkWell(
                                      child: IconButton(
                                        onPressed: ()async{
                                          messaging m1= messaging(uid: _auth.currentUser!.uid);
                                          m1.groupmsg(widget.classroomid, msg.text.trim(), _auth.currentUser!.displayName!);
                                          msg.clear();
                                          con.jumpTo(con.position.maxScrollExtent);

                                        },
                                        icon: Icon(Icons.send),
                                      ),
                                    )
                                ),
                              )
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
      ),
    );
  }
}
