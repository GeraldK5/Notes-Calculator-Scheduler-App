import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smolleytoolbox/constants.dart';
import 'package:smolleytoolbox/screens/home.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smolleytoolbox/notification.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SmolleyNotification.initialize(flutterLocalNotificationsPlugin);
    Future.delayed(Duration(seconds: 5), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background1,
      body: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
        padding: bpadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('images/walking.gif'),
              SizedBox(
                height: 20.h,
              ),
              Center(
                  child: Text(
                'Welcome to my Smolleys toolbox',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: greenColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 60.sp),
              )),
              SizedBox(
                height: 100.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //IconButton(onPressed: onPressed, icon: icon),
                  IconButton(
                    onPressed: () {},
                    icon: Transform.scale(
                        scale: 4.0, child: Image.asset('images/note.gif')),
                  ),
                  //SizedBox(width: 50,),
                  IconButton(
                    onPressed: () {},
                    icon: Transform.scale(
                        scale: 4.0,
                        child: Image.asset('images/calculator.gif')),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Transform.scale(
                        scale: 4.8, child: Image.asset('images/calendar.gif')),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
