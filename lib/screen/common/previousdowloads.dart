import 'package:cloud/db/localDB.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class previousdownloads extends StatefulWidget {
  final classdata;
  const previousdownloads({Key? key,this.classdata}) : super(key: key);

  @override
  _previousdownloadsState createState() => _previousdownloadsState();
}

class _previousdownloadsState extends State<previousdownloads> {
  FirebaseAuth _auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ConstrainedBox(
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
                        Text('Previous Downloads',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                        Expanded(child: SizedBox()),
                        Icon(Icons.history,size: 30,color: Colors.white,),
                      ],
                    ),
                  ),
                  FutureBuilder(future: download_db.instance.getall(_auth.currentUser!.uid,widget.classdata.id),builder: (context,snapdownloads){
                    List  Data=[];
                    if(snapdownloads.connectionState!=ConnectionState.waiting){
                      if(snapdownloads.data!=null){
                        Data =snapdownloads.data as List;
                        Data=Data.reversed.toList();
                      }
                    }

                    return Container(
                      padding: EdgeInsets.all(16),
                      height: MediaQuery.of(context).size.height*0.8,
                      child: (Data.length==0)?Container():ListView.builder(itemCount: Data.length,itemBuilder: (context,i){
                        return Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height*0.2,
                              width: MediaQuery.of(context).size.width*0.9,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.5,
                                    child: Column(
                                      children: [
                                        Text(Data[i]['title'],style: TextStyle(color: Colors.blue,fontSize: 18),overflow: TextOverflow.ellipsis,),
                                        Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(Data[i]['date'])),style: TextStyle(color: Colors.grey,fontSize: 15),overflow: TextOverflow.ellipsis,),
                                      ],
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    )
                                  ),
                                 Column(
                                   children: [
                                     Container(
                                       width: MediaQuery.of(context).size.width*0.3,
                                       child: ElevatedButton(
                                         onPressed: ()async{
                                           if(await File(Data[i]['path']).exists()){
                                             OpenFile.open(Data[i]['path']);
                                           }else{
                                             showDialog(context: context, builder: (BuildContext context) {
                                               return  AlertDialog(
                                                 title: Text("Error"),
                                                 content: Text(
                                                   'Unable to find the file,may be deleted Please download again'
                                                 ),
                                                 actions: [
                                                   Container(
                                                     padding: EdgeInsets.all(10),
                                                     child:TextButton(
                                                       onPressed: (){
                                                         Navigator.pop(context);
                                                       },
                                                       child: Text('Ok'),
                                                     )
                                                   )
                                                 ],
                                               );
                                             });
                                             download_db.instance.deleteitem(Data[i]['id']);
                                             setState(() {

                                             });
                                           }
                                         },
                                         child: Text('Open',style: TextStyle(fontSize: 15,color: Colors.white),),
                                       ),
                                     ),
                                     Container(
                                       width: MediaQuery.of(context).size.width*0.3,
                                       child: ElevatedButton(
                                         onPressed: ()async{
                                           if(await File(Data[i]['path']).exists()){
                                              await File(Data[i]['path']).delete();
                                           }
                                           download_db.instance.deleteitem(Data[i]['id']);
                                             setState(() {

                                             });

                                         },
                                         style: ElevatedButton.styleFrom(
                                           primary: Colors.redAccent
                                         ),
                                         child: Text('Delete',style: TextStyle(fontSize: 15,color: Colors.white),),
                                       ),
                                     )
                                   ],
                                 )
                                ],
                              ),
                            ),
                            SizedBox(height:5,)
                          ],
                        );
                      }),

                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
