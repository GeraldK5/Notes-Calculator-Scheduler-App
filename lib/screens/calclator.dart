import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:smolleytoolbox/screens/home.dart';
import '../constants.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  bool mode = false;

  String userInput = "";
  String result = "0";
  Color textcolor = Colors.black;
  Map<String, String> operatorsMap = {"÷": "/", "X": "*", "−": "-", "+": "+"};
  List<String> buttonList = [
    'C',
    '(',
    ')',
    '÷',
    '7',
    '8',
    '9',
    'X',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '.',
    '0',
    '⌫',
    '=',
  ];
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = mode ? Color(0XFFE2E0E0) : Colors.black;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          padding: bpadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 40,
                    child: LiteRollingSwitch(
                        width: MediaQuery.of(context).size.width * 0.3,
                        textOff: '',
                        textOn: '',
                        colorOn: Color(0XFF4E505F),
                        colorOff: Color(0XFF4E505F),
                        value: mode,
                        iconOn: Icons.nightlight,
                        iconOff: Icons.wb_sunny,
                        onTap: () {},
                        onDoubleTap: () {},
                        onSwipe: () {},
                        animationDuration: const Duration(microseconds: 200),
                        onChanged: (bool state) {
                          setState(() {
                            mode = state;
                            textcolor = Colors.white;
                          });
                        }),
                  ),
                  Spacer(),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: mode ? Colors.black : Colors.white,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      icon: Icon(Icons.home,
                          color: mode ? Colors.white : Colors.black),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.centerRight,
                child: Text(
                  userInput,
                  style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 40.sp,
                      color: Colors.grey.withOpacity(0.7)),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.centerRight,
                child: FittedBox(
                  child: Text(
                    result,
                    style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 90.sp,
                      color: mode ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: buttonList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12),
                    itemBuilder: (context, index) {
                      return CustomButton(buttonList[index]);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget CustomButton(String text) {
    return InkWell(
      //splashColor: Color(0xFF1d2630),
      onTap: () {
        HapticFeedback.mediumImpact();
        setState(() {
          handlebutton(text);
        });
      },
      child: Ink(
        decoration: BoxDecoration(
          color: getBgcolor(text),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              fontFamily: 'WorkSans',
              color: getTxtcolor(text),
              fontSize: 30.sp),
        )),
      ),
    );
  }

  getTxtcolor(String text) {
    if (mode) {
      if (text == "X" ||
          text == "+" ||
          text == "-" ||
          text == "=" ||
          text == "÷") {
        return Colors.white;
      }
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  getBgcolor(String text) {
    if (text == "C" || text == ")" || text == "(") {
      if (mode) {
        return Color(0XFFD2D3DA);
      } else {
        return Color(0XFF4E505F);
      }
    }
    if (text == "=" ||
        text == "÷" ||
        text == "X" ||
        text == "-" ||
        text == "+") {
      return Color(0XFF4B5EFC);
    }
    return mode ? Colors.white : Color(0XFF2E2F38);
  }

  handlebutton(String text) {
    if (text == "C") {
      userInput = "";
      result = "0";
      return;
    }
    if (text == "⌫") {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(0, userInput.length - 1);

        return;
      } else
        return;
    }
    if (text == "=") {
      result = Calculate();
      userInput = result;
      if (userInput.endsWith(".0")) {
        userInput = userInput.replaceAll(".0", "");
        return;
      }
      if (result.endsWith(".0")) {
        result = result.replaceAll(".0", "");
        return;
      }
    }
    if (text == "=") {
      userInput = userInput;
    } else {
      userInput = userInput + text;
    }
  }

  String Calculate() {
    try {
      // Fix equation
      Expression exp = (Parser()).parse(operatorsMap.entries.fold(
          userInput, (prev, elem) => prev.replaceAll(elem.key, elem.value)));

      double res = double.parse(
          exp.evaluate(EvaluationType.REAL, ContextModel()).toString());

      // Output correction for decimal results
      var result =
          double.parse(res.toString()) == int.parse(res.toStringAsFixed(0))
              ? res.toStringAsFixed(0)
              : res.toStringAsFixed(6);
      return result;
    } catch (e) {
      return "Error";
    }
  }
}
