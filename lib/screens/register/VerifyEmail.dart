import 'package:colapp/screens/login/loginScreen.dart';
import 'package:colapp/state/userAuthState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  String message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image(
          image: AssetImage("assets/logo.png"),
          height: 50,
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: message != ""
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                      top: 50,
                    ),
                    child: Text(
                      "Verify Your Email",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                        top: 50, right: 20, left: 20, bottom: 50),
                    child: Text(
                      message,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        elevation: 10,
                        color: Colors.black,
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (route) => false);
                        },
                        splashColor: Colors.purple,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Proceed to Login  ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ],
                        )),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                      top: 50,
                    ),
                    child: Text(
                      "Verify Your Email",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 50),
                    child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        elevation: 10,
                        color: Colors.black,
                        onPressed: () async {
                          await Provider.of<UserAuthState>(context,
                                  listen: false)
                              .verify()
                              .whenComplete(() {
                            setState(() {
                              message =
                                  "A verification link has been sent to your email. Kindly verify and proceed to login. Thank you!";
                            });
                          });
                        },
                        splashColor: Colors.purple,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Send Verification Email  ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ],
                        )),
                  )
                ],
              ),
      ),
    );
  }
}
