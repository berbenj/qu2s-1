import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart'; // date manipulation

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

  bool _isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void _setCurrentDate() {
    setState(() {
      // offset date to the b36 start of year
      var date = DateTime.now();
      if (_isLeapYear(date.year)) {
        date = date.add(const Duration(days: -366));
      } else {
        date = date.add(const Duration(days: -365));
      }
      date = date.add(const Duration(days: 122));

      int year = date.year;
      int day = Jiffy(date).dayOfYear;

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
        _textColor = const Color.fromARGB(255, 150, 178, 244);
      } else {
        _textColor = const Color.fromARGB(255, 228, 228, 228);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
        const Duration(microseconds: 10), (Timer t) => _setCurrentDate());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setCurrentDate();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _firaText("Datetime right now:", Colors.white, 12),
            _firaText(_date, _textColor, 60),
            _firaText(_time, const Color.fromARGB(255, 228, 228, 228), 40),
          ],
        ),
      ),
    );
  }

  Text _firaText(String text, Color color, double fontSize) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: "Fira code",
      ),
    );
  }
}
