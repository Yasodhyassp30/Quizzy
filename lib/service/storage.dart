import 'package:cloud/service/messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class cloudstorage{
  FirebaseStorage ? store=FirebaseStorage.instance;
  FirebaseAuth _auth =FirebaseAuth.instance;
  UploadTask ? upload;

  Future uploadmaterials(File file,String uid,String message,String Title,String filename,String date)async{
    upload = store!.ref('edu/${uid}/${date+filename}').putFile(file);
    upload!.whenComplete(()async{
      var ref = await FirebaseStorage.instance.ref().child('edu/${uid}/${date+filename}');

      var downloadlink =await ref.getDownloadURL();
      FirebaseFirestore lms =FirebaseFirestore.instance;
      await lms.collection('LMS').doc(uid).set({
        'materials':FieldValue.arrayUnion([{
          'title':Title,
          'message':message,
          'downloadURL':downloadlink,
          'date':DateTime.now().toString()
        }])

      },SetOptions(merge: true));
      messaging msg =messaging(uid: _auth.currentUser!.uid);
      await msg.groupmsg(uid, message, _auth.currentUser!.displayName!);


    });



  }
}


