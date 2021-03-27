import 'package:flutter/material.dart';

class ProfileViewScreen extends StatelessWidget {
  String projectsCount = "!";
  String connectionsCount = "!";
  String profileUrl;
  String fullName = "!";
  String title = "!";
  String bio = "!";
  Map<String, dynamic> profile;
  ProfileViewScreen(this.profile) {
    if (this.profile != null) {
      this.projectsCount = this.profile["projects"].length.toString();
      this.connectionsCount = this.profile["connections"].length.toString();
      this.profileUrl = this.profile["profileUrl"];
      this.fullName = this.profile["fullName"];
      this.title = this.profile["title"];
      this.bio = this.profile["bio"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image(
          image: AssetImage("assets/logo.png"),
          height: 50,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          projectsCount,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Projects",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 0,
                            spreadRadius: 5),
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 0,
                            spreadRadius: 3),
                      ]),
                  margin: const EdgeInsets.all(15),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: (profileUrl == null)
                          ? AssetImage('assets/default_profile.jpg')
                          : NetworkImage(profileUrl)),
                ),
                GestureDetector(
                  onTap: () {
                    // implement connections
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          connectionsCount,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Connections",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15, left: 20),
            child: Text(
              fullName,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 2, left: 20, right: 20),
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
            child: Text(
              bio,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
