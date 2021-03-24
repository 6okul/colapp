import 'package:colapp/root.dart';
import 'package:colapp/screens/profile/createProfile.dart';
import 'package:colapp/screens/register/RegisterScreen.dart';
import 'package:colapp/screens/register/VerifyEmail.dart';
import 'package:colapp/shared/loading.dart';
import 'package:colapp/state/userAuthState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isLoading = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  void handleLogin(String email, String password, BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    UserAuthState userAuthState =
        Provider.of<UserAuthState>(context, listen: false);
    String result =
        await userAuthState.login(email, password).whenComplete(() => {
              setState(() {
                isLoading = false;
              })
            });
    if (result == "success") {
      if (userAuthState.getProfile != null) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Root()), (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => CreateProfileScreen()),
            (route) => false);
      }
    } else if (result == "notVerified") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => VerifyScreen()));
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
            padding: const EdgeInsets.only(top: 100, right: 15, left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(
                        Icons.mail,
                      ),
                      labelText: "Email"),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  enableSuggestions: false,
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
                    handleLogin(_emailController.text.trim(),
                        _passwordController.text.trim(), context);
                  },
                  child: Text(
                    "Login",
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
                    },
                    splashColor: Colors.purple,
                    child: Text(
                      "Create New Account",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          );
  }
}
