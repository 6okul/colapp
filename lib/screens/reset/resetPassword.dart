import 'package:colapp/root.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image(
          image: AssetImage("assets/logo.png"),
          height: 50,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Enter your Email Address",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "We will send a password reset link to this email address if it is associated with an account.",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                TextFormField(
                  validator: (value) {
                    if (isEmail(value)) {
                      return "Enter a valid email";
                    } else {
                      return null;
                    }
                  },
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
                  height: 40,
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
                    if (_formKey.currentState.validate()) {
                      try {
                        FirebaseAuth.instance
                            .sendPasswordResetEmail(
                                email: _emailController.text.trim())
                            .whenComplete(() {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Root()),
                              (route) => false);
                        });
                      } on FirebaseAuthException catch (e) {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text(e.message)));
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Text(
                    "Reset",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
