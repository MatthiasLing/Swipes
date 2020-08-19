import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

isUChi(str) {}

Future<String> getUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('username');
  return stringValue;
}

Future<String> getUserID() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString('userID');
  return stringValue;
}
Future<void> setNameTest() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('username', 'Matthias');
  return true;
}

