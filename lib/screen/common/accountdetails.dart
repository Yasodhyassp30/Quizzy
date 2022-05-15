import 'dart:io';

import 'package:cloud/screen/teachers/teachershome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../loadingscreens/loadingscreen.dart';
import '../login.dart';

class account_details extends StatefulWidget {
  final user;
  const account_details({Key? key,this.user}) : super(key: key);

  @override
  State<account_details> createState() => _account_detailsState();
}

class _account_detailsState extends State<account_details> {
  final Imagepic =ImagePicker();
  FirebaseAuth _auth =FirebaseAuth.instance;
  String error ="";
  FirebaseFirestore store =FirebaseFirestore.instance;
  TextEditingController email =TextEditingController();
  TextEditingController phone =TextEditingController();
  TextEditingController password =TextEditingController();
  TextEditingController confirm =TextEditingController();
  int index=1;
  File ? name;
  bool obsecure=true,loading =false,updated=false;
  @override
  Widget build(BuildContext context) {
    String? pic =_auth.currentUser!.photoURL;
      if(loading){
        return loadfadingcube();
      }
      return Scaffold(
        backgroundColor: Colors.lightBlue[100],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(16),
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
                        Expanded(child: Container(

                          child: Text('Edit Profile',overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.amber,
                      foregroundImage: (pic==null)?AssetImage(
                          'assets/studentavatar.png'):NetworkImage(pic) as ImageProvider
                  ),
                  SizedBox(height: 10,),
                  OutlinedButton(onPressed: ()async{
                    final picked =await Imagepic.pickImage(source: ImageSource.camera);
                    name=File(picked!.path);
                    FirebaseStorage ? storage=FirebaseStorage.instance;
                    var stroeref=storage.ref().child("image/${_auth.currentUser!.uid}");
                    setState(() {
                      loading=true;
                    });
                    if(name!=null){
                      var upload= await stroeref.putFile(name!);
                      String ? completed= await upload.ref.getDownloadURL();
                      await _auth.currentUser!.updatePhotoURL(completed);
                      await store.collection('userdata').doc(_auth.currentUser!.uid).update(
                          {
                            'pic':completed
                          });

                      pic=completed;
                      setState(() {
                        loading=false;
                      });

                    }

                  }, child: Text('Change Profile photo'),style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 2.0, color: Colors.blue),
                  ),),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 10,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Personal Details',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                          Center(child:Text(error,style: TextStyle(color: Colors.red),)),
                          SizedBox(height: 10,),
                          TextField(
                            controller: email,
                            decoration: InputDecoration(
                                hintText: widget.user['Email']
                            ),

                          ),
                          SizedBox(height: 10,),
                          TextField(
                            controller: phone,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: widget.user['Contact_No']
                            ),

                          ),
                          TextField(
                            controller: password,
                            obscureText: obsecure,
                            decoration: InputDecoration(
                              hintText: 'Old Password',
                              suffix: InkWell(
                                onTap: () {
                                  setState(() {
                                    obsecure = !obsecure;
                                  });
                                },
                                child: Icon((obsecure)
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                              ),


                            ),

                          ),
                          SizedBox(height: 10,),
                          TextField(
                            controller: confirm,
                            obscureText: obsecure,
                            decoration: InputDecoration(
                              hintText: 'New Password',
                              suffix: InkWell(
                                onTap: () {
                                  setState(() {
                                    obsecure = !obsecure;
                                  });
                                },
                                child: Icon((obsecure)
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                              ),


                            ),

                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(onPressed: ()async{
                                setState(() {
                                  loading=true;
                                });
                                Map <String,dynamic> newdata =new Map();
                                if(phone.text.trim().isNotEmpty){
                                  newdata['Contact_No']=phone.text.trim();
                                }
                                await store.collection('userdata').doc(_auth.currentUser!.uid).update(newdata);
                                try{
                                  if(email.text.trim().isNotEmpty){
                                    try{
                                      _auth.currentUser!.updateEmail(email.text.trim());
                                    }catch(e){
                                      setState(() {
                                        error='Invalid Email';
                                      });
                                    }
                                    newdata['Email']=email.text.trim();
                                    await store.collection('userdata').doc(_auth.currentUser!.uid).update(newdata);
                                  }

                                  final cred = EmailAuthProvider.credential(
                                      email: _auth.currentUser!.email!, password: password.text.trim());
                                  if(confirm.text.trim().isNotEmpty){
                                    await _auth.currentUser!.reauthenticateWithCredential(cred).then((value)async{
                                      try{
                                        await _auth.currentUser!.updatePassword(confirm.text.trim());
                                        updated=true;
                                      }catch(e){
                                        setState(() {
                                          error ='Password invalid';
                                        });
                                      }
                                    });
                                  }
                                  if(confirm.text.trim().isNotEmpty&&updated){
                                    await _auth.signOut();
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>login()), (route) => false);

                                  }else {
                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                teachershome()), (
                                            route) => false);
                                  }
                                }catch(e){
                                  setState(() {
                                    error='Invalid Details';
                                    loading=false;
                                  });
                                }


                              }, child: Text('Update Details',style: TextStyle(fontSize: 18),))
                            ],
                          ),


                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 16,right: 16),
                    child: Row(
                      children: [
                        Expanded(child: ElevatedButton(onPressed: ()async{
                          FirebaseAuth _auth =FirebaseAuth.instance;
                          await _auth.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>login(),
                            ),
                                (route) => false,
                          );
                        }, child: Text('Sign Out',style: TextStyle(
                            color: Colors.white,fontSize: 20

                        ),),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                            padding: EdgeInsets.all(8)
                          ),
                        ))
                      ],
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      );
    }
}
