import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:intl/intl.dart' show DateFormat;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: TextTheme(
          display1: TextStyle(
            color: Colors.black38,
            fontSize: 30,
          ),
        ),
        fontFamily: 'Alatsi',
      ),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Clock(),
      ),
    );
  }
}

class BinaryTime {
  List<String> binaryIntegers;

  BinaryTime() {
    DateTime now = DateTime.now();
    String hhmmss = DateFormat("yMMddHHmmss").format(now).replaceAll(':', '');

    binaryIntegers = hhmmss
        .split('')
        .map((str) => int.parse(str).toRadixString(2).padLeft(4, '0'))
        .toList();
  }

  get yearThousands => binaryIntegers[0];
  get yearHundreds => binaryIntegers[1];
  get yearTens => binaryIntegers[2];
  get yearOnes => binaryIntegers[3];

  get monthTens => binaryIntegers[4];
  get monthOnes => binaryIntegers[5];

  get dayTens => binaryIntegers[6];
  get dayOnes => binaryIntegers[7];

  get hourTens => binaryIntegers[8];
  get hourOnes => binaryIntegers[9];

  get minutesTens => binaryIntegers[10];
  get minutesOnes => binaryIntegers[11];

  get secondsTens => binaryIntegers[12];
  get secondsOnes => binaryIntegers[13];
}

class Clock extends StatefulWidget {
  Clock({Key key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  BinaryTime _now = BinaryTime();

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (value) {
      setState(() {
        _now = BinaryTime();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClockColumn(
            binaryInteger: _now.yearThousands,
            title: 'Y',
            color: Colors.deepOrange,
          ),
          ClockColumn(
            binaryInteger: _now.yearHundreds,
            title: 'Y',
            color: Colors.deepOrangeAccent,
          ),
          ClockColumn(
            binaryInteger: _now.yearTens,
            title: 'Y',
            color: Colors.orange,
          ),
          ClockColumn(
            binaryInteger: _now.yearOnes,
            title: 'Y',
            color: Colors.orangeAccent,
          ),
          ClockColumn(
            binaryInteger: _now.monthTens,
            title: 'M',
            color: Colors.green,
            rows: 1,
          ),
          ClockColumn(
            binaryInteger: _now.monthOnes,
            title: 'M',
            color: Colors.greenAccent,
          ),
          ClockColumn(
            binaryInteger: _now.dayTens,
            title: 'D',
            color: Colors.red,
            rows: 2,
          ),
          ClockColumn(
            binaryInteger: _now.dayOnes,
            title: 'D',
            color: Colors.redAccent,
          ),
          ClockColumn(
            binaryInteger: _now.hourTens,
            title: 'H',
            color: Colors.blue,
            rows: 2,
          ),
          ClockColumn(
            binaryInteger: _now.hourOnes,
            title: 'H',
            color: Colors.lightBlue,
          ),
          ClockColumn(
            binaryInteger: _now.minutesTens,
            title: 'M',
            color: Colors.green,
            rows: 3,
          ),
          ClockColumn(
            binaryInteger: _now.minutesOnes,
            title: 'M',
            color: Colors.lightGreen,
          ),
          ClockColumn(
            binaryInteger: _now.secondsTens,
            title: 'S',
            color: Colors.pink,
            rows: 3,
          ),
          ClockColumn(
            binaryInteger: _now.secondsOnes,
            title: 'S',
            color: Colors.pinkAccent,
          ),
        ],
      ),
    );
  }
}

class ClockColumn extends StatelessWidget {
  final String binaryInteger;
  final String title;
  final Color color;
  final int rows;

  List bits;

  ClockColumn({this.binaryInteger, this.title, this.color, this.rows = 4}) {
    bits = binaryInteger.split('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ...[
          Container(
            child: Text(
              title,
              style: Theme.of(context).textTheme.display1,
            ),
          )
        ],
        ...bits.asMap().entries.map((entry) {
          int i = entry.key;
          String bit = entry.value;

          bool isActive = bit == '1';
          int binaryCellValue = pow(2, 3 - i);

          return AnimatedContainer(
            duration: Duration(milliseconds: 475),
            curve: Curves.ease,
            height: 40,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
              color: isActive
                  ? color
                  : i < 4 - rows ? Colors.white.withOpacity(0) : Colors.black38,
            ),
            margin: EdgeInsets.all(4),
            child: Center(
              child: isActive
                  ? Text(
                      binaryCellValue.toString(),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.2),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : Container(),
            ),
          );
        }),
        ...[
          Text(
            int.parse(binaryInteger, radix: 2).toString(),
            style: TextStyle(fontSize: 30, color: color),
          ),
          Container(
            child: Text(
              binaryInteger,
              style: TextStyle(fontSize: 15, color: color),
            ),
          )
        ]
      ],
    );
  }
}
