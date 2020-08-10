import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';

class GiveDayView extends StatefulWidget {
  List<Event> eventList;
  GiveDayView(this.eventList);

  @override
  _GiveDayViewState createState() => _GiveDayViewState();
}

class _GiveDayViewState extends State<GiveDayView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Event> events = [];
  @override
  void initState() {
    widget.eventList.sort((a, b) => a.date.compareTo(b.date));
    print(widget.eventList);
    print("done");
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
          child: widget.eventList.length == 0
              ? Text("No events")
              : ListView.builder(
                  itemCount: widget.eventList.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new Text(widget.eventList[index].date.toString());
                  }),
        ))
      ],
    ));
  }
}
