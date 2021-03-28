import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colapp/screens/account/ManageProjects.dart';
import 'package:colapp/services/database.dart';
import 'package:colapp/services/storage.dart';
import 'package:colapp/state/userAuthState.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AccountHeader extends StatelessWidget {
  Future handleProfilePic(String uid, BuildContext context) async {
    final picker = ImagePicker();
    await picker.getImage(source: ImageSource.gallery).then((value) async {
      if (value != null) {
        await ImageCropper.cropImage(
                androidUiSettings: AndroidUiSettings(
                  activeControlsWidgetColor: Colors.purple,
                  toolbarTitle: 'Cropper',
                  toolbarColor: Colors.black,
                  toolbarWidgetColor: Colors.white,
                  lockAspectRatio: true,
                ),
                maxHeight: 500,
                maxWidth: 500,
                sourcePath: value.path,
                aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
                compressFormat: ImageCompressFormat.jpg,
                compressQuality: 100)
            .then((value) async {
          if (value != null) {
            await CloudStorageServices()
                .uploadProfilePic(value, uid)
                .whenComplete(() async {
              String url = await FirebaseStorage.instance
                  .ref('$uid/profile.jpg')
                  .getDownloadURL();
              FirebaseFirestore.instance.collection("users").doc(uid).update(
                  {"profileUrl": url.toString()}).whenComplete(() async {
                await FirestoreServices().updateProfileInProjects(uid);
              });
            });
          }
        });
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<UserAuthState>(context).getCurrentUser.uid;
    Stream<DocumentSnapshot> snapshots =
        FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
    return StreamBuilder(
        stream: snapshots,
        builder: (context, snapshot) {
          List<dynamic> projects;
          String projectsCount = "!";

          String profileUrl;
          String fullName = "!";
          String title = "!";
          String bio = "!";
          if (snapshot.data != null) {
            projectsCount = snapshot.data["projects"].length.toString();

            profileUrl = snapshot.data["profileUrl"];
            fullName = snapshot.data["fullName"];
            title = snapshot.data["title"];
            bio = snapshot.data["bio"];
            projects = snapshot.data["projects"];
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.white,
                                blurRadius: 0,
                                spreadRadius: 5),
                            BoxShadow(
                                color: Colors.black,
                                blurRadius: 0,
                                spreadRadius: 3),
                          ]),
                      margin: const EdgeInsets.all(15),
                      child: GestureDetector(
                        onTap: () {
                          handleProfilePic(uid, context);
                        },
                        child: CircleAvatar(
                            radius: 50,
                            backgroundImage: (profileUrl == null)
                                ? AssetImage('assets/default_profile.jpg')
                                : NetworkImage(profileUrl)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              projectsCount,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Projects",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 15, left: 20),
                child: Text(
                  fullName,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 2, left: 20, right: 20),
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
                child: Text(
                  bio,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
