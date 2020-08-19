import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_week_view/flutter_week_view.dart';

class GiveButton extends StatefulWidget {
  @override
  _GiveButtonState createState() => _GiveButtonState();
}

class _GiveButtonState extends State<GiveButton> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Event> events = [];
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Expanded(
      child: ClipOval(
        child: Material(
          color: Colors.red[800], // button color
          child: InkWell(
            splashColor: Colors.red, // inkwell color
            child: SizedBox(
                width: 56,
                height: 56,
                child: Icon(Icons.card_giftcard, color: Colors.white)),
            onTap: () {},
          ),
        ),
      ),
    ));
  }
}
