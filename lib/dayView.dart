import 'dart:math';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart' as launcher;

/// The demo app body widge

/// A day view that displays dynamically added events.
class DynamicDayView extends StatefulWidget {
  DynamicDayView();
  @override
    _DynamicDayViewState createState() {
    return _DynamicDayViewState();
  }
}

/// The dynamic day view state.
class _DynamicDayViewState extends State<DynamicDayView> {
  /// The added events.
  List<FlutterWeekViewEvent> events = [];

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo dynamic day view'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                DateTime start = DateTime(now.year, now.month, now.day,
                    Random().nextInt(24), Random().nextInt(60));
                events.add(FlutterWeekViewEvent(
                  onTap: () {
                    print(start);
                  },
                  title: 'Event ' + (events.length + 1).toString(),
                  start: start,
                  end: start.add(const Duration(hours: 1)),
                  description: 'A description.',
                ));
              });
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: DayView(
        date: now,
        events: events,
      ),
    );
  }
}
