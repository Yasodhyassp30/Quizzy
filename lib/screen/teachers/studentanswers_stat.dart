import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class studentans_stat extends StatefulWidget {
  final name,marks,length;
  const studentans_stat({Key? key,this.marks,this.name,this.length}) : super(key: key);

  @override
  State<studentans_stat> createState() => _studentans_statState();
}

class _studentans_statState extends State<studentans_stat> {
  @override
  Widget build(BuildContext context) {
    List q=[];
    if(widget.marks!=null){
      widget.marks.forEach((k,v){
        Map singleq ={};
        if(k!='total'){
          singleq['number']=(int.parse(k) +1).toString();
          singleq['original']=v['original'];
          if(v.containsKey('real')){
            singleq['real']=v['real'];
          }
          singleq['marks']=v['marks'];
          q.add(singleq);
        }


      });
      return Scaffold(
        backgroundColor: Colors.lightBlue[100],
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[500],


                  ),
                  child: Row(
                    children: [
                      IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(
                        Icons.arrow_back,size: 30,color: Colors.white,
                      )),
                      SizedBox(width: 10.0,),
                      Expanded(child: Container(

                        child: Text('Back',overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                      ))
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 16,right: 16,left: 16),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                      ),
                      padding: EdgeInsets.all(16),
                      child:Column(
                        children: [
                          Container(
                              child: Text(widget.name,style: TextStyle(color: Colors.blue,fontSize: 20),)
                          ),
                          SizedBox(height: 8,),
                          Row(
                            children: [
                              Text('Answered'),
                              Expanded(child: SizedBox()),
                              Text('${q.length}/${widget.length}')
                            ],
                          ),
                          SizedBox(height: 8,),
                          Row(
                            children: [
                              Text('Total'),
                              Expanded(child: SizedBox()),
                              Text('${widget.marks['total']}')
                            ],
                          ),


                        ],
                      ) ,
                    )
                ),
                Expanded(child: Container(
                  padding: EdgeInsets.only(bottom: 16,right: 16,left: 16),
                  child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10))
                      ),
                      child: ListView.builder(itemCount: q.length,itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(child: Container(
                              padding:EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Question ${q[index]['number']}',style: TextStyle(color: Colors.lightBlue,fontSize: 18),),
                                  Text(q[index].containsKey('real')? 'Correct Answer : ${q[index]['real']} ':" "),
                                  Text('Student answer : ${q[index]['original']}')
                                ],
                              ),
                            ),flex: 6,),
                            Expanded(flex: 4,child: Container(
                                padding:EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue
                                ),
                                child: Center(
                                  child: Text(q[index]['marks'].toString(),style: TextStyle(color: Colors.white),),
                                )
                            ))
                          ],
                        );
                      })),
                ),
                )

              ],
            ),
          ),
        ),
      );
    }else{
      return Scaffold(
        backgroundColor: Colors.lightBlue[100],
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[500],


                  ),
                  child: Row(
                    children: [
                      IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(
                        Icons.arrow_back,size: 30,color: Colors.white,
                      )),
                      SizedBox(width: 10.0,),
                      Expanded(child: Container(

                        child: Text('Back',overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                      ))
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 16,right: 16,left: 16),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                      ),
                      padding: EdgeInsets.all(16),
                      child:Column(
                        children: [
                          Container(
                              child: Text(widget.name,style: TextStyle(color: Colors.blue,fontSize: 20),)
                          ),
                          SizedBox(height: 8,),


                        ],
                      ) ,
                    )
                ),
                Expanded(child: Container(
                  padding: EdgeInsets.only(bottom: 16,right: 16,left: 16),
                  child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10))
                      ),
                      child: Center(
                        child: Text('Not Evaluated Yet')
                      )),
                ),
                )

              ],
            ),
          ),
        ),
      );
    }

  }
}
