import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../student/materialupload.dart';


class lmsteachers extends StatefulWidget {
  final classdetails;
  const lmsteachers({Key? key,this.classdetails}) : super(key: key);

  @override
  _lmsteachersState createState() => _lmsteachersState();
}

class _lmsteachersState extends State<lmsteachers> {
  FirebaseFirestore store =FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          await Navigator.push(context, MaterialPageRoute(builder: (context)=>materialupload(classdata: widget.classdetails,)));
          setState(() {

          });
        },
        child: Icon(Icons.cloud_upload),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ConstrainedBox(
        constraints: new BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: Container(
          color: Colors.lightBlue[100],
          child: SafeArea(
            child: Container(
              
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(25),
                    height: MediaQuery.of(context).size.height*0.1,
                    decoration: BoxDecoration(
                      color: Colors.blue[500],


                    ),
                    child: Row(
                      children: [
                        IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(
                          Icons.arrow_back,size: 30,color: Colors.white,
                        )),
                        SizedBox(width: 10.0,),
                        Text('LMS',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                 FutureBuilder<DocumentSnapshot>(future:store.collection('LMS').doc(widget.classdetails.id).get(),builder: (context,snapshot){
                   List lmsdocs=[];
                   if(snapshot.connectionState==ConnectionState.waiting){
                     return Container(
                       child: CircularProgressIndicator(),
                     );
                   }else{

                     if(snapshot.data?.data()!=null){
                       lmsdocs=snapshot.data!.get('materials');
                     }
                     return Container(
                       padding: EdgeInsets.all(15),
                       child:  Container(
                           height: MediaQuery.of(context).size.height*0.7,
                           padding: EdgeInsets.all(10),
                           child: ListView.builder(itemCount: lmsdocs.length,itemBuilder: (context,i){
                             return Card(
                                 child:Column(
                                   children: [
                                     Container(
                                       height: MediaQuery.of(context).size.height*0.25,
                                       width: MediaQuery.of(context).size.width*0.9,
                                       decoration: BoxDecoration(
                                           color: Colors.white,
                                           borderRadius: BorderRadius.circular(10)
                                       ),
                                       padding: EdgeInsets.all(20),
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         mainAxisAlignment: MainAxisAlignment.start,
                                         children: [
                                           Container(
                                             width: MediaQuery.of(context).size.width*0.8,
                                             padding: EdgeInsets.all(10),
                                             decoration: BoxDecoration(
                                               color: Colors.blue[900],
                                               borderRadius: BorderRadius.circular(10)
                                             ),
                                             child: Text(lmsdocs[i]['title'],overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 20,color: Colors.white),),
                                           ),
                                           SizedBox(height: 10,),
                                           Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(lmsdocs[i]['date'])),style: TextStyle(fontSize: 15,color: Colors.blueAccent),),
                                           SizedBox(height: 15,),
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.center,
                                             children: [
                                               ElevatedButton(onPressed: (){}, child:Icon(Icons.download),style: ElevatedButton.styleFrom(
                                                 shape: CircleBorder(),
                                                 padding: EdgeInsets.all(10),
                                                 primary: Colors.blue,
                                                 onPrimary: Colors.white,
                                               ),),
                                               SizedBox(width: 10,),
                                               ElevatedButton(onPressed: (){}, child:Icon(Icons.delete),style: ElevatedButton.styleFrom(
                                                 shape: CircleBorder(),
                                                 padding: EdgeInsets.all(10),
                                                 primary: Colors.redAccent,
                                                 onPrimary: Colors.white,
                                               ),)

                                             ],
                                           ),
                                         ],
                                       ),
                                     ),
                                     SizedBox(height: 10,)
                                   ],
                                 )
                             );
                           })
                       ),
                     );
                   }
                 }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
