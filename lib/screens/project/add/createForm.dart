import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colapp/screens/register/VerifyEmail.dart';
import 'package:colapp/services/database.dart';
import 'package:colapp/shared/loading.dart';
import 'package:colapp/state/userAuthState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class CreateForm extends StatefulWidget {
  @override
  _CreateFormState createState() => _CreateFormState();
}

class _CreateFormState extends State<CreateForm> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  TextEditingController _projectTitleController = new TextEditingController();
  TextEditingController _projectTypeController = new TextEditingController();
  TextEditingController _projectDescController = new TextEditingController();
  TextEditingController _optLinkNameController = new TextEditingController();
  TextEditingController _optLinkController = new TextEditingController();

  void handlePost(
      {String projectTitle,
      String projectType,
      String projectDesc,
      String optLinkName,
      String optLink,
      BuildContext context}) async {
    setState(() {
      isLoading = true;
    });
    UserAuthState userAuthState =
        Provider.of<UserAuthState>(context, listen: false);
    userAuthState.fetchProfile();
    if (userAuthState.getCurrentUser.uid != null) {
      bool isSuccess = await FirestoreServices().publishProject({
        "projectTitle": projectTitle,
        "projectType": projectType,
        "projectDesc": projectDesc,
        "optLinkName": optLinkName,
        "optLink": optLink,
        "uid": userAuthState.getCurrentUser.uid,
        "profileUrl": userAuthState.getProfile["profileUrl"],
        "profileName": userAuthState.getProfile["fullName"],
        "profileTitle": userAuthState.getProfile["title"],
        "createdAt": Timestamp.now(),
      }).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
      if (isSuccess) {
        Navigator.of(context).pop();
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
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Give your project a name.";
                      }
                      return null;
                    },
                    controller: _projectTitleController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Project Title"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "What type is your project ?";
                      }
                      return null;
                    },
                    controller: _projectTypeController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Type",
                        hintText: "Research, Academic, Hobbyist ..."),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 20,
                    validator: (value) {
                      if (value.length < 6) {
                        return "Say atleast a few words.";
                      }
                      return null;
                    },
                    controller: _projectDescController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Project Description"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (_optLinkController.text.isNotEmpty) {
                        if (value.isEmpty) {
                          return "Give a Link Name";
                        } else {
                          return null;
                        }
                      }
                      return null;
                    },
                    controller: _optLinkNameController,
                    decoration: InputDecoration(
                        hintText: "",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Optional link Name"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.url,
                    validator: (value) {
                      if (value.isNotEmpty ||
                          _optLinkNameController.text.isNotEmpty) {
                        if (isURL(value)) {
                          return null;
                        } else {
                          return "Invalid Link";
                        }
                      }
                      return null;
                    },
                    controller: _optLinkController,
                    decoration: InputDecoration(
                        hintText: "Link to your project page",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Optional link"),
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
                        handlePost(
                            projectTitle: _projectTitleController.text.trim(),
                            projectType: _projectTypeController.text.trim(),
                            projectDesc: _projectDescController.text.trim(),
                            optLink: _optLinkController.text.trim(),
                            optLinkName: _optLinkNameController.text.trim(),
                            context: context);
                      }
                    },
                    child: Text(
                      "Post",
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
