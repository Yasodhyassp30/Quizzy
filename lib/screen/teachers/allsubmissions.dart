import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud/screen/teachers/evaluateassements.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class allsubmissions extends StatefulWidget {
  final submissions,quizid,noofquestions,quizdetails;
  const allsubmissions({Key? key,this.submissions,this.quizid,this.noofquestions,this.quizdetails}) : super(key: key);

  @override
  State<allsubmissions> createState() => _allsubmissionsState();
}

class _allsubmissionsState extends State<allsubmissions> {
  List submissions =[];
  FirebaseFirestore store =FirebaseFirestore.instance;
  Map answerdetails={};

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(future:store.collection('userdata').where('uid',whereIn: widget.submissions).get(),builder: (context, snapshot) {
      if(snapshot.connectionState==ConnectionState.waiting){
        return loadfadingcube();
      }else{
        if(snapshot.data!=null) {
          submissions = snapshot.data!.docs;
        }
      }
      return Scaffold(
        backgroundColor: Colors.lightBlue[100],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[500],
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),


                  ),
                  child: Row(
                    children: [
                      IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,)),
                      SizedBox(width: 10.0,),
                      Text('Submissions',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                (widget.quizdetails['evaluation']==1)?
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(children: [
                    Expanded(child: ElevatedButton.icon(
                      icon: Icon(Icons.check),
                      onPressed: ()async{
                        try{
                          HttpsCallable eval = FirebaseFunctions.instanceFor(region: 'asia-southeast1').httpsCallable('evaluation');
                          await eval({'quizid':widget.quizid});
                        }catch(e){
                          print(e.toString());
                        }

                      },
                      label: Text("Evaluate All"),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                        primary: Colors.blueAccent[600]
                      ),
                    ))
                  ],),
                ):Container(),
                SizedBox(height: 10,),
                Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    height: MediaQuery.of(context).size.height*0.7,
                    child: StreamBuilder<DocumentSnapshot>(stream:store.collection('answers').doc(widget.quizid).snapshots(),builder: (context, snap) {
                        if(snap.connectionState!=ConnectionState.waiting||snap.data?.data()!=null){
                          answerdetails =snap.data!.data() as Map;
                        }
                      return ListView.builder(itemCount: submissions.length,itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width*0.9,
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width*0.9,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[800],
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width:MediaQuery.of(context).size.width*0.5,
                                            child: Text('${submissions[index].get('firstname')} ${submissions[index].get('lastname')}',style: TextStyle(fontSize: 18,color: Colors.white),overflow: TextOverflow.ellipsis,),
                                          ),
                                          ElevatedButton(onPressed: ()async{
                                            var wait = await Navigator.push(context, MaterialPageRoute(builder: (context)=>evaluatequiz(answers: answerdetails['${submissions[index].get('uid')}'],quizdetails: widget.quizdetails,stdid: submissions[index].get('uid'),)));
                                            setState(() {

                                            });
                                          }, child: Text('View'))


                                        ],
                                      ),
                                      SizedBox(height: 10,),
                                      (answerdetails.containsKey('${submissions[index].get('uid')}'))?
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          (answerdetails['${submissions[index].get('uid')}'].containsKey('marks'))?
                                          Text("Answered : ${answerdetails['${submissions[index].get('uid')}']!.length-1} / ${widget.noofquestions}",style: TextStyle(fontSize: 15,color: Colors.white),):
                                          Text("Answered : ${answerdetails['${submissions[index].get('uid')}']!.length} / ${widget.noofquestions}",style: TextStyle(fontSize: 15,color: Colors.white),),
                                          (answerdetails['${submissions[index].get('uid')}'].containsKey('marks'))?
                                          Row(
                                            children: [
                                              Text("Marked : ${answerdetails['${submissions[index].get('uid')}']['marks']}",style: TextStyle(fontSize: 15,color: Colors.white),),
                                              SizedBox(width: 5,),
                                              Icon(Icons.check,size: 20,color: Colors.green,)
                                            ],
                                          )
                                              :
                                          Row(
                                            children: [
                                              Text("Marked : Not Marked",style: TextStyle(fontSize: 15,color: Colors.white),),
                                              SizedBox(width: 5,),
                                              Icon(Icons.clear,size: 20,color: Colors.redAccent,)
                                            ],
                                          ),

                                        ],
                                      )
                                          :
                                      Text('')
                                      ,
                                      SizedBox(height: 10,),

                                    ],
                                  )
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                        );

                      });

                    }))


              ],
            ),
          ),
        ),
      );
    });
  }
}
