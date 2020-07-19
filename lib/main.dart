import 'package:flutter/material.dart';
import 'loginScreens/initGive.dart';
import 'auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'loginScreens/loginScreens.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Swipes',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: 
        // new InitGivePage());
    new RootPage(auth: new Auth()));
  }
}
