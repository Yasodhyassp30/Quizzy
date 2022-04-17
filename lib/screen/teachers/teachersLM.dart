import 'package:cloud/db/localDB.dart';
import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud/screen/common/previousdowloads.dart';
import 'package:cloud/service/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import '../student/materialupload.dart';


class lmsteachers extends StatefulWidget {
  final classdetails;
  const lmsteachers({Key? key,this.classdetails}) : super(key: key);


  @override
  _lmsteachersState createState() => _lmsteachersState();
}

class _lmsteachersState extends State<lmsteachers> {
  FirebaseFirestore store =FirebaseFirestore.instance;
  cloudstorage c1 =cloudstorage();
  FirebaseAuth _auth =FirebaseAuth.instance;
  List downloadlist =[];
  bool isdownloads= false;
  bool downloadstart =false;
  final snackBar = SnackBar(
    content: const Text('Uploaded!'),
    action: SnackBarAction(
      label: 'close',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: (isdownloads)?FloatingActionButton(
        onPressed: (downloadlist.length>0&&!downloadstart)? ()async{
          setState(() {
            downloadstart=true;
          });
          while(downloadlist.length>0){

            dynamic result = await c1
                .downloadmaterials(
                widget.classdetails.id,
                downloadlist[0]['path'],
                downloadlist[0]['filename']);
            await c1.downloadTask!.snapshotEvents.listen((event) {
              setState(() {
                downloadlist[0]['progress']=(event.bytesTransferred/event.totalBytes*100).round();
              });


            });
            await c1.downloadTask!
                .whenComplete(() async{
              await download_db.instance.adddata(downloadlist[0]['filename'], DateTime.now().toString(), result,_auth.currentUser!.uid,widget.classdetails.id);
              downloadlist.remove(downloadlist.first);
              setState(() {

              });

            });
          setState(() {
            downloadstart=false;
          });



        }}:null,
        child: Icon(Icons.download),

      ):FloatingActionButton(
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
                        Expanded(child: SizedBox()),
                        IconButton(onPressed: ()async{
                          await Navigator.push(context, MaterialPageRoute(builder: (context)=>previousdownloads(classdata: widget.classdetails)));
                          setState(() {

                          });
                        }, icon: Icon(Icons.history,size: 30,color: Colors.white,))
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(onPressed: (){
                        isdownloads=false;
                        setState(() {

                        });
                      }, child: Text('Files',style: TextStyle(color: (isdownloads)?Colors.grey:Colors.blue,fontSize: 20),)),
                      TextButton(onPressed: (){
                        isdownloads=true;
                        setState(() {

                        });
                      }, child: Text('Downloads(${downloadlist.length})',style: TextStyle(color: (!isdownloads)?Colors.grey:Colors.blue,fontSize: 20),))
                    ],
                  ),
                  SizedBox(height: 10,),
                  (!isdownloads)?FutureBuilder<DocumentSnapshot>(future:store.collection('LMS').doc(widget.classdetails.id).get(),builder: (context,snapshot){
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

                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width*0.3,
                                                  child: Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(lmsdocs[i]['date'])),style: TextStyle(fontSize: 15,color: Colors.blueAccent),),
                                                ),

                                                Container(
                                                  width: MediaQuery.of(context).size.width*0.4,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      ElevatedButton(onPressed: ()async{

                                                        setState(() {
                                                          downloadlist.add({
                                                            'title':lmsdocs[i]['title'],
                                                            'path':lmsdocs[i]['path'],
                                                            'filename':lmsdocs[i]['filename'],
                                                            'progress':0
                                                          });

                                                        });

                                                      }, child:Icon(Icons.download),style: ElevatedButton.styleFrom(
                                                        shape: CircleBorder(),
                                                        padding: EdgeInsets.all(10),
                                                        primary: Colors.blue,
                                                        onPrimary: Colors.white,
                                                      ),),
                                                      ElevatedButton(onPressed: ()async{
                                                       await showDialog(context: context, builder: (BuildContext context) {
                                                          return  AlertDialog(
                                                            title: Text("Error"),
                                                            content: Text(
                                                                'Unable to find the file,may be deleted Please download again'
                                                            ),
                                                            actions: [
                                                              Container(
                                                                  padding: EdgeInsets.all(10),
                                                                  child:Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      TextButton(
                                                                        onPressed: ()async{
                                                                          await c1.deletematerirals(widget.classdetails.id, lmsdocs[i]['path'], lmsdocs[i]);

                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: Text('Confirm',style: TextStyle(fontSize: 18),),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: (){


                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: Text('Cancel',style: TextStyle(fontSize: 18)),
                                                                      )
                                                                    ],
                                                                  )
                                                              )
                                                            ],
                                                          );
                                                        });
                                                       setState(() {

                                                       });

                                                      }, child:Icon(Icons.delete),style: ElevatedButton.styleFrom(
                                                        shape: CircleBorder(),
                                                        padding: EdgeInsets.all(10),
                                                        primary: Colors.redAccent,
                                                        onPrimary: Colors.white,
                                                      ),)
                                                    ],
                                                  ),
                                                )

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
                  }):Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height*0.7,
                        child: ListView.builder(itemCount: downloadlist.length,itemBuilder: (context,i){
                          return Column(
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width*0.9,

                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  padding: EdgeInsets.all(15),
                                  child:Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width*0.5,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(downloadlist[i]['title'],style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.blue
                                              ),),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          width: MediaQuery.of(context).size.width*0.3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              (downloadstart)? Column(
                                                children: [
                                                  Text((i!=0)?'Waiting':"${downloadlist[i]['progress']}%",style: TextStyle(fontSize:(i!=0)?20:25,color: Colors.blue),),
                                                  (i==0)? Text('Progress',style: TextStyle(fontSize: 15,color: Colors.blue)):Text("")
                                                ],
                                              ):Text('Not Started',style: TextStyle(fontSize:15,color: Colors.blue),),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                              SizedBox(height: 10,)
                            ],
                          );

                        }),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
