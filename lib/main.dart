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
        scaffoldBackgroundColor: const Color.fromARGB(255, 10, 10, 10),
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
  final Color _textColor = const Color.fromARGB(255, 228, 228, 228);
  Color _dateColor = const Color.fromARGB(255, 228, 228, 228);
  Timer? _timer;

  /// sets [_date] and [_time] to [date_],
  /// if [date_] is not provided current local time is used
  void _setCurrentDate([DateTime? date_]) {
    setState(() {
      // if no date is provided use the current time
      date_ ??= DateTime.now();
      DateTime date = date_!;

      // offset date to the b36 start of year
      date = date.subYears(1);
      date = date.addDays(121);

      int year = date.getYear;
      int day = date.getDayOfYear;

      // a b36 season consists of 91 days
      int season = day ~/ 91;
      day %= 91;
      // a b36 week consists of 13 days
      int week = day ~/ 13;
      day %= 13;

      // fromat values according to b36 standard format
      String y = year.toRadixString(36).padLeft(3, "0");
      String s = (season + 1).toRadixString(5).characters.last;
      String w = (week + 1).toString();
      String d = day.toRadixString(13);

      // set class members

      date = DateTime.now().toLocalTime;
      int milliSeconds = (((date.hour) * 60 + date.minute) * 60 + date.second) * 1000 + date.millisecond;
      int bigS = (milliSeconds.toDouble() / (36 * 24) * 1000).floor();
      int miliS = bigS % 1000 ~/ 100;
      bigS ~/= 1000;
      // int midS = bigS % 10000;
      // bigS ~/= 10000;
      // int smallS = midS % 100;
      // midS ~/= 100;
      int midS = bigS ~/ 1000;
      int smallS = bigS % 1000;

      _date =
          "$y/$s$w-$d ${midS.toString().padLeft(2, "0")}'${smallS.toString().padLeft(3, "0")}\""; //${miliS.toString().padLeft(1, "0")}";
      _time =
          "${date.year.toString().padLeft(4, "0")}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")} ${(date.hour).toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}:${date.second.toString().padLeft(2, "0")}";
      // "${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}:${date.second.toString().padLeft(2, "0")}";
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(microseconds: 10000), (Timer t) => _setCurrentDate());
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
      child: Container(
        margin: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 500),
        child: ListView(
          children: [
            Post("Datetime right now:", ["B36 Local Time: $_date", "Gregorian Local Time: $_time"]),
            Post("1k6/25-7", [
              "A start ... yet again.",
              "I truely hope I will not loose this start. I have started this project so many times, but I have always got lost in it, got off track or moved to a different platform to make this a reality. Not long before this I started to look for something that could support my plan of releaseing this to the web, on mibile and on desktop as well, and I decided on flutter. I really hope I will not regret this decision too soon.",
              "I have a lot of plans on what and how I want to achive with qu2s (maybe even too much), but I don't like to talk about plans, because they can change so much in development. Though maybe it would be good to document them in a way so that I can see how things changed.",
              "Well, I will see, what the future holds..."
            ]),
          ],
        ),
      ),
    ));
  }

  Column Post(String title, List<String> content) {
    Column c = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [PostParagraph(""), PostTitle(title)],
    );
    for (var par in content) {
      c.children.add(PostParagraph(par));
    }
    c.children.add(PostParagraph(""));
    return c;
  }

  Text PostParagraph(String par) {
    return Text(
      "\n$par",
      style: TextStyle(color: _textColor, fontSize: 12, fontFamily: "Fira code"),
    );
  }

  Text PostTitle(String title) {
    return Text(
      " $title \n${"-" * (title.length + 2)}",
      style: TextStyle(color: _textColor, fontSize: 16, fontFamily: "Fira code", fontWeight: FontWeight.bold),
    );
  }
}
