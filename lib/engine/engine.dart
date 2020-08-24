import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//TODO: input if we're only allowing uchicago emails (probably not going to)
isUChi(str) {
  RegExp regExp = new RegExp(
    r"^[a-zA-Z0-9_.+-]+@(?:(?:[a-zA-Z0-9-]+\.)?[a-zA-Z]+\.)?(uchicago)\.edu$",
    caseSensitive: false,
    multiLine: false,
  );
  return regExp.hasMatch(str).toString();
}

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

Future<bool> getSwiper() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  bool swiper = prefs.getBool('swiper');
  return swiper;
}

Future<void> setSwiper(swiper) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('swiper', swiper );
  return true;
}