import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:smolleytoolbox/Event.dart';
import 'package:intl/intl.dart';
import 'package:smolleytoolbox/notification.dart';
import 'package:smolleytoolbox/options.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:smolleytoolbox/sqlite.dart';
import '../constants.dart';
import 'home.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  bool istapped = true;
  bool isChecked = false;
  final scaffoldkey = GlobalKey<ScaffoldState>();
  final options = Options();
  final mysql = sqlite();
  //final popupmessage = authenticate();
  final _formkey = GlobalKey<FormState>();
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<Event>> selectedEvents = {};

  final remainder = TextEditingController();
  Future<void> getdata() async {
    List<Map<String, dynamic>> events = await mysql.getevents();
    selectedEvents.clear();
    if (events.isNotEmpty) {
      for (int i = 0; i < events.length; i++) {
        //print(events[i]['eventtime']);
        int id = events[i]['_id'];
        String title = events[i]['Title'];
        DateTime date = DateTime.parse(events[i]['eventtime'].toString());
        String eventtime = events[i]['starttime'];
        String checked = events[i]['checked'];
        if (selectedEvents[date] != null) {
          setState(() {
            selectedEvents[date]!.add(
                Event(title: title, id: id, time: eventtime, checked: checked));
            print(selectedEvents);
          });
        } else {
          setState(() {
            selectedEvents[date] = [
              Event(title: title, id: id, time: eventtime, checked: checked)
            ];
            print(selectedEvents);
          });
        }
      }
    }
  }

  List _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  String formatDate(DateTime date) {
    // Format the month and day using 'MMMM d' format.
    String monthAndDay = DateFormat('MMMM d').format(date);

    // Format the day of week using 'EEEE' format.
    String dayOfWeek = DateFormat('EEEE').format(date);

    // Get the day of the month.
    int dayOfMonth = date.day;

    // Add the correct suffix to the day of the month (st, nd, rd, or th).
    String daySuffix;
    if (dayOfMonth % 10 == 1 && dayOfMonth % 100 != 11) {
      daySuffix = 'st';
    } else if (dayOfMonth % 10 == 2 && dayOfMonth % 100 != 12) {
      daySuffix = 'nd';
    } else if (dayOfMonth % 10 == 3 && dayOfMonth % 100 != 13) {
      daySuffix = 'rd';
    } else {
      daySuffix = 'th';
    }

    // Combine all the parts to get the final formatted date.
    String formattedDate = '$monthAndDay$daySuffix, $dayOfWeek';
    return formattedDate;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    SmolleyNotification.checkScheduledNotifications(
        flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bcalendar,
      key: scaffoldkey,
      body: istapped
          ? SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: bpadding,
                      decoration: const BoxDecoration(
                          color: calendar,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Home()));
                                  },
                                  icon: const Icon(
                                    Icons.home,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableCalendar(
                            //rowHeight: 20,
                            calendarStyle: CalendarStyle(
                              defaultTextStyle: TextStyle(
                                  fontFamily: 'WorkSans',
                                  fontSize: 15.sp,
                                  color: Colors.white),

                              //titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              defaultDecoration: BoxDecoration(

                                  //shape: BoxShape.rectangle,
                                  //borderRadius: BorderRadius.circular(10),
                                  //color: Colors.grey[200]
                                  //color: Colors.transparent, // Change the color to your desired background color
                                  //border: Border.all(color: Colors.grey), // Add a border to each day
                                  ),
                              weekendDecoration: BoxDecoration(
                                  //shape: BoxShape.rectangle,
                                  //borderRadius: BorderRadius.circular(10),
                                  //color: Color.fromARGB(255, 183, 149, 98)

                                  ),
                              todayDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 148, 61, 7),
                                //borderRadius: BorderRadius.circular(10),
                              ),
                              selectedDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 233, 148, 95),
                                //borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: true,
                              titleCentered: true,
                              formatButtonDecoration: BoxDecoration(
                                  color: Color.fromARGB(255, 233, 148, 95),
                                  borderRadius: BorderRadius.circular(10)),
                              titleTextStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekendStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                //fontWeight: FontWeight.bold,
                              ),
                              weekdayStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),

                            currentDay: DateTime.now(),
                            firstDay: DateTime.now(),
                            lastDay: DateTime.utc(2230, 3, 14),
                            focusedDay: _focusedDay,

                            headerVisible: true,
                            daysOfWeekVisible: true,
                            eventLoader: _getEventsfromDay,
                            calendarBuilders: CalendarBuilders(
                                markerBuilder: (context, day, events) {
                              if (events.isEmpty) return const SizedBox();
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    padding: const EdgeInsets.all(1),
                                    child: Container(
                                      // height: 7,
                                      width: 5.w,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.primaries[Random()
                                              .nextInt(
                                                  Colors.primaries.length)]),
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        events.length.toString(),
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.white),
                                      ))
                                ],
                              );
                            }),
                            availableCalendarFormats: const {
                              CalendarFormat.month: 'Month',
                              //CalendarFormat.week: 'Week',
                            },
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              if (!isSameDay(_selectedDay, selectedDay)) {
                                // Call `setState()` when updating the selected day
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay =
                                      focusedDay; // update `_focusedDay` here as well
                                });
                                if (_getEventsfromDay(_focusedDay).isEmpty) {
                                  setState(() {
                                    istapped = false;
                                  });
                                  _showbottomsheet();
                                }
                              }
                            },
                            calendarFormat: _calendarFormat,
                            onFormatChanged: (format) {
                              if (_calendarFormat != format) {
                                // Call `setState()` when updating calendar format
                                setState(() {
                                  _calendarFormat = format;
                                });
                              }
                              ;
                            },

                            onPageChanged: (focusedDay) {
                              // No need to call `setState()` here
                              _focusedDay = focusedDay;
                            },

                            //availableGestures: AvailableGestures.none,
                            //CalendarFormat.month : 'Month',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: bpadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatDate(_focusedDay),
                            style: TextStyle(
                                fontSize: 30.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'On this day',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          ..._getEventsfromDay(_focusedDay).map(
                            (event) => GestureDetector(
                              onLongPress: () {
                                options.deleteeventmessage(context, event.id);
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 20),
                                padding: EdgeInsets.only(
                                    right: 10, left: 10, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(event.title,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(event.time)
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (event.checked == 'true') {
                                          mysql.updateEvent(event.id, 'false');
                                          getdata();
                                        } else {
                                          mysql.updateEvent(event.id, 'true');
                                          getdata();
                                        }
                                      },
                                      child: Container(
                                        width: 50.w,
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: event.checked == 'true'
                                                ? Colors.black
                                                : Colors.grey.shade200),
                                        child: event.checked == 'true'
                                            ? Icon(
                                                Icons.done_all,
                                                color: Colors.white,
                                              )
                                            : SizedBox(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          : BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: SafeArea(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.black,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            istapped = true;
                          });
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: Visibility(
        visible: istapped,
        child: FloatingActionButton(
          onPressed: () {
            //Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNote()));
            setState(() {
              istapped = false;
            });
            _showbottomsheet();
          },

          backgroundColor: Colors.black,

          child: const Icon(Icons.create),
          //child: Text('Create Invoice'),
        ),
      ),
    );
  }

  void _showbottomsheet() {
    scaffoldkey.currentState!.showBottomSheet(
        enableDrag: false,
        backgroundColor: calendar,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ), (context) {
      DateTime time = DateTime.now();
      final dDay = DateTime.utc(_focusedDay.year, _focusedDay.month,
          _focusedDay.day, _focusedDay.minute);
      DateTime date = dDay.toUtc();

      print(date);
      return StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.30,
            padding: const EdgeInsets.only(left: 20, right: 20),
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Divider(
                  indent: 150,
                  endIndent: 150,
                  color: Colors.white,
                  thickness: 3,
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                            style:
                                TextStyle(fontSize: 25.sp, color: Colors.white),
                            controller: remainder,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill in this field';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 20),
                              filled: true,
                              fillColor: Color(0XFF424B56),
                              hintText: 'Enter Remainder',
                              hintStyle: TextStyle(
                                  color: Colors.white, fontSize: 25.sp),
                              focusColor: Colors.black,
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Colors.red)),
                              focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Colors.red)),
                            ))
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        final mydate = await pickdatetime(time, true);
                        if (mydate == null) return null;
                        final dDay =
                            DateTime.utc(mydate.year, mydate.month, mydate.day)
                                .toUtc();
                        print(dDay);
                        setState(() {
                          date = dDay;
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  'Date',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              DateFormat.yMMMd().format(date),
                              style: TextStyle(fontSize: 20.sp),
                            )),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final mydate = await pickdatetime(time, false);
                        if (mydate == null) return null;
                        setState(() => time = DateTime(date.year, date.month,
                            date.day, mydate.hour, mydate.minute));
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_alarm,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                              DateFormat.Hm().format(time),
                              style: TextStyle(fontSize: 20.sp),
                            )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      print(time);
                      mysql.insertevent(remainder.text, date, time, "false");
                      remainder.clear();

                      //Navigator.push(context, MaterialPageRoute(builder: (context)=> ListScreen())
                      print(selectedEvents.entries);
                      SmolleyNotification.ShowNotification(
                          title: 'Hey there! Do you know what time it is?',
                          body: remainder.text,
                          fn: flutterLocalNotificationsPlugin,
                          time: time);

                      SmolleyNotification.checkScheduledNotifications(
                          flutterLocalNotificationsPlugin);
                      getdata();
                      setState(() => istapped = true);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(100.w, 20.h),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Save Task',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Future<DateTime?> pickdatetime(DateTime initialdate, bool dateortime) async {
    final timetheme = ThemeData.dark().copyWith(
        timePickerTheme: TimePickerThemeData(
            backgroundColor: calendar,
            hourMinuteColor: MaterialStateColor.resolveWith((states) =>
                states.contains(MaterialState.selected)
                    ? Colors.blue.shade100
                    : Colors.white),
            hourMinuteShape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent)),
            dayPeriodColor: Colors.white,
            dayPeriodBorderSide: BorderSide(color: Colors.transparent),
            hourMinuteTextColor: Colors.purple,
            dialHandColor: Colors.purple,
            dialBackgroundColor: Colors.white,
            dialTextColor: calendar,
            cancelButtonStyle: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Color(0XFF424B56)),
              foregroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            ),
            confirmButtonStyle: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Color(0XFF424B56)),
              foregroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
            )));
    final datetheme = ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(primary: Colors.white),
        primaryColor: Colors.white,
        textTheme: TextTheme(
            headlineMedium:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        datePickerTheme: DatePickerThemeData(
          rangePickerHeaderBackgroundColor: Colors.white,
          rangePickerHeaderHelpStyle: TextStyle(color: Colors.white),
          backgroundColor: calendar,
          dayStyle: TextStyle(color: Colors.white),
          rangePickerHeaderHeadlineStyle: TextStyle(color: Colors.white),
          rangePickerBackgroundColor: Colors.white,
          elevation: double.maxFinite,
          headerBackgroundColor: calendar,
          headerForegroundColor: calendar,
          headerHeadlineStyle: TextStyle(color: Colors.white),
          headerHelpStyle: TextStyle(color: Colors.white),
          todayBackgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.orange),
          todayForegroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white),
        ));
    if (dateortime) {
      final datepicked = await showDatePicker(
          builder: (context, child) {
            return Theme(data: datetheme, child: child!);
          },
          context: context,
          initialDate: initialdate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2050));
      return datepicked;
      //final time = Duration(hours: initialdate.hour, minutes: initialdate.minute);
    } else {
      final timepicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialdate),
        builder: (context, child) {
          return Theme(data: timetheme, child: child!);
        },
      );
      if (timepicked == null) return null;
      final date =
          DateTime(initialdate.year, initialdate.month, initialdate.day);
      final time = Duration(hours: timepicked.hour, minutes: timepicked.minute);
      return date.add(time);
    }
  }
}
