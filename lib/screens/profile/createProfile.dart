import 'package:colapp/screens/profile/createForm.dart';
import 'package:colapp/screens/register/RegisterForm.dart';
import 'package:flutter/material.dart';

class CreateProfileScreen extends StatelessWidget {
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
                "Tell us about you.",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            CreateForm(),
          ],
        ),
      ),
    );
  }
}
