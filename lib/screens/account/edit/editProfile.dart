import 'package:colapp/screens/account/edit/editForm.dart';
import 'package:colapp/state/userAuthState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<UserAuthState>(context, listen: false).fetchProfile();
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
                "Edit Profile",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            EditForm(),
          ],
        ),
      ),
    );
  }
}
