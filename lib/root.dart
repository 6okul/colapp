import 'package:colapp/screens/homeRoot.dart';
import 'package:colapp/screens/login/loginScreen.dart';
import 'package:colapp/state/userAuthState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserAuthState _authState =
        Provider.of<UserAuthState>(context, listen: false);
    _authState.onStartUp();
    User _currentUser = _authState.getCurrentUser;
    if (_currentUser != null) {
      return HomeRoot();
    } else {
      return LoginScreen();
    }
  }
}
