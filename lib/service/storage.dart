import 'package:cloud/service/messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class cloudstorage{
  FirebaseStorage ? store=FirebaseStorage.instance;
  FirebaseAuth _auth =FirebaseAuth.instance;
  UploadTask ? upload;
  DownloadTask ? downloadTask;

  Future uploadmaterials(File file,String uid,String message,String Title,String filename,String date)async{
    upload = store!.ref('edu/${uid}/${date+filename}').putFile(file);
    upload!.whenComplete(()async{
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


