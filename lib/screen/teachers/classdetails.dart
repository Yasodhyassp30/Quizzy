import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud/screen/common/groupmsg.dart';
import 'package:cloud/screen/common/messaging.dart';
import 'package:cloud/screen/student/materialupload.dart';
import 'package:cloud/screen/teachers/addstudent.dart';
import 'package:cloud/screen/teachers/studentsdetails.dart';
import 'package:cloud/screen/teachers/teachersLM.dart';
import 'package:cloud/screen/teachers/teachershome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class classroomdetails extends StatefulWidget {
  final classdetails;
  const classroomdetails({Key? key,this.classdetails}) : super(key: key);

  @override
  _classroomdetailsState createState() => _classroomdetailsState();
}

class _classroomdetailsState extends State<classroomdetails> {
  List studentdata=[];
  FirebaseFirestore store =FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(future:store.collection('userdata').where('uid',whereIn: widget.classdetails['students']).get(),builder: (context,snapshot){
      if(snapshot.connectionState==ConnectionState.waiting){
        return loadfadingcube();
      }else{
        studentdata=snapshot.data!.docs;
        return Scaffold(
            body: ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
                minWidth: MediaQuery.of(context).size.width,
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
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),


                            ),
                            child: Row(
                              children: [
                                IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(
                                  Icons.arrow_back,size: 30,color: Colors.white,
                                )),
                                SizedBox(width: 10.0,),
                                Text(widget.classdetails['title'],style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text('Members (${widget.classdetails['students'].length})',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.blue[800])),),
                          SizedBox(height: 10,),
                          Container(
                            height: MediaQuery.of(context).size.height*0.65,
                            child: ListView.builder(itemCount:studentdata.length,
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
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: MediaQuery.of(context).size.width*0.15,
                                                        width: MediaQuery.of(context).size.width*0.15,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.white,
                                                            image: DecorationImage(
                                                                image: (!studentdata[i].data().containsKey('pic'))?AssetImage('assets/studentavatar.png'):NetworkImage(studentdata[i].get('pic')) as ImageProvider,
                                                                fit: BoxFit.fill
                                                            )
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.0,),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            width:MediaQuery.of(context).size.width*0.35,
                                                            height: MediaQuery.of(context).size.height*0.05,
                                                            child: Text(studentdata[i].get('firstname')+" "+studentdata[i].get('lastname'),style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white,overflow:TextOverflow.ellipsis)),),
                                                          ),
                                                        ],
                                                      ),
                                                      IconButton(onPressed: (){
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => messagingprivate(reciver: studentdata[i],)),
                                                        );

                                                      }, icon: Icon(
                                                        Icons.messenger,size: 30,color: Colors.lightBlue[100],
                                                      )),
                                                      IconButton(onPressed: ()async{
                                                        var wait =await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => studentdetails(details: studentdata[i],id: widget.classdetails.id,)),
                                                        );
                                                        setState(() {

                                                        });
                                                      }, icon: Icon(
                                                        Icons.more_horiz,size: 30,color: Colors.lightBlue[100],
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
                                }),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => groupmsging(classroomid:widget.classdetails.id,classname: widget.classdetails['title'])),
                                    );
                                  },
                                  child: Icon(Icons.messenger, color: Colors.white),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(20),
                                    primary: Colors.blue[300],
                                    onPrimary: Colors.yellow,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>lmsteachers(classdetails: widget.classdetails,)));
                                  },
                                  child: Icon(Icons.drive_file_move, color: Colors.white),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(20),
                                    primary: Colors.blue,
                                    onPrimary: Colors.red,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async{
                                   await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => studentadd(classroomid: widget.classdetails,)),
                                    );
                                   setState(() {

                                   });

                                  },
                                  child: Icon(Icons.add, color: Colors.white),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(20),
                                    primary: Colors.blue[700],
                                    onPrimary: Colors.black,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: ()async {
                                    await showDialog(context: context, builder: (BuildContext context) {
                                      return  AlertDialog(
                                        title: Text("Alert"),
                                        content: Text(
                                            'All group details will be removed do you want to proceed ?'
                                        ),
                                        actions: [
                                          Container(
                                              padding: EdgeInsets.all(10),
                                              child:Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  TextButton(
                                                    onPressed: ()async{
                                                      await store.collection('classrooms').doc(widget.classdetails.id).delete();
                                                      QuerySnapshot quizzes =await store.collection('Quizzes').where('classroomid',isEqualTo: widget.classdetails.id).get();
                                                      List ids =[];
                                                      quizzes.docs.forEach((element) {
                                                        ids.add(element.id);
                                                      });
                                                      ids.forEach((element) async{
                                                        await store.collection('Quizzes').doc(element).delete();
                                                        await store.collection('assements').doc(element).delete();
                                                        await store.collection('answers').doc(element).delete();
                                                        await store.collection('stats').doc(element).delete();
                                                        await store.collection('studentquiz').doc(element).delete();
                                                        await store.collection('messages').doc(element).delete();
                                                      });
                                                      Navigator.pushAndRemoveUntil(context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  teachershome()), (
                                                              route) => false);
                                                    },
                                                    child: Text('Confirm',style: TextStyle(fontSize: 18),),
                                                  ),
                                                  TextButton(
                                                    onPressed: ()async{
                                                     


                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Cancel',style: TextStyle(fontSize: 18)),
                                                  )
                                                ],
                                              )
                                          )
                                        ],
                                      );
                                    });

                                  },
                                  child: Icon(Icons.delete, color: Colors.white),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(20),
                                    primary: Colors.blue[900],
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
