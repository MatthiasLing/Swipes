import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../engine/engine.dart';
import 'giveDayView.dart';

//TODO: make it so that monthtable incorporates the prev and next months
class MonthView extends StatefulWidget {
  MonthView({Key key}) : super(key: key);
  bool isWeekView = false;
  @override
  _MonthViewState createState() => new _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime _targetDateTime = DateTime.now();
  List<List<Event>> monthTable = new List(32);

  static Widget _eventIcon(String day) => new Container(
        decoration: new BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.all(Radius.circular(1000)),
            border: Border.all(color: Colors.amber, width: 2.0)),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  CalendarCarousel _calendarCarouselNoHeader;

  @override
  void initState() {
    for (int i = 0; i < 32; i++) {
      monthTable[i] = (monthTable[i] == null) ? [] : monthTable[i];
    }
    super.initState();
  }

  Future<void> getRequests() async {
    var queryResult =
        await Firestore.instance.collection("requests").getDocuments();

    if (queryResult.documents.isNotEmpty) {
      for (int i = 0; i < queryResult.documents.length; ++i) {
        DateTime date = queryResult.documents[i].data["timeStart"].toDate();
        String title = queryResult.documents[i].documentID;
        print("Adding event : " + date.toString());

        // Add more events to _markedDateMap EventList
        _markedDateMap.add(
            new DateTime(date.year, date.month, date.day),
            new Event(
              date: new DateTime(date.year, date.month, date.day),
              title: title,
              icon: _eventIcon(date.day.toString()),
            ));
      }
    }
  }

  void resetMonthTable() {
    for (int i = 0; i < 31; i++) {
      monthTable[i] = [];
    }
    print(monthTable);
    print("reset");
  }

  int num = 1;
  final databaseReference = Firestore.instance;

  void createRecord() async {
    DocumentReference ref = await databaseReference.collection("requests").add({
      'location': 'Any',
      'timeEnd': DateTime(2020, 9, num),
      'timeStart': DateTime(2020, 9, num),
      'type': "give",
      'user': "matthiasling"
    });
    num++;
    print(ref.documentID);
  }

  void deleteAll() async {
    databaseReference.collection('requests').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        int day = ds.data["timeStart"].toDate().day;
        String id = ds.documentID;
        //TODO: check this out - not sure if removing

        print("DAYYYYY" + day.toString() + "   " + id.toString());
        print(monthTable[day]);
        monthTable[day].removeWhere((item) => item.title == id);
        print(monthTable[day]);
        print("delete complete");
        ds.reference.delete();
      }
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Example Calendar Carousel without header and custom prev & next button
    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      onDayPressed: (DateTime date, List<Event> events) {
        // this.setState(() => _currentDate2 = date);
        print(date);
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return GiveDayView(monthTable[date.day]);
            });
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
//      firstDayOfWeek: 4,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder:
          CircleBorder(side: BorderSide(color: Colors.amber)),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal: null,
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        print('long pressed date $date');
      },
    );

    Widget calendar() {
      return FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.done) {
            return _calendarCarouselNoHeader;
          }
          return CircularProgressIndicator();

          //return _calendarCarouselNoHeader;
        },
        future: getRequests(),
      );
    }

    return new Scaffold(
        appBar: new AppBar(
          //This is the ovr title huh
          title: new FutureBuilder<String>(
            future: getUsername(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Text('Welcome, ' + snapshot.data);
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // This trailing comma makes auto-formatting nicer for build methods.
              //custom icon without header
              Container(
                margin: EdgeInsets.only(
                  top: 30.0,
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      _currentMonth,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    )),
                    FlatButton(
                      child: Text('PREV'),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(
                              _targetDateTime.year, _targetDateTime.month - 1);
                          _currentMonth =
                              DateFormat.yMMM().format(_targetDateTime);
                          resetMonthTable();
                        });
                      },
                    ),
                    FlatButton(
                      child: Text('NEXT'),
                      onPressed: () {
                        setState(() {
                          _targetDateTime = DateTime(
                              _targetDateTime.year, _targetDateTime.month + 1);
                          _currentMonth =
                              DateFormat.yMMM().format(_targetDateTime);
                          resetMonthTable();
                        });
                      },
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: StreamBuilder(
                    stream:
                        Firestore.instance.collection('requests').snapshots(),
                    initialData: _calendarCarouselNoHeader,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text("Loading");
                      } else {
                        //TODO: Fix streambuilder error
                        if (snapshot.hasData) {
                          for (int i = 0;
                              i < snapshot.data.documents.length;
                              ++i) {
                            DateTime date = snapshot
                                .data.documents[i].data["timeStart"]
                                .toDate();
                            print("Adding event : " + date.toString());
                            //TODO: adding to monthtable multiple times
                            Event event = Event(
                              date:
                                  new DateTime(date.year, date.month, date.day),
                              title: snapshot.data.documents[i].documentID,
                              icon: _eventIcon(date.day.toString()),
                            );

                            if (date.month == _targetDateTime.month &&
                                date.day >= _targetDateTime.day) {
                              print("ADDING TO MONTH TABLE");
                              monthTable[date.day].add(event);
                              monthTable[date.day] =
                                  monthTable[date.day].toSet().toList();
                              print(monthTable);
                            }
                            print(
                                "ID: " + snapshot.data.documents[i].documentID);

                            // Add more events to _markedDateMap EventList
                            _markedDateMap.add(
                                new DateTime(date.year, date.month, date.day),
                                event);
                          }
                          return _calendarCarouselNoHeader;
                        } else {
                          print("uh oh ");
                          return Text('Pease Wait');
                        }
                      }
                    }),
              ),
              RaisedButton(
                child: Text('Create Record'),
                onPressed: () {
                  setState(() {
                    createRecord();
                  });
                },
              ),
              RaisedButton(
                color: Colors.red,
                child: Text('Delete All'),
                onPressed: () {
                  setState(() {
                    deleteAll();
                  });
                },
              ),
            ],
          ),
        ));
  }
}
