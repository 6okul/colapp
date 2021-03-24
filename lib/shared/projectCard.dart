import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectCard extends StatelessWidget {
  Map<String, dynamic> project;

  ProjectCard(this.project);

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
            child: Row(
              children: [
                Expanded(
                  flex: 1,
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
                    flex: 4,
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
              ],
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
          if (project["optLink"].length > 0) ...[
            RaisedButton(
              splashColor: Colors.blue,
              onPressed: () {},
              child: Text(project["optLinkName"]),
              textColor: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ],
      ),
    );
  }
}
