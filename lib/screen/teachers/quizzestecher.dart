import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class typeselection extends StatefulWidget {
  const typeselection({Key? key}) : super(key: key);

  @override
  State<typeselection> createState() => _typeselectionState();
}

class _typeselectionState extends State<typeselection> {
  @override
  Widget build(BuildContext context) {
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
                     height: MediaQuery.of(context).size.height*0.4,
                     child: Column(
                       children: [
                         Container(
                           padding: EdgeInsets.all(25),
                           height: MediaQuery.of(context).size.height*0.1,
                           decoration: BoxDecoration(
                             color: Colors.blue[500],
                             borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),


                           ),
                           child: Row(
                             children: [
                               SizedBox(width: 10.0,),
                               Text('Quizzy Assesments',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.white)),),
                             ],
                           ),
                         ),
                         SizedBox(height: 20,),
                         ElevatedButton(onPressed: (){},child: Container(
                           height: MediaQuery.of(context).size.height*0.07,
                           width: MediaQuery.of(context).size.width*0.8,
                           child: Row(
                             children: [
                               Icon(Icons.create),
                               Text('Create a Online Quiz')
                             ],
                           ),
                         ),),
                         SizedBox(height: 20,),
                         ElevatedButton(onPressed: (){},child: Container(
                           height: MediaQuery.of(context).size.height*0.07,
                           width: MediaQuery.of(context).size.width*0.8,
                           child: Row(
                             children: [
                               Icon(Icons.move_to_inbox_rounded),
                               Text('Create a Quiz with Submission Box')
                             ],
                           ),
                         ),),
                         SizedBox(height: 20,),
                       ],
                     ),
                   ),
                    SizedBox(height: 10,),
                    Container(
                      height: MediaQuery.of(context).size.height*0.4,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/Quizhome.png')
                        )
                      ),
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
