import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CloudStorageServices {
  Future<String> getProfilePicURL(String uid) async {
    String retVal;
    try {
      retVal = await firebase_storage.FirebaseStorage.instance
          .ref('$uid/profile.jpg')
          .getDownloadURL();
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<bool> uploadProfilePic(File file, String uid) async {
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('$uid/profile.jpg')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}
