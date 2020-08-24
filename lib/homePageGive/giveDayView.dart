import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_week_view/flutter_week_view.dart';

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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Container(
          color: Colors.green[100],
          height: 500,
          child: new StreamBuilder<dynamic>(
              stream: Firestore.instance.collection('requests').snapshots(),
              builder: (context, snapshot) {
                List<Event> lst = [];

                if (!snapshot.hasData) {
                  return Text("Loading");
                } else {
                  if (snapshot.hasData) {
                    for (int i = 0; i < snapshot.data.documents.length; ++i) {
                      DateTime date =
                          snapshot.data.documents[i].data["timeStart"].toDate();
                      if (date.day == widget.today.day &&
                          date.month == widget.today.month) {
                        lst.add(Event(
                          date: date,
                          title: snapshot.data.documents[i].documentID,
                        ));
                      }
                    }

                    lst = lst.toSet().toList();
                    List<FlutterWeekViewEvent> lst2 = [];

                    Random rnd = new Random();
                    int min = 0;
                    int max = 255;

                    for (int i = 0; i < lst.length; i++) {
                      lst2.add(new FlutterWeekViewEvent(
                          backgroundColor: Color.fromRGBO(
                              min + rnd.nextInt(max - min),
                              min + rnd.nextInt(max - min),
                              min + rnd.nextInt(max - min),
                              0.5),
                          title: lst[i].title,
                          description: "",
                          start: lst[i].date,
                          end: lst[i].date.add(new Duration(minutes: 30)),
                          onTap: () {
                            //Open the dialogue here
                            print(lst[i].title);
                          }));
                    }  

                    //turn lst into the list of other events
                    if (lst.length > 0) {
                      return DayView(
                        onHoursColumnTappedDown: (dateTime) {
                          print(dateTime);
                        },
                        dayBarStyle: DayBarStyle(
                            dateFormatter: (year, month, day) {
                              return DateFormat.MMMd('en_US')
                                  .format(DateTime(year, month, day))
                                  .toString();
                            },
                            textAlignment: Alignment.center),
                        date: widget.today,
                        events: lst2,
                      );
                    }
                  }
                  return Center(
                    child: Text("No requests today"),
                  );
                }
              }),
        ))
      ],
    ));
  }
}
