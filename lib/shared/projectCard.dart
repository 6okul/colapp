import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colapp/screens/project/edit/editProject.dart';
import 'package:colapp/services/database.dart';
import 'package:colapp/shared/profileViewScreen.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;
  final String currentUid;

  ProjectCard(this.project, this.currentUid);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: GestureDetector(
              //handle profile tap
              onTap: () async {
                if (project["uid"] == currentUid) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("Your Account !")));
                } else {
                  Map<String, dynamic> profile;
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(project["uid"])
                      .get()
                      .then((value) => profile = value.data());
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ProfileViewScreen(profile);
                  }));
                }
              },
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: CircleAvatar(
                        radius: 20,
                        child: ClipOval(
                            child: (project["profileUrl"] == null)
                                ? Image.asset('assets/default_profile.jpg')
                                : Image.network(project["profileUrl"])),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project["profileName"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                          Text(
                            project["profileTitle"] + "",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: Colors.black),
                          ),
                        ],
                      )),
                  if (project["uid"] == currentUid) ...[
                    Expanded(
                        flex: 1,
                        child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.blueGrey,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      EditProjectScreen(project)));
                            })),
                    Expanded(
                        flex: 1,
                        child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red[900],
                              size: 20,
                            ),
                            onPressed: () {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  action: SnackBarAction(
                                    onPressed: () async {
                                      FirestoreServices().deleteProject(
                                          docId: project["docId"],
                                          uid: project["uid"]);
                                    },
                                    textColor: Colors.red,
                                    label: "Yes, Delete.",
                                  ),
                                  content: Text("Are you sure ?")));
                            })),
                  ]
                ],
              ),
            ),
          ),
          Divider(
            height: 2,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              DateFormat.yMMMd('en_US').format(project["createdAt"].toDate()),
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ),
          ),
          Container(
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(0), color: Colors.black),
            // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Text(
              project["projectType"],
              style: TextStyle(
                  // foreground: Paint()
                  //   ..shader = LinearGradient(
                  //           colors: [Color(0xFFE90DDA), Color(0xFF15CFF1)],
                  //           begin: Alignment.topLeft,
                  //           end: Alignment.bottomRight)
                  //       .createShader(Rect.fromLTWH(50.0, 80.0, 50.0, 10.0)),
                  // shadows: [Shadow(color: Colors.black)],
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 3),
            child: Text(
              project["projectTitle"] ?? "",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ExpandableText(
              project["projectDesc"] ?? "",
              maxLines: 2,
              expandText: "More",
              collapseText: "Less",
              linkEllipsis: false,
              linkColor: Colors.black,
              linkStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (project["optLink"].length > 0) ...[
                RaisedButton(
                  splashColor: Colors.blue,
                  onPressed: () async {
                    try {
                      await canLaunch(project["optLink"])
                          ? await launch(project["optLink"])
                          : throw 'Could not launch';
                    } catch (e) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Could not launch link.")));
                    }
                  },
                  child: Text(project["optLinkName"]),
                  textColor: Colors.white,
                ),
                SizedBox(
                  width: 20,
                ),
              ],
              FlatButton(
                splashColor: Colors.blue,
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(project['uid'])
                      .get()
                      .then((value) async {
                    String contactNumber;
                    if (value.data()["contactNumber"].length > 0) {
                      contactNumber = value.data()["contactNumber"].trim();
                    }
                    await canLaunch('tel:$contactNumber')
                        ? await launch('tel:$contactNumber')
                        : throw 'Could not launch';
                  });
                },
                child: Text(
                  "Contact",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                textColor: Colors.black,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
