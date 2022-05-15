import 'package:cloud/screen/teachers/stat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class quizlist_stat extends StatefulWidget {
  final id,classize;
  const quizlist_stat({Key? key,this.id,this.classize}) : super(key: key);

  @override
  State<quizlist_stat> createState() => _quizlist_statState();
}

class _quizlist_statState extends State<quizlist_stat> {
  FirebaseFirestore store =FirebaseFirestore.instance;
  FirebaseAuth _auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,)),
                    SizedBox(width: 10.0,),
                    Text('Select Quiz',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Expanded(child: Container(
                padding: EdgeInsets.all(16),
          child: FutureBuilder<QuerySnapshot>(future:store.collection('Quizzes').where('classroomid',isEqualTo: widget.id).get() ,builder: (context, snapshot) {

            List test =[];
            if(snapshot.data!=null&&snapshot.connectionState!=ConnectionState.waiting){
              test=snapshot.data!.docs;
            }
            return ListView.builder(itemCount: test.length,itemBuilder: (context,i){
              return Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  test[i].get('title'),style: TextStyle(color: Colors.lightBlue,fontSize: 20),
                                ),
                                Text(test[i].get('format')),
                                Text('Start : ${DateFormat('dd/MM/yyyy hh:mm ').format(DateTime.parse(test[i].get('start')))}',style: TextStyle(color: Colors.deepPurple),),
                                Text('End   : ${DateFormat('dd/MM/yyyy hh:mm ').format(DateTime.parse(test[i].get('end')))}',style: TextStyle(color: Colors.blueAccent),)
                              ],
                            )
                        ),
                        Expanded(child:SizedBox()),
                        Container(
                          child: TextButton.icon(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>stat_screen(quizdetails: test[i],total: widget.classize,)));
                            },
                            icon:Icon(Icons.insert_chart),
                            label:Text('Stats'),
                          ),
                        ),

                      ],
                    ),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  SizedBox(height: 10,)
                ],
              );

            });
          }),
              ))
            ],
          ),

        ),
      ),
    );
  }
}
