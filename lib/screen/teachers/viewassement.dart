import 'package:cloud/screen/teachers/viewassesmentsdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class quizview extends StatefulWidget {
  final classlist ;
  const quizview({Key? key,this.classlist}) : super(key: key);

  @override
  State<quizview> createState() => _quizviewState();
}

class _quizviewState extends State<quizview> {
  String ? dropdown1;
  FirebaseFirestore store =FirebaseFirestore.instance;
  List classes=[];
  @override
  Widget build(BuildContext context) {
    classes=widget.classlist;
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
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[500],
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),


                      ),
                      child: Row(
                        children: [
                          IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,)),
                          SizedBox(width: 10.0,),
                          Text('Assements',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.all(10),

                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child :Row(
                          children: [
                            Expanded(child:DropdownButton<String>(

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
                            ), )
                          ],
                        )
                      ),
                    ),
                    SizedBox(height: 10,),

                    Container(
                      padding: EdgeInsets.all(16),
                      height: MediaQuery.of(context).size.height*0.7,
                        child:(dropdown1!=null)?FutureBuilder<QuerySnapshot>(future:store.collection('Quizzes').where('classroomid',isEqualTo: dropdown1).get() ,builder: (context, snapshot) {
                          List test =[];
                          if(snapshot.data!=null&&snapshot.connectionState!=ConnectionState.waiting){
                            test=snapshot.data!.docs;
                          }
                          return ListView.builder(itemCount: test.length,itemBuilder: (context,i){
                            return Column(
                              children: [
                            Container(
                            child: Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        test[i].get('title'),style: TextStyle(color: Colors.lightBlue,fontSize: 20),
                                      ),
                                      Text(test[i].get('format')),
                                      Text('Start : ${DateFormat('dd/MM/yyyy hh:mm ').format(DateTime.parse(test[i].get('start')))}',style: TextStyle(color: Colors.deepPurple),),
                                      Text('End   : ${DateFormat('dd/MM/yyyy hh:mm ').format(DateTime.parse(test[i].get('end')))}',style: TextStyle(color: Colors.blueAccent),)
                                    ],
                                  )
                                ),
                                Expanded(child:SizedBox()),
                                Container(
                                  child: TextButton(
                                      onPressed: (){
                                        Map quizdata =test[i].data() as Map;
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>viewpaper(quizdetails: quizdata,)));
                                      },
                                    child: Text('View'),
                                  ),
                                ),
                                
                              ],
                            ),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                                SizedBox(height: 10,)
                              ],
                            );

                          });
                          
                        }):Container()
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
