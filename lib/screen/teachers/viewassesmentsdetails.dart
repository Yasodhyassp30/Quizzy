import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cloud/screen/teachers/allsubmissions.dart';
import 'package:cloud/screen/teachers/questionafterview.dart';
import 'package:cloud/screen/teachers/viewquestions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class viewpaper extends StatefulWidget {
  final quizdetails;
  const viewpaper({Key? key,this.quizdetails}) : super(key: key);

  @override
  State<viewpaper> createState() => _viewpaperState();
}

class _viewpaperState extends State<viewpaper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body:SafeArea(
        child: SingleChildScrollView(
          child:Container(
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
                      Text('Assements Details',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width*0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(widget.quizdetails['title'],style: TextStyle(fontSize: 18,),overflow: TextOverflow.ellipsis,),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(width: 2.0, color: Colors.grey),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Questions    : ${widget.quizdetails['Questions'].length}",style: TextStyle(fontSize: 18,color: Colors.blueAccent),overflow: TextOverflow.ellipsis,),
                                Text("Submissions  : ${widget.quizdetails['submitted'].length}",style: TextStyle(fontSize: 18,color: Colors.blueAccent),overflow: TextOverflow.ellipsis,),
                                Text('Start : ${DateFormat('dd/MM/yyyy hh:mm ').format(DateTime.parse(widget.quizdetails['start']))}',style: TextStyle(color: Colors.deepPurple),),
                                Text('End   : ${DateFormat('dd/MM/yyyy hh:mm ').format(DateTime.parse(widget.quizdetails['end']))}',style: TextStyle(color: Colors.deepPurple),)
                              ],

                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            width: MediaQuery.of(context).size.width*0.3,
                            child: TextButton(
                              onPressed: (widget.quizdetails['submitted'].length==0)?null:(){

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>allsubmissions(submissions: widget.quizdetails['submitted'],quizid: widget.quizdetails['quizid'],
                                  noofquestions: (widget.quizdetails['Questions']).isEmpty?0:widget.quizdetails['Questions'].length,quizdetails:widget.quizdetails ,)));
                              },
                              child: Text("SUBMISSIONS"),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10,),

                    ],
                  ),
                ),
                (widget.quizdetails['format']!="Submission")?Container(
                  padding: EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height*0.6,
                  child: ListView.builder(itemCount: widget.quizdetails['Questions'].length,itemBuilder: (context,i){
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>questionafterview(questiondetails: widget.quizdetails['Questions'][i],)));
                                  },child: Text('View'),)

                              ),
                              SizedBox(width: 10,),

                            ],
                          ),
                        ),
                        SizedBox(height: 10,)
                      ],
                    );
                  }),
                ):Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.quizdetails['message'],style: TextStyle(color: Colors.blue[800],fontSize: 18),),
                      SizedBox(height: 10,),
                      Container(

                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.file_copy),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.7,
                                  child: Text('Attachment : ${widget.quizdetails['filename']}',overflow: TextOverflow.ellipsis,),
                                )

                              ],
                            ),
                            SizedBox(height: 10,),
                          ],
                        )
                      ),
                      SizedBox(height: 10,),


              ],
            ),
          ),
          ]
        ) ,

      )
    )
    )
    );
  }
}
