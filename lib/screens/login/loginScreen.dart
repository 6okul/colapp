import 'package:colapp/screens/login/LoginForm.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                top: 30,
              ),
              margin: const EdgeInsets.only(bottom: 50),
              child: Image(
                image: AssetImage("assets/logo.png"),
                height: 150,
              ),
            ),
            Text(
              "Discover & Collab",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
            ),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}
