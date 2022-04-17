import 'package:cloud/service/messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class cloudstorage{
  FirebaseStorage ? store=FirebaseStorage.instance;
  FirebaseAuth _auth =FirebaseAuth.instance;
  UploadTask ? upload;
  DownloadTask ? downloadTask;

  Future  addquizzes(String uid,Map data)async {
    String date = DateTime.now().toString();
    Map questdata = {
      'Question': data['question'],
      'type': data['type'],
      'marks': data['marks'],
      'date': DateTime.now().toString()
    };
    if (data['type'] != 'Text Answer') {
      questdata['answers'] = data['answers'];
    }
    if (data.containsKey('real')) {
      questdata['real'] = data['real'];
    }
    if (data.containsKey('pic')) {
      questdata['filename'] = data['filename'];
      var ref = store!.ref('quiz/${uid}/${date + questdata['filename']}');
      upload = ref.putFile(data['pic']);
      await upload!.whenComplete(() async {
        questdata['URL'] = await ref.getDownloadURL();
      });

      questdata['path'] = 'quiz/${uid}/${date + questdata['filename']}';
      upload!.whenComplete(() async {
        FirebaseFirestore quiz = FirebaseFirestore.instance;
        await quiz.collection('Quizzes').doc(uid).set({
          'Questions': FieldValue.arrayUnion([questdata])
        }, SetOptions(merge: true));
        questdata.remove('real');
        await quiz.collection('studentquiz').doc(uid).set({
          'Questions': FieldValue.arrayUnion([questdata])
        }, SetOptions(merge: true));
      });
    }else{
      FirebaseFirestore quiz = FirebaseFirestore.instance;
      await quiz.collection('Quizzes').doc(uid).set({
        'Questions': FieldValue.arrayUnion([questdata])
      }, SetOptions(merge: true));
      questdata.remove('real');
      await quiz.collection('studentquiz').doc(uid).set({
        'Questions': FieldValue.arrayUnion([questdata])
      }, SetOptions(merge: true));
    }
  }
  Future uploadmaterials(File file,String uid,String message,String Title,String filename,String date)async{
    upload = store!.ref('edu/${uid}/${date+filename}').putFile(file);
   await  upload!.whenComplete(()async{
      FirebaseFirestore lms =FirebaseFirestore.instance;
      await lms.collection('LMS').doc(uid).set({
        'materials':FieldValue.arrayUnion([{
          'title':Title,
          'filename':filename,
          'message':message,
          'path':'edu/${uid}/${date+filename}',
          'date':DateTime.now().toString()
        }])

      },SetOptions(merge: true));


    });



  }
  Future uploadquizmaterials(File file,String uid,String message,String filename,String date)async{
    upload = store!.ref('quiz/${uid}/${date+filename}').putFile(file);
    await upload!.whenComplete(()async{
      FirebaseFirestore lms =FirebaseFirestore.instance;
      await lms.collection('Quizzes').doc(uid).update({
          'filename':filename,
          'message':message,
          'path':'quiz/${uid}/${date+filename}',
          'date':DateTime.now().toString()
        });
      messaging msg =messaging(uid: _auth.currentUser!.uid);
      await msg.groupmsg(uid, message, _auth.currentUser!.displayName!);
      });

  }

  Future downloadmaterials(String uid,String path,String filename)async{
    Directory d1 =Directory('/storage/emulated/0/Download/Qiuzzy');
    String putfile ="";
    if(!await d1.exists()){
      d1.create();
    }
      putfile ='/storage/emulated/0/Download/Qiuzzy/${uid+filename}';

    File downloadToFile = await File(putfile);
    downloadTask= store!.ref(path).writeToFile(downloadToFile);
    return downloadToFile.path;

  }

  Future deletematerirals(String uid,String path,Map e)async{
    FirebaseFirestore lms =FirebaseFirestore.instance;
    await lms.collection('LMS').doc(uid).update({
      'materials':FieldValue.arrayRemove([e])

    });
    await store!.ref(path).delete();
  }
}


