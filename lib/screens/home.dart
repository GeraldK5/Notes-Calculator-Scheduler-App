import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smolleytoolbox/screens/calclator.dart';
import 'package:smolleytoolbox/screens/calendar.dart';
import 'package:smolleytoolbox/screens/createNote.dart';
import 'package:smolleytoolbox/screens/onboardingScreen.dart';
import 'package:smolleytoolbox/options.dart';
import 'package:smolleytoolbox/screens/tasks.dart';
import 'package:smolleytoolbox/sqlite.dart';
import '../constants.dart';
import 'view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final mysql = sqlite();
  final options = Options();
  List<Map<String, dynamic>> notes = [];
  List<Map<String, dynamic>> events = [];
  List<Map<String, dynamic>> filtered_list = [];
  bool _selected = false;
  Future<void> getdata() async {
    List<Map<String, dynamic>> mynotes = await mysql.getdata();
    List<Map<String, dynamic>> myevents = await mysql.getevents();
    setState(() {
      notes = mynotes.take(2).toList();
      filtered_list = mynotes.take(2).toList();
      events = myevents.take(5).toList();
    });
  }

  void Searchevent(String query) {
    final suggestions = notes.where((note) {
      final title = note['Title'].toString().toLowerCase();
      final input = query.toLowerCase();
      return title.contains(input);
    }).toList();
    setState(() => filtered_list = suggestions);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background2,
        body: _selected
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              )
            : Container(
                margin: bmargintop,
                padding: bpadding,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset('images/hello.gif', scale: 10.0),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                              child: Text(
                            'Hello,',
                            style: TextStyle(fontSize: 20.sp),
                          )),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.green,
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OnBoarding()));
                              },
                              icon: const Icon(
                                Icons.home,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              //blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextField(
                          //controller: search,
                          onChanged: (value) {
                            Searchevent(value);
                          },
                          style: TextStyle(color: Colors.grey, fontSize: 20.sp),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            hintText: 'Search for note',
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            //fillColor: biconcolor,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          //IconButton(onPressed: onPressed, icon: icon),
                          Text(
                            'My Notes',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 35.sp),
                          ),
                          //SizedBox(width: 50,),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.black,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.create,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewScreen()));
                              },
                              child: Text(
                                'View all',
                                style: TextStyle(fontSize: 18.sp),
                              )),
                        ],
                      ),
                      GridView.builder(
                          shrinkWrap: true,
                          itemCount: filtered_list.length,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CreateNote(note: notes[index]),
                                    ));
                              },
                              onLongPress: () {
                                HapticFeedback.mediumImpact();
                                options.deletenotemessage(
                                    context, notes[index]['_id']);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                //constraints: BoxConstraints.tightFor(height: double.infinity),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color:
                                        cardColors[index % cardColors.length],
                                    borderRadius: BorderRadius.circular(30)),
                                // width: 150.w,
                                // height: 130.h,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${filtered_list[index]['Title'][0].toUpperCase()}${filtered_list[index]['Title'].substring(1)}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp,
                                          color: Colors.black,
                                        ),

                                        // style: TextStyle(
                                        //   fontWeight: FontWeight.bold,
                                        //   fontSize: 20.sp,
                                        //   color: Colors.black,
                                        // ),
                                      ),
                                      Divider(
                                        height: 10.h,
                                        thickness: 2,
                                        color: Colors.black,
                                      ),
                                      SizedBox(height: 12.h),
                                      Text(
                                        filtered_list[index]['notes'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: const Color.fromARGB(
                                              255, 59, 43, 43),
                                          fontSize: 16.sp,
                                          letterSpacing: 0.5,
                                          height: 1.2,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      FittedBox(
                                        child: Text(
                                          filtered_list[index]['time']
                                              .toString(),
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12.sp,
                                            color: Colors.black26,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          //IconButton(onPressed: onPressed, icon: icon),
                          Text(
                            'My Tasks',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 35.sp),
                          ),
                          //SizedBox(width: 50,),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.black,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.calendar_month,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Tasks()));
                              },
                              child: Text(
                                'View all',
                                style: TextStyle(fontSize: 18.sp),
                              )),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onLongPress: () {
                              options.deleteeventmessage(
                                  context, events[index]['_id']);
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
                                        Text(events[index]['Title'],
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          events[index]['starttime'],
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 17.sp,
                                            color: Colors.black26,
                                            letterSpacing: 0.5,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (events[index]['checked'] == 'true') {
                                        mysql.updateEvent(
                                            events[index]['_id'], 'false');
                                        getdata();
                                      } else {
                                        mysql.updateEvent(
                                            events[index]['_id'], 'true');
                                        getdata();
                                      }
                                    },
                                    child: Container(
                                      width: 50.w,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color:
                                              events[index]['checked'] == 'true'
                                                  ? Colors.black
                                                  : Colors.grey.shade200),
                                      child: events[index]['checked'] == 'true'
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
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_selected) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Notes',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  FloatingActionButton(
                      heroTag: "notes",
                      backgroundColor: Colors.black,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewScreen()));
                      },
                      child: const Icon(Icons.note_alt_sharp))
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Day Planner',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  FloatingActionButton(
                      heroTag: "calendar",
                      backgroundColor: Colors.black,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Calendar()));
                      },
                      child: const Icon(Icons.calendar_month))
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Calculator',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  FloatingActionButton(
                      heroTag: "calculator",
                      backgroundColor: Colors.black,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Calculator()));
                      },
                      child: const Icon(Icons.calculate_outlined))
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
            FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {
                setState(() {
                  _selected = !_selected;
                });
              },
              child: _selected ? Icon(Icons.close) : Icon(Icons.add),
            )
          ],
        ));
  }
}
