import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colapp/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class UserAuthState with ChangeNotifier {
  User _user;
  User get getCurrentUser => _user;
  String profileUrl;
  Map _profile = Map();
  Map get getProfile => _profile;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> fetchProfileUrl() async {
    try {
      await FirebaseStorage.instance
          .ref('${_user.uid}/profile.jpg')
          .getDownloadURL()
          .then((value) {
        profileUrl = value;
        notifyListeners();
      });
    } catch (e) {
      return false;
      profileUrl = null;
      print(e);
    }
    return true;
  }

  Future<bool> fetchProfile() async {
    try {
      await FirebaseStorage.instance
          .ref('${_user.uid}/profile.jpg')
          .getDownloadURL()
          .then((value) {
        profileUrl = value;
        notifyListeners();
      });
    } catch (e) {
      profileUrl = null;
      print(e);
    }

    try {
      await _firestore.collection("users").doc(_user.uid).get().then((value) {
        _profile = value.data();
        notifyListeners();
      });
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> setUpProfile(
      {String fullName, String title, String bio, String contactNumber}) async {
    try {
      await _firestore.collection("users").doc(_user.uid).set({
        "profileUrl": null,
        "uid": _user.uid,
        "fullName": fullName,
        "title": title,
        "bio": bio,
        "contactNumber": contactNumber,
        "projects": [],
        "connections": [],
      });
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Future<bool> updateProfile(
      {String fullName, String title, String bio, String contactNumber}) async {
    try {
      await _firestore.collection("users").doc(_user.uid).update({
        "fullName": fullName,
        "title": title,
        "bio": bio,
        "contactNumber": contactNumber,
      });
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<void> onStartUp() async {
    _user = _auth.currentUser;
    fetchProfile();
  }

  Future<void> verify() async {
    try {
      await _auth.currentUser.sendEmailVerification();
    } catch (e) {
      print(e);
    }
  }

  Future<String> signUp(String email, String password) async {
    String retVal = "";
    try {
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (_credential.user != null) {
        _user = _credential.user;
        retVal = "success";
      }
    } on FirebaseAuthException catch (e) {
      retVal = e.message;
    } catch (e) {
      print(e.message);
    }
    return retVal;
  }

  Future<String> login(String email, String password) async {
    String retVal = "";
    try {
      UserCredential _credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (_credential.user != null) {
        if (_credential.user.emailVerified == true) {
          _user = _credential.user;
          await this.fetchProfile();
          retVal = "success";
        } else {
          retVal = "notVerified";
        }
      }
    } on FirebaseAuthException catch (e) {
      retVal = e.message;
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
  }
}
