import 'package:cloud/screen/studentregister.dart';
import 'package:cloud/screen/teacherregiser.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class accountselect extends StatefulWidget {
  const accountselect({Key? key}) : super(key: key);

  @override
  _accountselectState createState() => _accountselectState();
}

class _accountselectState extends State<accountselect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlue[100],
        height: MediaQuery.of(context).size.height,

        child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      height: MediaQuery.of(context).size.height*0.3,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[300],
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),

                      ),
                      child: Container(

                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/accountselect.png'
                              ),
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Container(
                      height: MediaQuery.of(context).size.height*0.1,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/studentregister.png'
                            ),
                          )
                      ),
                    ),
                    Text('Quizzy',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 80,color: Colors.white)),),
                    Text('Select Account',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.blue[400])),),
                    SizedBox(height: 10,),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Expanded(child: ElevatedButton(
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>teacherreg()),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    child: Text("Teachers",style: TextStyle(fontSize: 18),),
                                  ),
                                ))
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Expanded(child: ElevatedButton(
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>studentregistration()),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    child: Text("Students",style: TextStyle(fontSize: 18),),
                                  ),
                                ))
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("I already have an account"),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Sign in",
                              style: TextStyle(color: Colors.blue),
                            ))
                      ],
                    ),
                    SizedBox(height: 10.0,)

                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }
}
