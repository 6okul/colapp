import 'package:colapp/screens/project/edit/editForm.dart';
import 'package:flutter/material.dart';

class EditProjectScreen extends StatelessWidget {
  Map project;
  EditProjectScreen(this.project);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image(
          image: AssetImage("assets/logo.png"),
          height: 50,
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                top: 50,
              ),
              child: Text(
                "Post a new project.",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            EditForm(project),
          ],
        ),
      ),
    );
  }
}
