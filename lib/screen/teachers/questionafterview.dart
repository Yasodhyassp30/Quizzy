import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class questionafterview extends StatefulWidget {
  final questiondetails;
  const questionafterview({Key? key,this.questiondetails}) : super(key: key);

  @override
  State<questionafterview> createState() => _questionafterviewState();
}

class _questionafterviewState extends State<questionafterview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Container(
          color: Colors.lightBlue[100],
          child:SafeArea(
            child: Container(
                child:SingleChildScrollView(
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[500],
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),


                        ),
                        child: Row(
                          children: [
                            IconButton(onPressed: (){Navigator.pop(context);} , icon: Icon(Icons.arrow_back,size: 30,color: Colors.white,)),
                            SizedBox(width: 10.0,),
                            Text('Details',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Text("${widget.questiondetails['Question']} ?",maxLines: null,),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: (widget.questiondetails.containsKey('URL'))?Container(
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
                                      image: NetworkImage(widget.questiondetails['URL'])
                                    )
                                  ),
                                )
                              ),
                            )
                        ):Container(),
                      ),
                      SizedBox(height: 10,),
                      (widget.questiondetails['type']!='Text Answer')?
                      Container(
                        height: MediaQuery.of(context).size.height*0.4,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(16),
                        child: ListView.builder(itemCount: widget.questiondetails['answers'].length,itemBuilder: (context,i){
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width*0.9,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: (widget.questiondetails['real']==widget.questiondetails['answers'][i])?Colors.blue:Colors.white,
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Text("${i+1}.    ${widget.questiondetails['answers'][i]}"),
                              ),
                              SizedBox(height: 5,)
                            ],
                          );
                        }),
                      ):Container(
                        padding: EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width*0.9,
                        child: Center(
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              hintText: 'Answers Here'
                            ),
                          ),
                        )
                      )


                    ],
                  ),
                )
            ),
          ) ,
        ),
      ),
    );
  }
}
