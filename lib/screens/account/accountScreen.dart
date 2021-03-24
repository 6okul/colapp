import 'package:colapp/screens/account/accountHeader.dart';
import 'package:colapp/root.dart';
import 'package:colapp/screens/account/edit/editProfile.dart';
import 'package:colapp/state/userAuthState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget {
  Widget _buildSettings(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Colors.grey[700],
          height: 10,
        ),
        ListTile(
          trailing: Icon(Icons.logout),
          title: Text("Logout"),
          onTap: () {
            UserAuthState authState =
                Provider.of<UserAuthState>(context, listen: false);
            authState.logout().then((value) => {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Root()),
                      (route) => false)
                });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // String uid =
    //     Provider.of<UserAuthState>(context, listen: false).getCurrentUser.uid;
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AccountHeader(),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                splashColor: Colors.purple,
                textColor: Colors.white,
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditProfileScreen()));
                },
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Edit Profile"),
                  ],
                ),
              ),
              RaisedButton(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                splashColor: Colors.purple,
                textColor: Colors.white,
                color: Colors.black,
                onPressed: () {
                  showBottomSheet(
                    context: context,
                    builder: _buildSettings,
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 10),
                    Text("Settings"),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
