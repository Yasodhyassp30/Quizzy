import 'package:cloud/screen/teachers/classdetails.dart';
import 'package:cloud/screen/teachers/teachershome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class userdetails extends StatelessWidget {
  final details,id;
  const userdetails({Key? key,this.details,this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map data =details.data() as Map;
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: SafeArea(
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
                      IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(
                        Icons.arrow_back,size: 30,color: Colors.white,
                      )),
                      SizedBox(width: 10.0,),
                      Text('Back',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width*0.3,
                  foregroundImage: (data.containsKey('pic'))?NetworkImage(data['pic']):AssetImage('assets/studentavatar.png') as ImageProvider,
                ),
                SizedBox(height: 10,),
                Padding(padding: EdgeInsets.all(10),child: Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    children: [
                      Text(data['firstname']+' '+data['lastname'],style: TextStyle(color: Colors.lightBlue,fontSize: 20),),
                      Text(data['Contact_No']),
                      Text(data['Email']),
                      (data.containsKey('school'))?Text(data['school'],style: TextStyle(color: Colors.lightBlue,fontSize: 15),):Text(data['subject'],style: TextStyle(color: Colors.lightBlue,fontSize: 20),),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
