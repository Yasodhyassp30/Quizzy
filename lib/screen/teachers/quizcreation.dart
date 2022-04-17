import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud/screen/teachers/addquestions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class quizcreation extends StatefulWidget {
  final classlist;
  const quizcreation({Key? key,this.classlist}) : super(key: key);

  @override
  State<quizcreation> createState() => _quizcreationState();
}

class _quizcreationState extends State<quizcreation> {
  TextEditingController name= TextEditingController();
  TextEditingController count= TextEditingController();
  String ? dropdown1;
  DateTime ? Start;
  String ? dropdown3;
  List classes =[];
  List classnames =[];
  DateTime ? End;
  Map? dropdown2;
  bool loading =false;
  List <Map>Methods =[{
    'disp':'Predefined Answers (MCQ Only)',
    'value':1
  }, {
    'disp':'Manual',
    'value':2
  }];
  FirebaseFirestore store =FirebaseFirestore.instance;
  FirebaseAuth _auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    classes =widget.classlist;

        if(!loading){
          return Scaffold(
            body: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Container(
                color: Colors.lightBlue[100],
                child: SafeArea(
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
                                IconButton(onPressed: (){Navigator.pop(context);} , icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,)),
                                SizedBox(width: 10.0,),
                                Text('Create Quiz',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            padding: EdgeInsets.all(15),
                            child:  Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Text('Quiz Details',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.blueAccent)),),
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: name,
                                          decoration: InputDecoration(
                                              border:OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              hintText: "Quiz Title",
                                              hintStyle:
                                              TextStyle(color: Colors.grey, fontSize: 18.0)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(


                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        children: [
                                          DropdownButton<String>(

                                            hint: Text('Select Class',style: TextStyle(
                                                color: Colors.blueAccent
                                            ),),

                                            value: dropdown1,
                                            underline: Container(
                                              height: 2,
                                              color: Colors.blueAccent,
                                            ),
                                            onChanged: (String? values){
                                              dropdown1=values;
                                              setState(() {

                                              });
                                            },
                                            items: classes.map<DropdownMenuItem<String>>((e){
                                              return DropdownMenuItem(child: Text('${e.get('title')}'),value: e.id,);
                                            }).toList(),
                                          ),
                                        ],
                                      )

                                  ),
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        DropdownButton<String>(

                                          hint: Text('Select type',style: TextStyle(
                                              color: Colors.blueAccent
                                          ),),

                                          value: dropdown3,
                                          underline: Container(
                                            height: 2,
                                            color: Colors.blueAccent,
                                          ),
                                          onChanged: (String? values){
                                            dropdown3=values;
                                            setState(() {

                                            });
                                          },
                                          items: ['Online','Submission'].map<DropdownMenuItem<String>>((e){
                                            return DropdownMenuItem(child: Text('${e}'),value: e,);
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  (dropdown3!='Submission')? Container(

                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        children: [
                                          DropdownButton<Map>(

                                            hint: Text('Select Evaluation Method',style: TextStyle(
                                                color: Colors.blueAccent
                                            ),),

                                            value: dropdown2,
                                            underline: Container(
                                              height: 2,
                                              color: Colors.blueAccent,
                                            ),
                                            onChanged: (Map? values){
                                              setState(() {
                                                dropdown2=values;
                                              });
                                            },
                                            items: Methods.map<DropdownMenuItem<Map>>((e){
                                              return DropdownMenuItem(child: Text(e['disp']),value:e,);
                                            }).toList(),
                                          ),
                                        ],
                                      )

                                  ):Container(),

                                  Container(
                                    height: MediaQuery.of(context).size.height*0.1,
                                    padding: EdgeInsets.all(16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(child: ElevatedButton(onPressed: (){
                                          DatePicker.showDateTimePicker(context,
                                              showTitleActions: true,
                                              minTime: DateTime.now(),
                                              maxTime: DateTime.now(), onConfirm: (date) {
                                                setState(() {
                                                  Start =date;
                                                });
                                              }, currentTime: DateTime.now(), locale: LocaleType.en);
                                        }, child: Text('Start'))),
                                        SizedBox(width: 20,),
                                        Expanded(child: ElevatedButton(onPressed: (Start!=null)?(){
                                          DatePicker.showDateTimePicker(context,
                                              showTitleActions: true,
                                              minTime: Start,
                                              maxTime: DateTime.now(), onConfirm: (date) {
                                                setState(() {
                                                  End =date;
                                                });
                                              }, currentTime: DateTime.now(), locale: LocaleType.en);
                                        }:null, child: Text('End')))
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    height: MediaQuery.of(context).size.height*0.1,
                                    child: Row(

                                      children: [
                                        Expanded(child: ElevatedButton(onPressed:(name.text.trim().length!=0&&Start!=null&&End!=null&&dropdown1!=null&&(dropdown2!=null||dropdown3=='Submission'))? ()async{
                                          setState(() {
                                            loading=true;
                                          });

                                          Map<String,dynamic> quiz = new Map();

                                          if(dropdown3=='Submission'){
                                            quiz =  {
                                              'format':dropdown3,
                                              'classroomid':dropdown1,
                                              'Questions':[],
                                              'title':name.text.trim(),
                                              'evaluation':2,
                                              'start':Start.toString(),
                                              'end':End.toString(),
                                              'submitted':[]
                                            };
                                          }else{
                                            quiz =  {
                                              'format':dropdown3,
                                              'classroomid':dropdown1,
                                              'Questions':[],
                                              'title':name.text.trim(),
                                              'evaluation':dropdown2!['value'],
                                              'start':Start.toString(),
                                              'end':End.toString(),
                                              'submitted':[]
                                            };
                                          }

                                         DocumentReference docref= await store.collection('Quizzes').add(quiz);
                                          quiz['quizid']=docref.id;
                                          await store.collection('studentquiz').doc(docref.id).set(quiz);
                                          setState(() {
                                            loading=false;
                                          });
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>addquestions(quizdetails:quiz,id: docref.id,)));
                                        }:null, child: Container(
                                          padding: EdgeInsets.all(10),
                                          height: MediaQuery.of(context).size.height*0.07,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.create),
                                              Text('Create')
                                            ],
                                          ),
                                        )))
                                      ],
                                    ),
                                  )
                                ],
                              ),
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
        }else{
          return loadfadingcube();
        }


    }
  }


