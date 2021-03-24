import 'package:colapp/screens/profile/createProfile.dart';
import 'package:colapp/shared/loading.dart';
import 'package:colapp/state/userAuthState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'VerifyEmail.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool isLoading = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();

  void handleCreate(String email, String password, BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    UserAuthState userAuthState =
        Provider.of<UserAuthState>(context, listen: false);
    String result =
        await userAuthState.signUp(email, password).whenComplete(() => {
              setState(() {
                isLoading = false;
              })
            });
    if (result == "success") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CreateProfileScreen()));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            child: Loading(),
            margin: const EdgeInsets.only(top: 100),
          )
        : Container(
            padding: const EdgeInsets.only(top: 50, right: 15, left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(
                        Icons.mail,
                      ),
                      labelText: "Email"),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(
                        Icons.lock,
                      ),
                      labelText: "Password"),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(
                        Icons.lock,
                      ),
                      labelText: "Confirm Password"),
                ),
                SizedBox(
                  height: 60,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 45),
                  elevation: 10.0,
                  splashColor: Colors.purple,
                  color: Colors.black,
                  onPressed: () {
                    if (_passwordController.text ==
                        _confirmPasswordController.text) {
                      handleCreate(_emailController.text.trim(),
                          _passwordController.text.trim(), context);
                    } else {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Passwords do not match.")));
                    }
                  },
                  child: Text(
                    "Create",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    splashColor: Colors.purple,
                    child: Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          );
  }
}
