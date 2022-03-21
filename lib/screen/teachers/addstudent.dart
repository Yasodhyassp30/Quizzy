import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class studentadd extends StatefulWidget {
  final classroomid;
  const studentadd({Key? key,this.classroomid}) : super(key: key);

  @override
  _studentaddState createState() => _studentaddState();
}

class _studentaddState extends State<studentadd> {
  FirebaseFirestore store= FirebaseFirestore.instance;
  List data=[];
  List invited=[];
  List members=[];
  bool serached=false;
  TextEditingController searchkey =TextEditingController();
  final snackBar = SnackBar(
    content: const Text('Copied!'),
    action: SnackBarAction(
      label: 'close',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(future:store.collection('classrooms').doc(widget.classroomid.id).get(),builder: (context,snap){
      if(snap.connectionState==ConnectionState.waiting){
        return loadfadingcube();
      }else{
        invited=snap.data!.get('invited');
        members=snap.data!.get('students');
        return Scaffold(
          body: ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: Container(
              color: Colors.lightBlue[100],
              child: SafeArea(
                child: Container(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(25),
                            height: MediaQuery.of(context).size.height*0.1,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),


                            ),
                            child: Row(
                              children: [
                                IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(
                                  Icons.arrow_back,size: 30,color: Colors.white,
                                )),
                                SizedBox(width: 10.0,),
                                Text('Add Student',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25,color: Colors.white)),),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Text('Invite by Email',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25,color: Colors.blue[600])),),
                                  SizedBox(height: 10,),
                                  TextField(
                                      controller: searchkey,
                                      decoration: InputDecoration(
                                        border:OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: "Email",
                                        hintStyle:
                                        TextStyle(color: Colors.grey, fontSize: 18.0),
                                      )
                                  ),
                                  SizedBox(height: 10,),
                                  Row(children: [
                                    Expanded(child: ElevatedButton(onPressed: ()async{

                                      var result =await store.collection('userdata').where('Email',isEqualTo:searchkey.text.trim().toLowerCase() ).where('type',isEqualTo: 2).get();

                                      if(result.docs.length>0){
                                        data=result.docs;
                                      }else{
                                        data=[];
                                      }
                                      setState(() {
                                        serached=true;
                                      });
                                    },
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.blue,
                                            onPrimary: Colors.white

                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(15),

                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.search),
                                              SizedBox(width: 2,),
                                              Text('Search',style: TextStyle(fontSize: 20),)
                                            ],
                                          ),
                                        )))
                                  ],),
                                  SizedBox(height: 10,),

                                  SizedBox(height: 10,),
                                  (serached)? Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('Search Results',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25,color: Colors.blue[600])),),
                                          Expanded(child: SizedBox()),
                                          IconButton(onPressed: (){
                                            setState(() {
                                              serached=false;
                                            });
                                          }, icon: Icon(Icons.clear,color: Colors.blue[600],))
                                        ],
                                      ),
                                      Container(

                                        height: MediaQuery.of(context).size.height*0.15,
                                        child:  ListView.builder(itemCount:data.length,
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            physics: ScrollPhysics(),
                                            itemBuilder: (context,i){
                                              return Column(
                                                children: [


                                                  Container(
                                                      width: MediaQuery.of(context).size.width*0.9,
                                                      padding: EdgeInsets.all(15),
                                                      decoration: BoxDecoration(
                                                          color: Colors.lightBlue[500],
                                                          borderRadius: BorderRadius.circular(15)

                                                      ),
                                                      child:Row(
                                                        children: [
                                                          Container(
                                                            height: 80,
                                                            width: 80,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Colors.white,
                                                                image: DecorationImage(
                                                                    image: AssetImage('assets/studentavatar.png'),
                                                                    fit: BoxFit.fill
                                                                )
                                                            ),
                                                          ),
                                                          SizedBox(width: 10,),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                width:MediaQuery.of(context).size.width*0.4,
                                                                height: MediaQuery.of(context).size.height*0.05,
                                                                child: Text(data[i]['firstname']+" "+data[i]['lastname'],style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white,overflow:TextOverflow.ellipsis)),),
                                                              ),
                                                              Text('${data[i]['school']}',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 15,color: Colors.white)),),
                                                            ],
                                                          ),
                                                          Expanded(child: SizedBox()),
                                                          (members.contains(data[i]['uid']))?Container(
                                                            width: MediaQuery.of(context).size.width*0.2,
                                                            height: MediaQuery.of(context).size.height*0.05,
                                                            child: Center(
                                                              child: Text('Already Member',style: TextStyle(color: Colors.blue[700]),),
                                                            )
                                                          ):(invited.contains(data[i]['uid'])?Container(
                                                              width: MediaQuery.of(context).size.width*0.2,
                                                              height: MediaQuery.of(context).size.height*0.05,
                                                              child: Center( child: Text('Invited',style: TextStyle(color: Colors.blue[700]),),)
                                                          ):IconButton(onPressed: ()async{
                                                            databaseService d1=databaseService(uid: data[i]['uid']);
                                                            await d1.invitestudent(data[i]['uid'], widget.classroomid.id,widget.classroomid['title']);
                                                            setState(() {

                                                            });

                                                          }, icon: Icon(Icons.send,size: 30,color: Colors.white,),
                                                          ))
                                                        ],
                                                      )
                                                  ),
                                                  SizedBox(height: 10.0,),
                                                ],
                                              );
                                            }),
                                      )
                                    ],
                                  ):Container()
                                ],
                              )
                          ),
                          SizedBox(height: 10,),

                          Text('Invite by code',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 25,color: Colors.blue[600])),),
                         SizedBox(height: 10,),
                         Container(
                           width: MediaQuery.of(context).size.width*0.9,
                           decoration: BoxDecoration(
                             color: Colors.blue[300],
                             borderRadius: BorderRadius.circular(20)
                           ),
                           padding: EdgeInsets.all(20),
                           child:  Row(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               Container(
                                   padding: EdgeInsets.all(10),
                                   child:Text(widget.classroomid.id)
                               ),
                               IconButton(onPressed: () =>
                               {
                                 Clipboard.setData(ClipboardData(text: widget.classroomid.id))
                                     .then((value) { //only if ->
                                   ScaffoldMessenger.of(context).showSnackBar(snackBar);})
                               }
                                   , icon: Icon(Icons.copy))
                             ],
                           ),
                         )



                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }

    });

  }
}
