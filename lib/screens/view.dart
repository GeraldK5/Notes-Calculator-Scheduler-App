import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smolleytoolbox/constants.dart';
import 'package:smolleytoolbox/options.dart';
import 'package:smolleytoolbox/screens/createNote.dart';
import 'package:smolleytoolbox/sqlite.dart';

import 'home.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  final mysql = sqlite();
  final options = Options();
  List<Map<String, dynamic>> notes = [];
  Future<void> getdata() async {
    List<Map<String, dynamic>> mynotes = await mysql.getdata();
    setState(() {
      notes = mynotes;
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
                'All My Notes ...',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp),
              ),
              GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: notes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        options.deletenotemessage(context, notes[index]['_id']);
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        //constraints: BoxConstraints.tightFor(height: double.infinity),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: cardColors[index % cardColors.length],
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${notes[index]['Title'][0].toUpperCase()}${notes[index]['Title'].substring(1)}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                  color: Colors.black,
                                ),
                              ),
                              Divider(
                                height: 10.h,
                                thickness: 2,
                              ),
                              SizedBox(height: 5.h),
                              Expanded(
                                child: Text(
                                  notes[index]['notes'],
                                  //maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color:
                                        const Color.fromARGB(255, 59, 43, 43),
                                    fontSize: 16.sp,
                                    letterSpacing: 0.5,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                notes[index]['time'].toString(),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12.sp,
                                  color: Colors.black26,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateNote(
                          note: {},
                        )));
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.create)
          //child: Text('Create Invoice'),
          ),
    );
  }
}
