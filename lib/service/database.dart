import 'package:cloud_firestore/cloud_firestore.dart';

class databaseService{
  final String ?uid;

  databaseService({this.uid});

  final CollectionReference userdetails = FirebaseFirestore.instance.collection('userdata');


  Future ? setTeacherdata(String ?firstname,String ? lastname, String ?Phoneno, String ?email,List<String>classes,String subject) async {
    return await userdetails.doc(uid).set(
        {
          'uid':uid,
          'type':1,
          'firstname': firstname,
          'lastname':lastname,
          'Contact_No': Phoneno,
          'Email': email,
          "classes":[],
          "subject":subject
        }
    );
  }
  Future ? setstudentdata(String ?firstname,String ? lastname, String ?Phoneno, String ?email,List<String>classes,String school) async {
    return await userdetails.doc(uid).set(
        {
          'uid':uid,
          'type':2,
          'firstname': firstname,
          'lastname':lastname,
          'Contact_No': Phoneno,
          'Email': email,
          "classes":[],
          "school":school
        }
    );
  }
}