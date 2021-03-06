import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  Future updateProfileInProjects(String uid) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get()
          .then((value) {
        List projects = value.data()["projects"];
        Map<String, dynamic> updateMap = {
          "profileUrl": value.data()["profileUrl"],
          "profileName": value.data()["fullName"],
          "profileTitle": value.data()["title"],
        };
        projects.forEach((element) async {
          DocumentReference project = element;
          await project.update(updateMap);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> publishProject(Map<String, dynamic> project) async {
    bool retVal = false;
    String uid = project["uid"] ?? "";
    List projects = [];

    DocumentReference projectDocRef;
    if (uid.isNotEmpty) {
      try {
        projectDocRef =
            await FirebaseFirestore.instance.collection("projects").doc();
        projectDocRef.set(project);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .get()
            .then((value) {
          projects = value.data()["projects"];
        }).whenComplete(() async {
          projects.add(projectDocRef);
          await FirebaseFirestore.instance.collection("users").doc(uid).update({
            "projects": projects,
          });
        }).whenComplete(() => retVal = true);
      } catch (e) {
        retVal = false;
        print(e);
      }
    }
    return retVal;
  }

  Future<bool> updateProject(
      {Map<String, dynamic> project, String docId}) async {
    bool retVal = false;

    try {
      await FirebaseFirestore.instance
          .collection("projects")
          .doc(docId)
          .update(project)
          .whenComplete(() => retVal = true);
    } catch (e) {
      retVal = false;
      print(e);
    }

    return retVal;
  }

  Future<bool> deleteProject({String docId, String uid}) async {
    bool retVal = false;
    List projects = [];
    DocumentReference projectDocRef =
        FirebaseFirestore.instance.collection("projects").doc(docId);
    try {
      await FirebaseFirestore.instance
          .collection("projects")
          .doc(docId)
          .delete()
          .whenComplete(() async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .get()
            .then((value) {
          projects = value.data()["projects"];
        }).whenComplete(() async {
          projects.remove(projectDocRef);
          await FirebaseFirestore.instance.collection("users").doc(uid).update({
            "projects": projects,
          });
        });
      }).whenComplete(() => retVal = true);
    } catch (e) {
      retVal = false;
      print(e);
    }

    return retVal;
  }
}
