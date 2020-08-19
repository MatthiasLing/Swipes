import 'package:flutter/material.dart';
import 'homePageGive/homePageGive.dart';
import 'auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'engine/engine.dart';

//Testing:
import 'package:flutter_week_view/flutter_week_view.dart';

// import 'loginScreens/loginScreens.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Swipes',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:
            //// new InitGivePage()); Outdated I think
            ///
            //new RootPage(auth: new Auth())); //In use now
            //new HomePageGive());
    new MonthView());
  }
}
