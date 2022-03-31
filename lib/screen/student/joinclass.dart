
import 'package:cloud/screen/student/studentnotifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class joinclass extends StatefulWidget {
  const joinclass({Key? key}) : super(key: key);

  @override
  _joinclassState createState() => _joinclassState();
}

class _joinclassState extends State<joinclass> {
  TextEditingController code =TextEditingController();
  bool searched =false;
  List classdetails =[];
  String requestid= "";
  FirebaseFirestore store =FirebaseFirestore.instance;
  FirebaseAuth _auth =FirebaseAuth.instance;
  final snackBar = SnackBar(
    content: const Text('Request Send'),
    action: SnackBarAction(
      label: 'close',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height
        ),
        child: Container(
          color: Colors.lightBlue[100],
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(25),
                    height: MediaQuery.of(context).size.height*0.1,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),


                    ),
                    child: Row(
                      children: [
                        IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(
                          Icons.arrow_back,size: 30,color: Colors.white,
                        )),
                        SizedBox(width: 10.0,),
                        Text('Join Class',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25,color: Colors.white)),),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: code,
                          decoration: InputDecoration(
                              border:OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Class Code",
                              hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 18.0)
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [Expanded(child: ElevatedButton.icon(onPressed: ()async{
                            classdetails=[];
                            requestid=code.text.trim();
                            DocumentSnapshot result =await store.collection('classrooms').doc(code.text.trim()).get();
                            setState(() {
                              searched=true;
                            });
                            classdetails.add(result.data());

                          },
                              icon: Icon(Icons.search), 
                              label: Text('Search',style: TextStyle(fontSize: 18,color: Colors.white),),style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16)
                            ),))
                          ],
                        ),

                        SizedBox(height: 10,),
                        (searched)?Column(
                          children: [
                            SizedBox(height: 10.0,),
                            Row(children: [
                              Container(
                                width: MediaQuery.of(context).size.width*0.6,
                                child:Text('Results',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25,color: Colors.blueAccent)),),
                              ),
                              Expanded(child: SizedBox()),
                              Container(
                                width: MediaQuery.of(context).size.width*0.3,
                                child:IconButton(
                                  onPressed: (){
                                    setState(() {
                                      searched=false;
                                      code.clear();

                                    });
                                  },
                                  icon: Icon(Icons.clear),
                                )
                              )
                            ],),
                            SizedBox(height: 10.0,),
                            Container(
                              width: MediaQuery.of(context).size.width*0.9,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10,),
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.8,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(classdetails[0]['title'],overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.blue,fontSize: 18),),
                                        ),
                                        SizedBox(height: 10,),
                                        FutureBuilder<DocumentSnapshot>(future: store.collection('userdata').doc(classdetails[0]['teacher']).get(),builder: (context, snapshotteach){
                                          if(snapshotteach.connectionState==ConnectionState.waiting){
                                            return Text('');
                                          }else{
                                            return Text('Teacher : ${snapshotteach.data!.get('firstname')+" "+snapshotteach.data!.get('lastname')}',overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey,fontSize: 15),);
                                          }

                                        }),
                                        SizedBox(height: 10,),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      (classdetails[0]['students'].contains(_auth.currentUser!.uid))?Text("Already Member"):(classdetails[0]['invited'].contains(_auth.currentUser!.uid))?
                                      Expanded(child: ElevatedButton(
                                        onPressed: ()async{
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => notifcationsstudents()),
                                          );
                                          setState(() {

                                          });
                                        },
                                        child: Text('Go to Invitations'),
                                      )):(classdetails[0]['requested'].contains(_auth.currentUser!.uid))?Text("Already Requested"):
                                      Expanded(child: ElevatedButton(
                                        onPressed: ()async{
                                          await store.collection('classrooms').doc(requestid).set({
                                            'requested':FieldValue.arrayUnion([
                                              _auth.currentUser!.uid
                                            ])
                                          },SetOptions(merge: true));
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          setState(() {
                                            searched=false;
                                          });
                                        },
                                        child: Text('Send Request'),
                                      ))
                                    ],
                                  )

                                ],
                              ) ,
                            )
                          ],
                        ):Container()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
