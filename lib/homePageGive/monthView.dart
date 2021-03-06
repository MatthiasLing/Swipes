import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../engine/engine.dart';
import 'giveDayView.dart';
import 'giveButton.dart';
import 'package:flutter/cupertino.dart';

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

  bool swiper = true;
  // List<List<Event>> monthTable = new List(32);

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

  static Widget dot = Container(
    margin: EdgeInsets.symmetric(horizontal: 1.0),
    color: Colors.red,
    height: 5.0,
    width: 5.0,
  );
  CalendarCarousel _calendarCarouselNoHeader;

  @override
  void initState() {
    // for (int i = 0; i < 32; i++) {
    //   monthTable[i] = (monthTable[i] == null) ? [] : monthTable[i];
    // }
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
        setState(() {
          _markedDateMap.add(
              new DateTime(date.year, date.month, date.day),
              new Event(
                date: new DateTime(date.year, date.month, date.day),
                title: title,
                dot: dot,
                //icon: _eventIcon(date.day.toString()),
              ));
        });
      }
    }
  }

  void addToMarkedDateMap(date, event) {
    setState(() {
      _markedDateMap.add(date, event);
    });
  }

  int num = 1;
  final databaseReference = Firestore.instance;

  void createDonation() async {
    num++;
    DocumentReference ref =
        await databaseReference.collection("donations").add({
      'location': 'Bartlett',
      'timeEnd': DateTime(2020, 9, num),
      'timeStart': DateTime(2020, 9, num),
      'type': "give",
      'user': "matthiasling",
      'note': 'some basic information regarding the event'
    });
    print(ref.documentID);
  }

  void populateRequests() async {
    await getUsername().then((value) async {
      for (int num = 1; num < 20; num++) {
        DocumentReference ref =
            await databaseReference.collection("requests").add({
          'timeEnd': DateTime(2020, 9, num),
          'timeStart': DateTime(2020, 9, num),
          'user': value,
          'email': "temp",
        });
        print(ref.documentID);
      }
    });
  }

  void deleteAll() async {
    databaseReference.collection('requests').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        // DateTime date = ds.data["timeStart"].toDate();
        // int day = date.day;
        // String id = ds.documentID;
        ds.reference.delete();
      }
      setState(() {
        _markedDateMap = new EventList<Event>(
          events: {},
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Example Calendar Carousel without header and custom prev & next button

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      onDayPressed: (DateTime date, List<Event> events) {
        // this.setState(() => _currentDate2 = date);
        print(date.month.toString() + "/" + date.day.toString());
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(25.0),
                topRight: const Radius.circular(25.0),
              ),
            ),
            child: Center(child: GiveDayView(date)),
          ),
        );
        //}
        //brings up the interface
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
        // return event.icon;
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

    return new Scaffold(
        appBar: new AppBar(
          title: new FutureBuilder<String>(
            future: getUsername(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Text('Welcome, ' + snapshot.data);
              } else {
                return Text("Welcome");
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
                  top: 16.0,
                  // bottom: 16.0,
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
                          // resetMonthTable();
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
                          // resetMonthTable();
                        });
                      },
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                // TODO: fix the no such method error by defining stream type
                // Do for other streams as well
                child: StreamBuilder(
                    stream:
                        Firestore.instance.collection('requests').snapshots(),
                    //_calendarCarouselNoHeader,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return _calendarCarouselNoHeader;
                      } else {
                        if (snapshot.hasData) {
                          List lst = snapshot.data.documents
                              .map((doc) => new Event(
                                  date: new DateTime(
                                      doc["timeStart"].toDate().year,
                                      doc["timeStart"].toDate().month,
                                      doc["timeStart"].toDate().day),
                                  dot: dot,
                                  title: doc.documentID))
                              .toList();

                          for (int i = 0; i < lst.length; ++i) {
                            DateTime date = lst[i].date;
                            _markedDateMap.add(
                                new DateTime(date.year, date.month, date.day),
                                lst[i]);
                          }

                          // print(
                          //     "ID: " + snapshot.data.documents[i].documentID);
                        }
                        return _calendarCarouselNoHeader;
                      }
                    }),
              ),

              new FutureBuilder<bool>(
                future: getSwiper(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData) {
                    swiper = snapshot.data;
                    return Switch(
                      value: swiper,
                      onChanged: (value) {
                        setState(() {
                          swiper = !swiper;
                          setSwiper(swiper);
                        });
                        print(swiper);
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    );
                  } else {
                    return Switch(
                      value: swiper,
                      onChanged: (value) {
                        setState(() {
                          swiper = !swiper;
                          setSwiper(swiper);
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    );
                  }
                },
              ),

              RaisedButton(
                child: Text('Populate data'),
                onPressed: () {
                  setState(() {
                    populateRequests();
                  });
                },
              ),
              RaisedButton(
                child: Text('Create Record'),
                onPressed: () {
                  setState(() {
                    createDonation();
                  });
                },
              ),
              RaisedButton(
                color: Colors.red,
                child: Text('Delete All'),
                onPressed: () {
                  deleteAll();
                },
              ),
            ],
          ),
        ));
  }
}
