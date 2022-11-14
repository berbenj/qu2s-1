import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'qu2s',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color.fromARGB(255, 20, 20, 20),
        primaryColor: Colors.white,
      ),
      home: const HomePage(title: 'Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _date = "";
  String _time = "";
  Color _textColor = const Color.fromARGB(255, 228, 228, 228);
  Timer? _timer;

  bool _isLeapYear(int year) => (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  void _setCurrentDate(DateTime date) {
    setState(() {
      // offset date to the b36 start of year
      date = date.subYears(1);
      date = date.addDays(122);

      int year = date.getYear;
      int day = date.getDayOfYear;

      int season = day ~/ 91;
      day %= 91;
      int week = day ~/ 13;
      day %= 13;

      String y = year.toRadixString(36).padLeft(3, "0");
      String s = (season + 1).toRadixString(5).characters.last;
      String w = (week + 1).toString();
      String d = day.toRadixString(13);

      _date = "$y/$s$w-$d";
      _time =
          "${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}:${date.second.toString().padLeft(2, "0")}";

      if (day % 3 == 0) {
        _textColor = const Color.fromARGB(255, 167, 190, 243);
      } else {
        _textColor = const Color.fromARGB(255, 228, 228, 228);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(microseconds: 10), (Timer t) => _setCurrentDate(DateTime.now()));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setCurrentDate(DateTime.now());

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _veraText('Datetime right now:', Colors.white30, 20),
            _firaText(_date, _textColor, 60),
            _firaText(_time, Colors.white, 40),
          ],
        ),
      ),
    );
  }

  Text _firaText(String text, Color color, double size) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: size, fontFamily: "Fira code", fontWeight: FontWeight.w300),
    );
  }

  Text _veraText(String text, Color color, double size) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: size, fontFamily: "Varela round"),
    );
  }
}

/// FOR TSTING:

@visibleForTesting
class TestHomePageState extends _HomePageState {
  @visibleForTesting
  bool isLeapYearTest(int year) => _isLeapYear(year);
  Text firaTextTest(String text, Color color, double size) => _firaText(text, color, size);
}
