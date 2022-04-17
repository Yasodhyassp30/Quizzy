import 'package:cloud/service/storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io'; // for File

class materialupload extends StatefulWidget {
  final classdata;
  const materialupload({Key? key,this.classdata}) : super(key: key);

  @override
  _materialuploadState createState() => _materialuploadState();
}

class _materialuploadState extends State<materialupload> {
  @override
  FilePickerResult? result;
  int progress=0;
  bool isuploading =false;
  String filetitle ="";
  List downloadlist =[];
  bool uploading =false;
  final snackBar = SnackBar(
    content: const Text('Uploaded!'),
    action: SnackBarAction(
      label: 'close',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  TextEditingController title= TextEditingController();
  TextEditingController message =TextEditingController();
  Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: (uploading)?ConstrainedBox(
          constraints: new BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: SafeArea(
            child: Container(
                color: Colors.lightBlue[100],
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
                          IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(
                            Icons.arrow_back,size: 30,color: Colors.white,
                          )),
                          SizedBox(width: 10.0,),
                          Text('Upload Materials',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(onPressed: (){
                          setState(() {
                            uploading=false;
                          });
                        }, child: Text('Select',style: TextStyle(fontSize: 20,color: (uploading)?Colors.grey:Colors.blue),)),
                        TextButton(onPressed: (){
                          setState(() {
                            uploading=true;
                          });
                        }, child: Text((downloadlist.length>0)?'Upload(${downloadlist.length})':'Upload',style: TextStyle(fontSize: 20,color: (uploading)?Colors.blue:Colors.grey),))
                      ],
                    ),
                    SizedBox(height: 10,),
                    (downloadlist.length>0)? Container(
                      height: MediaQuery.of(context).size.height*0.6,
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
                                            (isuploading)? Column(
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

                      }) ,
                    ):Container(child: Center(child: Text("No Files to Upload",style: TextStyle(fontSize: 20,color: Colors.blue),),),),
                    Expanded(child: SizedBox()),
                    Container(
                      padding: EdgeInsets.all(20),
                      child:  Row(
                        children: [
                          Expanded(child: ElevatedButton.icon(onPressed:(downloadlist.length>0&&!isuploading)? ()async{
                            setState(() {
                              isuploading=true;
                            });
                            while(downloadlist.length>0){
                              cloudstorage c1=cloudstorage();
                              await  c1.uploadmaterials(downloadlist[0]['file'], widget.classdata.id, downloadlist[0]['message'], downloadlist[0]['title'],downloadlist[0]['filename']!,DateTime.now().toString());
                              await c1.upload!.snapshotEvents.listen((event) {
                                setState(() {
                                  downloadlist[0]['progress']=(event.bytesTransferred/event.totalBytes*100).round();
                                });
                              });
                              await c1.upload!.whenComplete((){ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              downloadlist.remove(downloadlist.first);
                              });
                            }
                            setState(() {
                              isuploading=false;
                            });



                          }:null, label: Text('Upload'),icon: Icon(Icons.upload), style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(20),
                            primary: Colors.blue[800],
                            onPrimary: Colors.white,
                          ),))
                        ],
                      ),
                    )
                  ],
                )
            ),
          ),
        ):ConstrainedBox(
          constraints: new BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: SafeArea(
            child: Container(
                color: Colors.lightBlue[100],
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
                          IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(
                            Icons.arrow_back,size: 30,color: Colors.white,
                          )),
                          SizedBox(width: 10.0,),
                          Text('Upload Materials',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(onPressed: (){
                          setState(() {
                            uploading=false;
                          });
                        }, child: Text('Select',style: TextStyle(fontSize: 20,color: (uploading)?Colors.grey:Colors.blue),)),
                        TextButton(onPressed: (){
                          setState(() {
                            uploading=true;
                          });
                        }, child: Text((downloadlist.length>0)?'Upload(${downloadlist.length})':'Upload',style: TextStyle(fontSize: 20,color: (uploading)?Colors.blue:Colors.grey),))
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            controller: title,
                            decoration: InputDecoration(
                                border:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),

                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Title",
                                hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 18.0)
                            ),
                          ),
                          SizedBox(height: 20,),
                          TextField(
                            controller: message,
                            decoration: InputDecoration(
                                border:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),

                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Message",
                                hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 18.0)
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                          ),
                          SizedBox(height: 10,),
                          (result!=null)?Row(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(20),
                                  width: MediaQuery.of(context).size.width*0.9,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[600],
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.6,
                                        child: Text(result!.names[0]!,style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,),
                                      ),
                                      Expanded(child: SizedBox()),
                                      IconButton(onPressed: (){
                                        setState(() {
                                          result=null;
                                        });
                                      }, icon: Icon(Icons.clear,size: 30,color: Colors.white,))
                                    ],
                                  )
                              ),

                            ],
                          ):Text(""),
                          SizedBox(height: 10),
                          ElevatedButton(onPressed: ()async{
                            result = await FilePicker.platform.pickFiles();
                            setState(() {

                            });

                          }, child:Text('Pick File'), )
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Expanded(child: SizedBox()),
                    Container(
                      padding: EdgeInsets.all(20),
                      child:  Row(
                        children: [
                          Expanded(child: ElevatedButton.icon(onPressed:(title.text.trim().length>0&&message.text.trim().length>0&&result!=null)? ()async{
                            var path =result!.paths[0];
                            var filename =result!.names[0];
                            File file = File(path!);
                            downloadlist.add({
                              'title':title.text.trim(),
                              'message':message.text.trim(),
                              'file':file,
                              'filename':filename,
                              'progress':0
                            });
                            title.clear();
                            message.clear();
                            result=null;
                            setState(() {

                            });

                          }:null, label: Text('Add to Upload'),icon: Icon(Icons.add), style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(20),
                            primary: Colors.blue[800],
                            onPrimary: Colors.white,
                          ),))
                        ],
                      ),
                    )
                  ],
                )
            ),
          ),
        ),
      );

  }

}
