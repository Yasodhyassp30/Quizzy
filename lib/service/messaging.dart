import 'package:cloud_firestore/cloud_firestore.dart';

class messaging{
  String ? uid;
  messaging({this.uid});
  FirebaseFirestore messags =FirebaseFirestore.instance;


  Future sendmessage(String reciver,String message)async{
    await messags.collection('messages').doc(uid).set({
      reciver:FieldValue.arrayUnion([{
        'sender':uid,
        'reciver':reciver,
        'message':message,
        'time':DateTime.now()
      }])
    },SetOptions(merge: true));
    await messags.collection('messages').doc(reciver).set({
      uid!:FieldValue.arrayUnion([{
        'sender':uid,
        'reciver':reciver,
        'message':message,
        'time':DateTime.now()
      }])
    },SetOptions(merge: true));
  }

  Future groupmsg(String classroomid,String message,String name)async{
    await messags.collection('messages').doc(classroomid).set({
      'messages':FieldValue.arrayUnion([{
        'sender':uid,
        'reciver':classroomid,
        'message':message,
        'name':name,
        'time':DateTime.now()
      }])
    },SetOptions(merge: true));
  }
}