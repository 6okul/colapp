import 'package:colapp/root.dart';
import 'package:colapp/state/userAuthState.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() {
    runApp(MyApp());
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FocusNode _blankFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_blankFocusNode);
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => UserAuthState(),
          )
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Colors.black,
            cursorColor: Colors.black,
            splashColor: Colors.purple,
            buttonTheme: ButtonThemeData(buttonColor: Colors.black),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Root(),
        ),
      ),
    );
  }
}
