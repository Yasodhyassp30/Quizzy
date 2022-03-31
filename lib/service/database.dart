import 'package:cloud_firestore/cloud_firestore.dart';

class databaseService{
  final String ?uid;

  databaseService({this.uid});

  final CollectionReference userdetails = FirebaseFirestore.instance.collection('userdata');
  final CollectionReference classrooms = FirebaseFirestore.instance.collection('classrooms');
  final CollectionReference notifications = FirebaseFirestore.instance.collection('notifications');


  Future ? setTeacherdata(String ?firstname,String ? lastname, String ?Phoneno, String ?email,List<String>classes,String subject) async {
    return await userdetails.doc(uid).set(
        {
          'uid':uid,
          'type':1,
          'firstname': firstname,
          'lastname':lastname,
          'Contact_No': Phoneno,
          'Email': email,
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
          "school":school
        }
    );
  }
  Future invitestudent(String studentuid,String classroomid,String classroomname)async{
    FirebaseFirestore store =FirebaseFirestore.instance;
    await classrooms.doc(classroomid).set({
      'invited':FieldValue.arrayUnion([studentuid])
    },SetOptions(merge: true));
    await notifications.doc(studentuid).set({
      'notifications':FieldValue.arrayUnion([
        {
          'title':classroomname,
          'classroomid':classroomid,
          'date':DateTime.now(),
          'new':true,
          'temp':false
        }
      ])
    },SetOptions(merge: true));


  }
  Future accpetinvite(String classid,String studentid,Map e )async{
   await classrooms.doc(classid).update({'students':FieldValue.arrayUnion([studentid]),'invited':FieldValue.arrayRemove([studentid])});
   await notifications.doc(studentid).update({'notifications':FieldValue.arrayRemove([e])});
  }
  Future rejectinvite(String classid,String studentid,Map e )async{
    await classrooms.doc(classid).update({'invited':FieldValue.arrayRemove([studentid])});
    await notifications.doc(studentid).update({'notifications':FieldValue.arrayRemove([e])});
  }
  Future accpetrequest(String classid,String studentid )async{
    await classrooms.doc(classid).update({'students':FieldValue.arrayUnion([studentid]),'requested':FieldValue.arrayRemove([studentid])});
  }
  Future rejectrequest(String classid,String studentid )async{
    await classrooms.doc(classid).update({'requested':FieldValue.arrayRemove([studentid])});
  }
}