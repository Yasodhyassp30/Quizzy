
import 'package:cloud/loadingscreens/loadingscreen.dart';
import 'package:cloud/screen/accountselection.dart';
import 'package:cloud/screen/teachers/teachershome.dart';
import 'package:cloud/service/authservice.dart';
import 'package:cloud/wrappers/homewrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  bool obsecure=true;
  String error="";
  bool loading =false;
  authService _auth =authService();
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  @override
  Widget build(BuildContext context) {
    if(loading){
      return loadfadingcube();
    }else{
      return Scaffold(
        body: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width
          ),
          child:Container(
            color: Colors.lightBlue[100],
            child: SafeArea(
              child:SingleChildScrollView(

                child:Container (
                  color: Colors.lightBlue[100],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
                          color: Colors.lightBlue[200],
                        ),
                        child:  Container(
                          padding: EdgeInsets.all(16),
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
                              Text('Quizzy',style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 40,color: Colors.white)),),
                              SizedBox(height: 10,),
                              Text(error,style: TextStyle(fontSize: 15,color: Colors.redAccent),),
                              TextField(
                                controller: email,
                                decoration: InputDecoration(
                                    border:OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: "Email address",
                                    hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 18.0)
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
                                      fillColor: Colors.white,
                                      hintText: "Password",
                                      hintStyle:
                                      TextStyle(color: Colors.grey, fontSize: 18.0),
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
                              SizedBox(height: 20.0,),
                              Row(
                                children: [
                                  Expanded(child:  ElevatedButton(onPressed: ()async{
                                    if(email.text!=""&&password.text!=""){
                                      setState(() {
                                        loading=true;
                                      });
                                      dynamic result =await _auth.Signin_with_email(email.text.trim(), password.text);

                                      if(result==null){
                                        setState(() {
                                          error='Login Faild';
                                          loading=false;
                                        });
                                      }else{
                                        error="";
                                        loading=false;
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) => homewrapper(),
                                          ),
                                              (route) => false,
                                        );
                                      }


                                    }else{
                                      setState(() {
                                        error='Fill all fields';
                                      });
                                    }
                                  }, child: Container(
                                    padding: EdgeInsets.all(20),
                                    child: Text("Log in",style: TextStyle(fontSize: 20),),
                                  )),)
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("I don't have an account"),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => accountselect()));
                                      },
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(color: Colors.blue),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [

                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height*0.3,
                                child: Image(
                                  image: AssetImage(
                                      'assets/teachersreg.png'
                                  ),
                                )
                            ),
                            SizedBox()

                          ],
                        ),
                      )



                    ],
                  ),
                ),
              ),
            ),
          )

        )
      );
    }
  }
}
