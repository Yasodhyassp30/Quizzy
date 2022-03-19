import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud/screen/login.dart';
import 'package:cloud/screen/teachers/teachershome.dart';
import 'package:cloud/wrappers/homewrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../service/authservice.dart';

class studentregistration extends StatefulWidget {
  const studentregistration({Key? key}) : super(key: key);

  @override
  _studentregistrationState createState() => _studentregistrationState();
}

class _studentregistrationState extends State<studentregistration> {
  bool obsecure=true;
  bool loading =false;
  String error="";
  TextEditingController firstname=TextEditingController();
  TextEditingController lastname=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController school=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController confirm=TextEditingController();
  TextEditingController mobile=TextEditingController();
  @override
  Widget build(BuildContext context) {
    if(loading){
      return loadfadingcube();
    }else{
      return Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.lightBlue[400],
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Container(

                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[200],
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),

                      ),
                      padding: EdgeInsets.all(10),

                      child: Column(
                        children: [
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
                          Text('Quizzy',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 50,color: Colors.white)),),
                          Text('Create Student Account',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20,color: Colors.blue[400])),),
                          SizedBox(height: 10.0,),
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width*0.44,
                                child:TextField(
                                  controller: firstname,
                                  decoration: InputDecoration(
                                      border:OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.7),
                                      hintText: "First Name",
                                      hintStyle:
                                      TextStyle(color: Colors.grey[600], fontSize: 18.0)
                                  ),
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Container(
                                width: MediaQuery.of(context).size.width*0.44,
                                child:TextField(
                                  controller: lastname,
                                  decoration: InputDecoration(
                                      border:OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.7),
                                      hintText: "Last Name",
                                      hintStyle:
                                      TextStyle(color: Colors.grey[600], fontSize: 18.0)
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          TextField(
                            controller: email,
                            decoration: InputDecoration(
                                border:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.7),
                                hintText: "Email address",
                                hintStyle:
                                TextStyle(color: Colors.grey[600], fontSize: 18.0)
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          TextField(
                            controller: mobile,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.7),
                                hintText: "Mobile Number",
                                hintStyle:
                                TextStyle(color: Colors.grey[600], fontSize: 18.0)
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          TextField(
                            controller: school,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.7),
                                hintText: "School",
                                hintStyle:
                                TextStyle(color: Colors.grey[600], fontSize: 18.0)
                            ),
                          ),
                          SizedBox(height: 10,),
                          TextField(
                              controller: password,
                              obscureText: obsecure,
                              decoration: InputDecoration(
                                  border:OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.7),
                                  hintText: "Password",
                                  hintStyle:
                                  TextStyle(color: Colors.grey[600], fontSize: 18.0),
                                  suffix: InkWell(
                                    onTap: () {
                                      setState(() {
                                        obsecure = !obsecure;
                                      });
                                    },
                                    child: Icon((obsecure)
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,size: 20,),
                                  ))
                          ),
                          SizedBox(height: 10,),
                          TextField(
                              controller: confirm,
                              obscureText: obsecure,
                              decoration: InputDecoration(
                                  border:OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.7),
                                  hintText: "Confirm Password",
                                  hintStyle:
                                  TextStyle(color: Colors.grey[600], fontSize: 18.0),
                                  suffix: InkWell(
                                    onTap: () {
                                      setState(() {
                                        obsecure = !obsecure;
                                      });
                                    },
                                    child: Icon((obsecure)
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,size: 20,),
                                  ))
                          ),
                          SizedBox(height: 18,),
                          Row(
                            children: [
                              SizedBox(width: 10.0,),
                              Expanded(child:  ElevatedButton(onPressed: ()async{
                                setState(() {
                                  loading=true;
                                });
                                authService _auth =authService();
                                dynamic result;
                                if(email.text!=""&&password.text!=""&&firstname.text!=""&&lastname.text!=""&&mobile.text!=""&&school.text!="") {
                                  dynamic result = await _auth
                                      .registerwithEmailstudent(
                                      email.text.trim(),
                                      password.text,
                                      lastname.text,
                                      firstname.text,
                                      [],
                                      mobile.text,
                                      school.text);
                                  setState(() {
                                    loading=true;
                                    if(result!=null){
                                      loading=false;
                                    }
                                  });
                                  if(result!=null){
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => homewrapper(),
                                      ),
                                          (route) => false,
                                    );
                                  }
                                }else{
                                  if(password.text!=confirm.text){
                                    setState(() {
                                      error="Passwords not Matching";
                                    });
                                  }else{
                                    setState(() {
                                      error="Fill All Fields";
                                    });
                                  }
                                  if(mobile.text.length>0){
                                    if(mobile.text.length!=10){
                                      setState(() {
                                        error="Invalid Mobile number";
                                      });
                                    }
                                  }
                                }

                              }, child: Container(
                                padding: EdgeInsets.all(20),
                                child: Text("Register",style: TextStyle(fontSize: 20),),
                              ))),
                              SizedBox(width: 10.0,),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("I already have an account"),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => login()));
                                  },
                                  child: Text(
                                    "Log in",
                                    style: TextStyle(color: Colors.blue),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),

                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
