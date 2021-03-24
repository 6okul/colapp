import 'package:colapp/screens/register/VerifyEmail.dart';
import 'package:colapp/shared/loading.dart';
import 'package:colapp/state/userAuthState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateForm extends StatefulWidget {
  @override
  _CreateFormState createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  TextEditingController _fullnameController = new TextEditingController();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _bioController = new TextEditingController();
  TextEditingController _contactNumberController = new TextEditingController();

  void handleCreateProfile(
      {String fullName,
      String title,
      String bio,
      String contactNumber,
      BuildContext context}) async {
    setState(() {
      isLoading = true;
    });
    UserAuthState userAuthState =
        Provider.of<UserAuthState>(context, listen: false);
    if (userAuthState.getCurrentUser.uid != null) {
      bool isSucsess = await userAuthState
          .setUpProfile(
              fullName: fullName,
              title: title,
              bio: bio,
              contactNumber: contactNumber)
          .whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
      if (isSucsess) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => VerifyScreen()));
      } else {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Something went wrong!")));
      }
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter your Name.";
                      }
                      return null;
                    },
                    controller: _fullnameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Name"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Enter a Title.";
                      }
                      return null;
                    },
                    controller: _titleController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Title"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 5,
                    validator: (value) {
                      if (value.length < 6) {
                        return "Say atleast a few words.";
                      }
                      return null;
                    },
                    controller: _bioController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Bio"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value.length < 10) {
                        return "Invalid phone number!";
                      }
                      return null;
                    },
                    controller: _contactNumberController,
                    decoration: InputDecoration(
                        hintText: "Example: 919876543210",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Contact Number"),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 45),
                    elevation: 10.0,
                    splashColor: Colors.purple,
                    color: Colors.black,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        handleCreateProfile(
                            fullName: _fullnameController.text.trim(),
                            title: _titleController.text.trim(),
                            bio: _bioController.text.trim(),
                            contactNumber: _contactNumberController.text.trim(),
                            context: context);
                      }
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
  }
}
