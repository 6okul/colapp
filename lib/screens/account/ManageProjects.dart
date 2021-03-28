import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageProjects extends StatelessWidget {
  List<dynamic> projects;
  ManageProjects(this.projects);
  @override
  Widget build(BuildContext context) {
    List<Widget> projectWidgets;
    projects.map((e) {
      DocumentReference project = e;
      String title;
      project.get().then((value) {
        if (value != null) {
          title = value.data()["projectTitle"];
        }
      });

      Widget projectWidget = Row(
        children: [
          Expanded(flex: 5, child: Text(title)),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.edit),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.delete),
            ),
          )
        ],
      );

      projectWidgets.add(projectWidget);
    });
    return ListView(
      children: projectWidgets,
    );
  }
}
