import 'package:colapp/shared/profileViewScreen.dart';
import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  Map profile;
  ProfileTile(this.profile);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProfileViewScreen(profile)));
        },
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(5),
                child: CircleAvatar(
                  radius: 20,
                  child: ClipOval(
                      child: (profile["profileUrl"] == null)
                          ? Image.asset('assets/default_profile.jpg')
                          : Image.network(profile["profileUrl"])),
                ),
              ),
            ),
            Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile["fullName"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                    Text(
                      profile["title"],
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: Colors.black),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
