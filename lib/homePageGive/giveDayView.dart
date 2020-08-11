import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_calendar_carousel/classes/event_list.dart';

class GiveDayView extends StatefulWidget {
  final DateTime today;
  GiveDayView(this.today);

  @override
  _GiveDayViewState createState() => _GiveDayViewState();
}

class _GiveDayViewState extends State<GiveDayView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Event> events = [];
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            child: Container(
          color: Colors.green[100],
          height: 500,
          child: new StreamBuilder(
              stream: Firestore.instance.collection('requests').snapshots(),
              initialData: Text("initial Data"),
              builder: (context, snapshot) {
                List<Event> lst = [];

                if (!snapshot.hasData) {
                  return Text("Loading");
                } else {
                  //TODO: Fix streambuilder error
                  if (snapshot.hasData) {
                    for (int i = 0; i < snapshot.data.documents.length; ++i) {
                      DateTime date =
                          snapshot.data.documents[i].data["timeStart"].toDate();
                      if (date.day == widget.today.day) {
                        lst.add(Event(
                          date: date,
                          title: snapshot.data.documents[i].documentID,
                        ));
                      }
                    }
                    lst = lst.toSet().toList();
                    if (lst.length > 0) {
                      return ListView.builder(
                          itemCount: lst.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return new Text(lst[index].title +
                                " " +
                                lst[index].date.toString());
                          });
                    }
                    return Center(
                      child: Text("No requests today"),
                    );
                  }
                }
              }),
        ))
      ],
    ));
  }
}
