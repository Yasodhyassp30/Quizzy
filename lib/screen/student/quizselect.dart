import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud/screen/student/attemptquiz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class selectquizzes extends StatefulWidget {
  const selectquizzes({Key? key}) : super(key: key);

  @override
  State<selectquizzes> createState() => _selectquizzesState();
}

class _selectquizzesState extends State<selectquizzes> {
  String ? dropdown1;
  FirebaseFirestore store = FirebaseFirestore.instance;
  List classes = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading=false;

  getdata() async {
    QuerySnapshot snaphotdetails = await store.collection('classrooms').where(
        'students', arrayContains: _auth.currentUser!.uid).get();
    setState(() {
      classes = snaphotdetails.docs;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(loading){
      return loadfadingcube();
    }else{
      return Scaffold(
        body: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery
                .of(context)
                .size
                .width,
            minHeight: MediaQuery
                .of(context)
                .size
                .height,
          ),
          child: Container(
            color: Colors.lightBlue[100],
            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.blue[500],
                          borderRadius: BorderRadius.only(bottomRight: Radius
                              .circular(100)),


                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10.0,),
                            Text('Assements', style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 20, color: Colors.white)),),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.all(10),

                        child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              children: [
                                Expanded(child: DropdownButton<String>(

                                  hint: Text('Select Class', style: TextStyle(
                                      color: Colors.blueAccent
                                  ),),

                                  value: dropdown1,
                                  underline: Container(
                                    height: 2,
                                    color: Colors.blueAccent,
                                  ),
                                  onChanged: (String? values) {
                                    dropdown1 = values;
                                    setState(() {

                                    });
                                  },
                                  items: classes.map<DropdownMenuItem<String>>((
                                      e) {
                                    return DropdownMenuItem(
                                      child: Text('${e.get('title')}'),
                                      value: e.id,);
                                  }).toList(),
                                ),)
                              ],
                            )
                        ),
                      ),
                      SizedBox(height: 10,),

                      Container(
                          padding: EdgeInsets.all(16),
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.7,
                          child: (dropdown1 != null) ? FutureBuilder<
                              QuerySnapshot>(future: store.collection('studentquiz')
                              .where('classroomid', isEqualTo: dropdown1)
                              .get(), builder: (context, snapshot) {
                            List test = [];
                            if (snapshot.data != null &&
                                snapshot.connectionState !=
                                    ConnectionState.waiting) {

                              snapshot.data!.docs.forEach((element) {
                                if(!element.get('submitted').contains(_auth.currentUser!.uid)
                                    && DateTime.parse(element.get('end')).isAfter(DateTime.now()) && DateTime.parse(element.get('start')).isBefore(DateTime.now())){
                                  test.add(element);
                                }
                              });

                            }
                            return ListView.builder(itemCount: test.length,
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.5,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      test[i].get('title'),
                                                      style: TextStyle(
                                                          color: Colors.lightBlue,
                                                          fontSize: 20),
                                                    ),
                                                    Text(test[i].get('format')),
                                                    Text('Start : ${DateFormat(
                                                        'dd/MM/yyyy hh:mm ')
                                                        .format(DateTime.parse(
                                                        test[i].get('start')))}',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .deepPurple),),
                                                    Text('End   : ${DateFormat(
                                                        'dd/MM/yyyy hh:mm ')
                                                        .format(DateTime.parse(
                                                        test[i].get('end')))}',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .blueAccent),)
                                                  ],
                                                )
                                            ),
                                            Expanded(child: SizedBox()),
                                            Container(
                                              child: ElevatedButton(
                                                onPressed: ()async {
                                                  FirebaseFirestore store =FirebaseFirestore.instance;
                                                  await store.collection('studentquiz').doc(test[i]['quizid']).update({
                                                    'submitted':FieldValue.arrayUnion([_auth.currentUser!.uid])
                                                  });
                                                  await store.collection('Quizzes').doc(test[i]['quizid']).update({
                                                    'submitted':FieldValue.arrayUnion([_auth.currentUser!.uid])
                                                  });
                                                  Map quizdata = test[i]
                                                      .data() as Map;
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>attemptquiz(quizdetails: quizdata,)));

                                                },
                                                child: Text('Attempt'),
                                              ),
                                            ),

                                          ],
                                        ),
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                10)
                                        ),
                                      ),
                                      SizedBox(height: 10,)
                                    ],
                                  );
                                });
                          }) : Container()
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
