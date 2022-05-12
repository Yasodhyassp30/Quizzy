import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../loadingscreens/loadingscreen.dart';

class evaluatequiz extends StatefulWidget {
  final quizdetails,answers,stdid;
  const evaluatequiz({Key? key,this.quizdetails,this.answers,this.stdid}) : super(key: key);

  @override
  State<evaluatequiz> createState() => _evaluatequizState();
}

class _evaluatequizState extends State<evaluatequiz> {
    int selected=1;
    List  questions =[];
    Map answervector ={};
    double marks =0;
    List checkedquestions =[];
    bool loading=false;
    TextEditingController ans =TextEditingController();
    TextEditingController marks_given =TextEditingController();
    FirebaseAuth _auth =FirebaseAuth.instance;
    String answer="";
    @override
    Widget build(BuildContext context) {
      questions = widget.quizdetails['Questions'];
      if (loading) {
        return loadfadingcube();
      } else {
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
                          IconButton(onPressed: (){Navigator.pop(context);}, icon:Icon(Icons.arrow_back,color: Colors.white,size: 30,)),
                          SizedBox(width: 10.0,),
                          Text(widget.quizdetails['title'],
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 20, color: Colors.white)),),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.15,
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
                                      right: BorderSide(
                                          width: 3, color: Colors.grey)
                                  )
                              ),
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.7,
                              child: ListView.builder(scrollDirection: Axis
                                  .horizontal,
                                  itemCount: questions.length,
                                  itemBuilder: (context, i) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selected = i + 1;
                                        });
                                      },
                                      child: Container(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.23,
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              width: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width * 0.2,
                                              height: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .height * 0.12,
                                              decoration: BoxDecoration(
                                                  color: Colors.lightBlue[200],
                                                  borderRadius: BorderRadius
                                                      .circular(10),
                                                  border: (i == selected - 1)
                                                      ? Border.all(width: 3,
                                                      color: Colors.blue)
                                                      : Border.all(width: 3,
                                                      color: Colors.white)
                                              ),
                                              child: Column(
                                                children: [
                                                  Text('${i + 1}.'),
                                                  (checkedquestions.contains(selected))
                                                      ? (Icon(Icons.check))
                                                      : Container()
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
                            TextButton(onPressed: () async {
                              FirebaseFirestore store = FirebaseFirestore
                                  .instance;
                              setState(() {
                                loading = true;
                              });
                              Map answerdetails =widget.answers;
                              answerdetails['marks']=marks;
                              await store.collection('answers').doc(widget.quizdetails['quizid']).update({'${widget.stdid}':answerdetails});
                              answervector['total']=marks;
                              await store.collection('assements').doc(
                                  widget.quizdetails['quizid']).set(
                                  {
                                    '${widget.stdid}': answervector
                                  }, SetOptions(merge: true));
                              setState(() {
                                loading = false;
                              });
                              Navigator.pop(context);
                            }, child: Text('Finish')),

                            SizedBox(width: 10,)
                          ],
                        )
                    ),
                    SizedBox(height: 10,),
                    (questions.length > 0) ? Container(
                      child: (questions[selected - 1]['type'] == 'MCQ' ||
                          questions[selected - 1]['type'] == 'T/F' ||
                          questions[selected - 1]['type'] == 'Text Answer')
                          ? Container(
                        child: Column(
                          children: [
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue[600],
                                      ),
                                      child: Column(
                                        children: [
                                          Text('Total',style: TextStyle(fontSize: 15,color: Colors.white)),
                                          Text('${marks}',style: TextStyle(fontSize: 25,color: Colors.white),),

                                        ],
                                      )

                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "${questions[selected - 1]['Question']} ?",
                                maxLines: null,),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.all(16),
                              child: (questions[selected - 1].containsKey(
                                  'URL')) ? Container(
                                  padding: EdgeInsets.all(16),
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.9,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.4,
                                  color: Colors.white,
                                  child: Center(
                                    child: InteractiveViewer(
                                        panEnabled: false,
                                        minScale: 0.5,
                                        maxScale: 4,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      questions[selected -
                                                          1]['URL'])
                                              )
                                          ),
                                        )
                                    ),
                                  )
                              ) : Container(),
                            ),
                            SizedBox(height: 10,),

                            (questions[selected-1].containsKey('real'))?Text("Correct answer : ${questions[selected-1]['real']}"):Text('No Corrrect Answer Defined'),
                            (questions[selected-1].containsKey('marks'))?Text("Marks : ${questions[selected-1]['marks']}"):Text('Marks Not Defined'),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.9,
                                  padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: marks_given,
                                    decoration: InputDecoration(
                                      border:OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: (checkedquestions.contains(selected-1))?'${answervector['${selected-1}']['marks']}':"Marks",
                                      suffixIcon: InkWell(
                                        onTap: (){
                                          setState(() {
                                            if(marks_given.text.trim().isNotEmpty){
                                              if(answervector.containsKey('${selected-1}')){
                                                marks-=answervector['${selected-1}']['marks'];
                                                answervector['${selected-1}']['marks']=double.parse(marks_given.text.trim());
                                                marks+=double.parse(marks_given.text.trim());
                                                marks_given.clear();



                                            }else {
                                                answervector['${selected-1}']={
                                                  'marks':double.parse(marks_given.text.trim()),
                                                  'original':widget.answers['${selected-1}'],
                                                  'real':questions[selected-1]['real']
                                                };
                                                marks+=double.parse(marks_given.text.trim());
                                                marks_given.clear();
                                                checkedquestions.add(selected-1);
                                              }
      }
                                          });
                                        },
                                        child: Icon(Icons.add),
                                      )
                                    )
                                  ),

                                )
                              ],
                            ),
                            SizedBox(height: 10,),
                            (questions[selected - 1]['type'] != 'Text Answer') ?
                            Container(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.4,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              padding: EdgeInsets.all(16),
                              child: ListView.builder(
                                  itemCount: questions[selected - 1]['answers']
                                      .length, itemBuilder: (context, i) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width * 0.9,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: (widget.answers['${selected - 1}'] == questions[selected - 1]['answers'][i])
                                              ? Colors.blue
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              15)
                                      ),
                                      child: Text(
                                        "${i + 1}.    ${questions[selected -
                                            1]['answers'][i]}",
                                        style: TextStyle(
                                          color: (widget.answers['${selected - 1}'] == questions[selected - 1]['answers'][i])
                                              ? Colors.white
                                              : Colors.black,),),
                                    ),
                                    SizedBox(height: 10,)
                                  ],
                                );
                              }),
                            ) : Container(
                                padding: EdgeInsets.all(16),
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.9,
                                child: Center(
                                  child: TextField(
                                    controller: ans,
                                    enabled: false,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      hintText: (widget.answers.containsKey('${selected - 1}'))
                                          ?widget.answers['${selected - 1}']
                                          : 'Not Answered',
                                    ),
                                  ),
                                )
                            ),
                            SizedBox(height: 10,),

                          ],
                        ),
                      )
                          : Container(

                      ),

                    ) : Container()
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }
}
