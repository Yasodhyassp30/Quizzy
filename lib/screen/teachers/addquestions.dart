import 'dart:io';

import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud/screen/teachers/teachershome.dart';
import 'package:cloud/screen/teachers/viewquestions.dart';
import 'package:cloud/service/storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class addquestions extends StatefulWidget {
  final quizdetails,id;
  const addquestions({Key? key,this.quizdetails,this.id}) : super(key: key);

  @override
  State<addquestions> createState() => _addquestionsState();
}

class _addquestionsState extends State<addquestions> {
  List questions =[];
  bool load =false;
  TextEditingController quest =TextEditingController();
  TextEditingController ans =TextEditingController();
  TextEditingController marks =TextEditingController();
  FilePickerResult? result;
  @override
  Widget build(BuildContext context) {
    if(load){
      return loadfadingcube();
    }else{
      if(widget.quizdetails['format']=='Online'){
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: ()async {
              await showDialog(context: context, builder: (context)
              {
                List answers = [];
                FilePickerResult ? result;
                String ? answerno;
                List type = ['MCQ', 'T/F', 'Text Answer'];

                if (widget.quizdetails['evaluation'] == 1) {
                  type = ['MCQ', 'T/F'];
                }
                String ? selection;
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return AlertDialog(
                          title: Text('New Question'),
                          content: SingleChildScrollView(
                            child: Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.8,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.9,
                                child: ListView(
                                  children: [
                                    Column(
                                      children: [
                                        DropdownButton<String>(

                                          hint: Text('Select Question type',
                                            style: TextStyle(
                                                color: Colors.blueAccent
                                            ),),

                                          value: selection,
                                          underline: Container(
                                            height: 2,
                                            color: Colors.blueAccent,
                                          ),
                                          onChanged: (String? values) {
                                            setState(() {
                                              selection = values;
                                            });
                                          },
                                          items: type.map<
                                              DropdownMenuItem<String>>((e) {
                                            return DropdownMenuItem(
                                              child: Text(e), value: e,);
                                          }).toList(),
                                        ),
                                        (selection == 'MCQ') ? Container(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10,),
                                              TextField(
                                                keyboardType: TextInputType
                                                    .multiline,
                                                maxLines: 2,
                                                controller: quest,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(10.0),
                                                    ),

                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    hintText: "Question",
                                                    hintStyle:
                                                    TextStyle(color: Colors.grey,
                                                        fontSize: 18.0)
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              TextField(
                                                keyboardType: TextInputType
                                                    .multiline,
                                                maxLines: 2,
                                                controller: ans,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(10.0),
                                                    ),

                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    hintText: "Answer",
                                                    hintStyle:
                                                    TextStyle(color: Colors.grey,
                                                        fontSize: 18.0)
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  Expanded(child: OutlinedButton(
                                                      onPressed: () {
                                                        if (answers.length < 6 &&
                                                            ans.text
                                                                .trim()
                                                                .length > 0) {
                                                          setState(() {
                                                            answers.add(
                                                                ans.text.trim());
                                                            ans.clear();
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(10),
                                                        child: Column(
                                                          children: [
                                                            Text('Add',
                                                              style: TextStyle(
                                                                  fontSize: 20),),
                                                            Text('Remain ${5 -
                                                                answers.length}',
                                                              style: TextStyle(
                                                                  fontSize: 10),),

                                                          ],
                                                        ),
                                                      )
                                                  )),


                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              TextField(
                                                keyboardType: TextInputType.number,
                                                controller: marks,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(10.0),
                                                    ),

                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    hintText: "Marks",
                                                    hintStyle:
                                                    TextStyle(color: Colors.grey,
                                                        fontSize: 18.0)
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  Expanded(child: OutlinedButton(
                                                      onPressed: () async {
                                                        result =
                                                        await FilePicker.platform
                                                            .pickFiles(
                                                          type: FileType.custom,
                                                          allowedExtensions: [
                                                            'jpg',
                                                            'png',
                                                            'jpeg'
                                                          ],
                                                        );
                                                        setState((){});
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(10),
                                                        child: Column(
                                                          children: [
                                                            Text('Attach Picture',
                                                              style: TextStyle(
                                                                  fontSize: 20),),

                                                          ],
                                                        ),
                                                      )
                                                  )),


                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Container(
                                                width: MediaQuery.of(context).size.width*0.7,
                                                child: (result!=null)?Center(
                                                  child: Text(result!.names[0]!,overflow: TextOverflow.ellipsis,),
                                                ):null,
                                              ),
                                              SizedBox(height: 10,),
                                              DropdownButton<String>(

                                                hint: Text('Select Real Answer',
                                                  style: TextStyle(
                                                      color: Colors.blueAccent
                                                  ),),

                                                value: answerno,
                                                underline: Container(
                                                  height: 2,
                                                  color: Colors.blueAccent,
                                                ),
                                                onChanged: (String? values) {
                                                  setState(() {
                                                    answerno = values;
                                                  });
                                                },
                                                items: answers.map<
                                                    DropdownMenuItem<String>>((e) {
                                                  return DropdownMenuItem(
                                                    child: Text(e), value: e,);
                                                }).toList(),
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  Expanded(child: ElevatedButton(
                                                      onPressed: (quest.text
                                                          .trim()
                                                          .length > 0 &&
                                                          answers.length > 0) ? () {
                                                        Map newques = new Map();

                                                        newques['id']=widget.id;
                                                        newques['marks']=int.parse(marks.text.trim());
                                                        newques['type'] = selection;
                                                        newques['question'] =
                                                            quest.text.trim();
                                                        newques['answers'] =
                                                            answers;
                                                        if (result != null) {
                                                          newques['pic'] = File(result!.paths[0]!);
                                                          newques['filename']=result!.names[0];
                                                        }
                                                        if (answerno != null) {
                                                          newques['real'] =
                                                              answerno;
                                                        }
                                                        questions.add(newques);
                                                        selection = null;
                                                        quest.clear();
                                                        ans.clear();
                                                        answers = [];
                                                        result = null;
                                                        answerno = null;
                                                        Navigator.pop(context);
                                                      } : null,
                                                      child: Container(
                                                        padding: EdgeInsets.all(10),
                                                        child: Column(
                                                          children: [
                                                            Text('Add to Quiz',
                                                              style: TextStyle(
                                                                  fontSize: 20),),

                                                          ],
                                                        ),
                                                      )
                                                  )),


                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Container(
                                                height: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height * 0.15,
                                                child: ListView.builder(
                                                    itemCount: answers.length,
                                                    itemBuilder: (context, i) {
                                                      return Container(
                                                        width: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width * 0.6,
                                                        child: Row(
                                                          children: [
                                                            Text(answers[i],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue),),
                                                            Expanded(
                                                                child: SizedBox()),
                                                            IconButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    answers
                                                                        .removeAt(
                                                                        i);
                                                                  });
                                                                },
                                                                icon: Icon(
                                                                    Icons.clear))
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ),

                                            ],
                                          ),

                                        ) : (selection=='T/F')?Container(
                                          child:  Column(
                                            children: [
                                              SizedBox(height: 10,),
                                              TextField(
                                                keyboardType: TextInputType
                                                    .multiline,
                                                maxLines: 2,
                                                controller: quest,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(10.0),
                                                    ),

                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    hintText: "Question",
                                                    hintStyle:
                                                    TextStyle(color: Colors.grey,
                                                        fontSize: 18.0)
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              TextField(
                                                keyboardType: TextInputType.number,
                                                controller: marks,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(10.0),
                                                    ),

                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    hintText: "Marks",
                                                    hintStyle:
                                                    TextStyle(color: Colors.grey,
                                                        fontSize: 18.0)
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  Expanded(child: OutlinedButton(
                                                      onPressed: () async {
                                                        result =
                                                        await FilePicker.platform
                                                            .pickFiles(
                                                          type: FileType.custom,
                                                          allowedExtensions: [
                                                            'jpg',
                                                            'png',
                                                            'jpeg'
                                                          ],
                                                        );
                                                        setState((){});
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(10),
                                                        child: Column(
                                                          children: [
                                                            Text('Attach Picture',
                                                              style: TextStyle(
                                                                  fontSize: 20),),

                                                          ],
                                                        ),
                                                      )
                                                  )),


                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Container(
                                                width: MediaQuery.of(context).size.width*0.7,
                                                child: (result!=null)?Center(
                                                  child: Text(result!.names[0]!,overflow: TextOverflow.ellipsis,),
                                                ):null,
                                              ),
                                              SizedBox(height: 10,),
                                              DropdownButton<String>(

                                                hint: Text('Select Real Answer',
                                                  style: TextStyle(
                                                      color: Colors.blueAccent
                                                  ),),

                                                value: answerno,
                                                underline: Container(
                                                  height: 2,
                                                  color: Colors.blueAccent,
                                                ),
                                                onChanged: (String? values) {
                                                  setState(() {
                                                    answerno = values;
                                                  });
                                                },
                                                items: ['T','F'].map<
                                                    DropdownMenuItem<String>>((e) {
                                                  return DropdownMenuItem(
                                                    child: Text(e), value: e,);
                                                }).toList(),
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  Expanded(child: ElevatedButton(
                                                      onPressed: (quest.text
                                                          .trim()
                                                          .length > 0) ? () {
                                                        Map newques = new Map();
                                                        newques['type'] = selection;
                                                        newques['question'] =
                                                            quest.text.trim();
                                                        newques['id']=widget.id;
                                                        newques['marks']=marks.text.trim();
                                                        newques['answers'] =
                                                        ['T','F'];
                                                        if (result != null) {
                                                          newques['pic'] = File(result!.paths[0]!);
                                                          newques['filename']=result!.names[0];
                                                        }
                                                        if (answerno != null) {
                                                          newques['real'] =
                                                              answerno;
                                                        }
                                                        questions.add(newques);
                                                        selection = null;
                                                        quest.clear();
                                                        ans.clear();
                                                        answers = [];
                                                        result = null;
                                                        answerno = null;
                                                        Navigator.pop(context);
                                                      } : null,
                                                      child: Container(
                                                        padding: EdgeInsets.all(10),
                                                        child: Column(
                                                          children: [
                                                            Text('Add to Quiz',
                                                              style: TextStyle(
                                                                  fontSize: 20),),

                                                          ],
                                                        ),
                                                      )
                                                  )),


                                                ],
                                              ),

                                            ],
                                          ),

                                        ):(selection=='Text Answer')?Container(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10,),
                                              TextField(
                                                keyboardType: TextInputType
                                                    .multiline,
                                                maxLines: 2,
                                                controller: quest,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(10.0),
                                                    ),

                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    hintText: "Question",
                                                    hintStyle:
                                                    TextStyle(color: Colors.grey,
                                                        fontSize: 18.0)
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  Expanded(child: OutlinedButton(
                                                      onPressed: () async {
                                                        result =
                                                        await FilePicker.platform
                                                            .pickFiles(
                                                          type: FileType.custom,
                                                          allowedExtensions: [
                                                            'jpg',
                                                            'png',
                                                            'jpeg'
                                                          ],
                                                        );
                                                        setState((){});
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(10),
                                                        child: Column(
                                                          children: [
                                                            Text('Attach Picture',
                                                              style: TextStyle(
                                                                  fontSize: 20),),

                                                          ],
                                                        ),
                                                      )
                                                  )),


                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Container(
                                                width: MediaQuery.of(context).size.width*0.7,
                                                child: (result!=null)?Center(
                                                  child: Text(result!.names[0]!,overflow: TextOverflow.ellipsis,),
                                                ):null,
                                              ),
                                              SizedBox(height: 10,),
                                              Row(
                                                children: [
                                                  Expanded(child: ElevatedButton(
                                                      onPressed: (quest.text
                                                          .trim()
                                                          .length > 0) ? () {
                                                        Map newques = new Map();
                                                        newques['type'] = selection;
                                                        newques['question'] =
                                                            quest.text.trim();
                                                        newques['id']=widget.id;
                                                        if (result != null) {
                                                          newques['pic'] = File(result!.paths[0]!);
                                                          newques['filename']=result!.names[0];
                                                        }
                                                        if (answerno != null) {
                                                          newques['real'] =
                                                              answerno;
                                                        }
                                                        questions.add(newques);
                                                        selection = null;
                                                        quest.clear();
                                                        ans.clear();
                                                        answers = [];
                                                        result = null;
                                                        answerno = null;
                                                        Navigator.pop(context);
                                                      } : null,
                                                      child: Container(
                                                        padding: EdgeInsets.all(10),
                                                        child: Column(
                                                          children: [
                                                            Text('Add to Quiz',
                                                              style: TextStyle(
                                                                  fontSize: 20),),

                                                          ],
                                                        ),
                                                      )
                                                  )),


                                                ],
                                              ),

                                            ],
                                          ),
                                        ):Container()

                                      ],
                                    ),
                                  ],
                                )
                            ),
                          )
                      );
                    }
                );
              });
              setState(() {

              });
            },
            child: Icon(Icons.add),
          ),
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
                              IconButton(onPressed: (){
                                Navigator.pop(context);} , icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,)),
                              SizedBox(width: 10.0,),
                              Text('Add Questions',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(child: ElevatedButton(
                                onPressed: ()async{
                                  setState(() {
                                    load=true;
                                  });
                                  String id =questions[0]['id'];
                                  cloudstorage c2 =cloudstorage();
                                  while(questions.length>0){
                                    await c2.addquizzes(id, questions[0]);
                                    questions.removeAt(0);
                                  }

                                  setState(() {
                                    load=false;
                                  });
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=>teachershome()), (route) => false);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.save),
                                      SizedBox(width: 10,),
                                      Text('Save Quiz',style: TextStyle(fontSize: 18),),
                                    ],
                                  ),
                                ),
                              ))
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          height: MediaQuery.of(context).size.height*0.7,
                          child: ListView.builder(itemCount: questions.length,itemBuilder: (context,i){
                            return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.3,
                                        child: Text("Question ${i+1}",style: TextStyle(color: Colors.blue,fontSize: 20),overflow: TextOverflow.ellipsis,),

                                      ),
                                      Expanded(child: SizedBox()),
                                      Container(
                                          width: MediaQuery.of(context).size.width*0.2,
                                          child: ElevatedButton(onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>viewquesstion(questiondetails: questions[i],)));
                                          },child: Text('View'),)

                                      ),
                                      SizedBox(width: 10,),
                                      Container(
                                          width: MediaQuery.of(context).size.width*0.2,
                                          child: ElevatedButton.icon(onPressed: (){
                                            questions.removeAt(i);
                                            setState(() {

                                            });
                                          },label:Text('-'),

                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.redAccent,
                                          ),
                                            icon: Icon(Icons.delete),
                                          )

                                      ),

                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,)
                              ],
                            );
                          }),
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
                              IconButton(onPressed: (){
                                Navigator.pop(context);} , icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,)),
                              SizedBox(width: 10.0,),
                              Text('Add Document',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.all(16),
                          child: TextField(
                            keyboardType: TextInputType
                                .multiline,
                            maxLines: 2,
                            controller: quest,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius
                                      .circular(10.0),
                                ),

                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Summary",
                                hintStyle:
                                TextStyle(color: Colors.grey,
                                    fontSize: 18.0)
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                  Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(child: ElevatedButton(
                            onPressed: ()async{

                              String id =widget.id;
                              if(result!=null){
                                setState(() {
                                  load=true;
                                });
                                cloudstorage c2 =cloudstorage();
                                await c2.uploadquizmaterials(File(result!.paths[0]!), id, quest.text.trim(), result!.names[0]!, DateTime.now().toString());
                                setState(() {
                                  load=false;
                                });
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=>teachershome()), (route) => false);
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.9,
                              padding: EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save),
                                  SizedBox(width: 10,),
                                  Text('Save Quiz',style: TextStyle(fontSize: 18),),
                                ],
                              ),
                            ),
                          ))
                        ],
                      ),
                  ),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width*0.9,
                          child: (result!=null)?Text(result!.names[0]!,style: TextStyle(color: Colors.blue),):null,
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(16),
                              child:ElevatedButton(
                                onPressed: () async {
                                  result = await FilePicker.platform
                                      .pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: [
                                      'pdf',
                                      'docx',
                                      'pptx'
                                    ],
                                  );
                                  setState((){});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  child: Text('Pick Document'),
                                ),
                              ),
                            )
                          ],
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
}

