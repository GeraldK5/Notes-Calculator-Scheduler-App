import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smolleytoolbox/options.dart';
import 'package:smolleytoolbox/screens/calendar.dart';
import 'package:smolleytoolbox/sqlite.dart';

import '../constants.dart';
import 'home.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final mysql = sqlite();
  final options = Options();
  List<Map<String, dynamic>> events = [];

  Future<void> getdata() async {
    List<Map<String, dynamic>> myevents = await mysql.getevents();
    setState(() {
      events = myevents.toList();
    });
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
      body: Container(
        margin: bmargintop,
        padding: bpadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
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
              Text(
                'All my tasks ...',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      options.deleteeventmessage(context, events[index]['_id']);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.only(
                          right: 10, left: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                mysql.updateEvent(events[index]['_id'], 'true');
                                getdata();
                              }
                            },
                            child: Container(
                              width: 50.w,
                              height: 50.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: events[index]['checked'] == 'true'
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Calendar()));
        },

        backgroundColor: Colors.black,

        child: Icon(Icons.create_rounded),
        //child: Text('Create Invoice'),
      ),
    );
  }
}
