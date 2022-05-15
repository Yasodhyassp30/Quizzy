import 'package:cloud/screen/teachers/quizlist_stats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class stats_page extends StatefulWidget {
  const stats_page({Key? key}) : super(key: key);

  @override
  State<stats_page> createState() => _stats_pageState();
}

class _stats_pageState extends State<stats_page> {
  FirebaseAuth _auth =FirebaseAuth.instance;
  FirebaseFirestore store =FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.lightBlue[100],
      child: SafeArea(
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
                  Text('Quizzy Statistics',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                ],
              ),
            ),
            SizedBox(height: 20,),

            Expanded(child: Container(
              padding: EdgeInsets.all(16),
              child: FutureBuilder<QuerySnapshot>(future: store.collection('classrooms').where('teacher',isEqualTo: _auth.currentUser!.uid).get(),builder:(context,snap){
                if(snap.connectionState!=ConnectionState.waiting){
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
                                          child: Text(classdata[i]['title'],style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white,overflow:TextOverflow.ellipsis)),),
                                        ),
                                        Text('Students : ${classdata[i]['students'].length}',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 15,color: Colors.white)),),
                                      ],
                                    ),
                                    Expanded(child: SizedBox()),
                                    IconButton(onPressed: ()async{
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>quizlist_stat(id: classdata[i].id,classize: classdata[i]['students'].length,)));
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
                }else{
                  return Container();
                }
              })
            ))
          ],
        ),
      ),
    );
  }
}
