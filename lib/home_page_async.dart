// TODO: Remove this file if there truly is no use for it


// import 'package:flutter/material.dart';
// import 'login_signup_page.dart';
// import 'authentication.dart';
// import 'root_page.dart';
// import 'authentication.dart';

// enum AuthStatus {
//   NOT_DETERMINED,
//   NOT_LOGGED_IN,
//   LOGGED_IN,
// }

// class HomePageStateful extends StatefulWidget {
//   HomePageStateful({Key key, this.auth, this.logoutCallback, this.userId}) : super(key: key);
//   final BaseAuth auth;
//     final String userId;

//   final VoidCallback logoutCallback;

//   @override
//   State<StatefulWidget> createState() => new _HomePageStatefulState();
// }

// class _HomePageStatefulState extends State<HomePageStateful> {
//   AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
//   String _userId = "";

//   @override
//   void initState() {
//     super.initState();
//     widget.auth.getCurrentUser().then((user) {
//       setState(() {
//         if (user != null) {
//           _userId = user?.uid;
//         }
//         authStatus =
//             user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
//       });
//     });
//   }

//   signOut() async {
//     try {
//       await widget.auth.signOut();
//       widget.logoutCallback();
//     } catch (e) {
//       print(e);
//     }
//   }

//   void loginCallback() {
//     widget.auth.getCurrentUser().then((user) {
//       setState(() {
//         _userId = user.uid.toString();
//       });
//     });
//     setState(() {
//       authStatus = AuthStatus.LOGGED_IN;
//     });
//   }

//   void logoutCallback() {
//     setState(() {
//       authStatus = AuthStatus.NOT_LOGGED_IN;
//       _userId = "";
//     });
//   }

//   Widget buildWaitingScreen() {
//     return Scaffold(
//       body: Container(
//         alignment: Alignment.center,
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     switch (authStatus) {
//       case AuthStatus.NOT_DETERMINED:
//         return buildWaitingScreen();
//         break;
//       case AuthStatus.NOT_LOGGED_IN:
//         return new LoginSignupPage(
//           auth: widget.auth,
//           loginCallback: loginCallback,
//         );
//         break;
//       case AuthStatus.LOGGED_IN:
//         if (_userId.length > 0 && _userId != null) {
//           return Container(
//               child: FlatButton(
//             child: Text('Logout'),
//             onPressed: () async {
 
//               signOut();
//             },
//           ));
//         } else
//           return buildWaitingScreen();
//         break;
//       default:
//         return buildWaitingScreen();
//     }
//   }
// }
