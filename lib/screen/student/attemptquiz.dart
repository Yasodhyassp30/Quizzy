import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud/screen/student/studentshome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class attemptquiz extends StatefulWidget {
  final quizdetails;
  const attemptquiz({Key? key,this.quizdetails}) : super(key: key);

  @override
  State<attemptquiz> createState() => _attemptquizState();
}

class _attemptquizState extends State<attemptquiz> {
  int selected=1;
  List  questions =[];
  Map answervector ={};
  bool loading=false;
  TextEditingController ans =TextEditingController();
  FirebaseAuth _auth =FirebaseAuth.instance;
  String answer="";
  @override
  Widget build(BuildContext context) {
    questions = widget.quizdetails['Questions'];


   if(loading){
     return loadfadingcube();
   }else{
     return Scaffold(
       backgroundColor: Colors.lightBlue[100],
       body: SafeArea(
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
                       Text(widget.quizdetails['title'],overflow: TextOverflow.ellipsis, style: GoogleFonts.lato(
                           textStyle: TextStyle(
                               fontSize: 20, color: Colors.white)),),
                     ],
                   ),
                 ),
                 SizedBox(height: 10,),
                 Container(
                     width: MediaQuery.of(context).size.width,
                     height: MediaQuery.of(context).size.height*0.15,
                     padding: EdgeInsets.all(10),
                     decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(10)
                     ),
                     child: Row(
                       children: [
                         Container(
                           decoration: BoxDecoration(
                               border: Border(
                                   right: BorderSide(width: 3,color: Colors.grey)
                               )
                           ),
                           width: MediaQuery.of(context).size.width*0.7,
                           child: ListView.builder(scrollDirection: Axis.horizontal,itemCount:questions.length,itemBuilder: (context,i){
                             return GestureDetector(
                               onTap: (){
                                 setState(() {
                                   selected=i+1;
                                 });
                               },
                               child: Container(
                                 width: MediaQuery.of(context).size.width*0.23,
                                 child: Row(
                                   children: [
                                     Container(
                                       padding: EdgeInsets.all(5),
                                       width: MediaQuery.of(context).size.width*0.2,
                                       height: MediaQuery.of(context).size.height*0.12,
                                       decoration: BoxDecoration(
                                           color: Colors.lightBlue[200],
                                           borderRadius: BorderRadius.circular(10),
                                           border:(i==selected-1)? Border.all(width: 3,color: Colors.blue): Border.all(width: 3,color: Colors.white)
                                       ),
                                       child: Column(
                                         children: [
                                           Text('${i+1}.'),
                                           (questions[i].containsKey('studentanswer'))?(Icon(Icons.check)):Container()
                                         ],
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                             );
                           }),
                         ),
                         Expanded(child: SizedBox()),
                         TextButton(onPressed: ()async{
                           FirebaseFirestore store =FirebaseFirestore.instance;
                           setState(() {
                             loading=true;
                           });
                           await store.collection('answers').doc(widget.quizdetails['quizid']).set(
                               {
                                 '${_auth.currentUser!.uid}':answervector
                               },SetOptions(merge: true));
                           setState(() {
                             loading=false;
                           });
                           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>studentshome()), (route) => false);
                         }, child:Text('Submit')),

                         SizedBox(width: 10,)
                       ],
                     )
                 ),
                 SizedBox(height: 10,),
                 (questions.length>0)?Container(
                   child: (questions[selected-1]['type']=='MCQ'||questions[selected-1]['type']=='T/F'||questions[selected-1]['type']=='Text Answer')?Container(
                     child: Column(
                       children: [
                         Container(
                           padding: EdgeInsets.all(16),
                           child: Text("${questions[selected-1]['Question']} ?",maxLines: null,),
                         ),
                         SizedBox(height: 10,),
                         Container(
                           padding: EdgeInsets.all(16),
                           child: (questions[selected-1].containsKey('URL'))?Container(
                               padding: EdgeInsets.all(16),
                               width: MediaQuery.of(context).size.width*0.9,
                               height: MediaQuery.of(context).size.height*0.4,
                               color: Colors.white,
                               child:Center(
                                 child: InteractiveViewer(
                                     panEnabled: false,
                                     minScale: 0.5,
                                     maxScale: 4,
                                     child: Container(
                                       decoration: BoxDecoration(
                                           image: DecorationImage(
                                               image: NetworkImage(questions[selected-1]['URL'])
                                           )
                                       ),
                                     )
                                 ),
                               )
                           ):Container(),
                         ),
                         SizedBox(height: 10,),
                         (questions[selected-1]['type']!='Text Answer')?
                         Container(
                           height: MediaQuery.of(context).size.height*0.4,
                           width: MediaQuery.of(context).size.width,
                           padding: EdgeInsets.all(16),
                           child: ListView.builder(itemCount: questions[selected-1]['answers'].length,itemBuilder: (context,i){
                             return Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: [
                                 GestureDetector(
                                   onTap: (){
                                     setState(() {
                                       answer=questions[selected-1]['answers'][i];
                                       questions[selected-1]['studentanswer']=answer;
                                       answervector['${selected-1}']=answer;
                                     });
                                   },
                                   child: Container(
                                     width: MediaQuery.of(context).size.width*0.9,
                                     padding: EdgeInsets.all(10),
                                     decoration: BoxDecoration(
                                         color: (questions[selected-1]['studentanswer']==questions[selected-1]['answers'][i])?Colors.blue:Colors.white,
                                         borderRadius: BorderRadius.circular(15)
                                     ),
                                     child: Text("${i+1}.    ${questions[selected-1]['answers'][i]}",style: TextStyle(color: (questions[selected-1]['studentanswer']==questions[selected-1]['answers'][i])?Colors.white:Colors.black,),),
                                   ),
                                 ),
                                 SizedBox(height: 10,)
                               ],
                             );
                           }),
                         ):Container(
                             padding: EdgeInsets.all(16),
                             width: MediaQuery.of(context).size.width*0.9,
                             child: Center(
                               child: TextField(
                                 controller: ans,
                                 maxLines: null,
                                 keyboardType: TextInputType.multiline,
                                 decoration: InputDecoration(
                                     hintText: (answervector.containsKey('${selected-1}'))?answervector['${selected-1}']:'Answers Here',
                                 ),
                               ),
                             )
                         ),
                         SizedBox(height: 10,),
                         Row(
                           children: [
                             Expanded(child: ElevatedButton(
                               onPressed: (){
                                 answervector['${selected-1}']=ans.text.trim();
                               },
                               child: Text('Confirm'),
                             ))
                           ],
                         )
                       ],
                     ),
                   ):Container(

                   ),

                 ):Container()
               ],
             ),
           ),
         ),
       ),
     );
   }
  }
}
