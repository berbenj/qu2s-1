import 'dart:async';
import 'package:ntp/ntp.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

import 'q2_date.dart';

void main() async {
  runApp(const Qu2sApp());
}

class Qu2sApp extends StatelessWidget {
  const Qu2sApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'qu2s',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          scaffoldBackgroundColor: const Color(0xFF0a0a0a),
          primaryColor: Colors.white,
          fontFamily: "Roboto",
          scrollbarTheme: const ScrollbarThemeData(
            thumbColor: MaterialStatePropertyAll(Color(0xff444444)),
            minThumbLength: 30,
            trackVisibility: MaterialStatePropertyAll(false),
          )),
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: q2AppBar(),
            body: q2AppBody(),
          )),
      //const HomePage(title: 'Home Page'),
    );
  }

  TabBarView q2AppBody() {
    return const TabBarView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        HomePage(title: 'Home Page'),
        CalendarPage(),
      ],
    );
  }

  AppBar q2AppBar() {
    return AppBar(
      elevation: 5,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: const [
            Icon(Icons.signpost),
            Text(
              " qu2s",
              style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Fira code", fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      toolbarHeight: 0,
      backgroundColor: const Color(0xFF0a0a0a),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(kBottomNavigationBarHeight),
        child: SizedBox(
          width: 200,
          child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Color(0xFFaaaaaa),
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
              tabs: [
                Tab(text: "Home"),
                Tab(text: "Calendar"),
              ]),
        ),
      ),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    super.key,
  });

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Widget? event;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
              ),
              onPressed: () {
                setState(() {
                  event = Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(color: Colors.orange),
                  );
                });
              },
              child: const Text('Add event'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
              ),
              onPressed: () {
                setState(() {
                  event = null;
                });
              },
              child: const Text('Remove event'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          key: const Key("event_container"),
          decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(color: Color(0xFFffffff)),
                  bottom: BorderSide(color: Color(0xFFffffff)),
                  left: BorderSide(color: Color(0xFFffffff)),
                  right: BorderSide(color: Color(0xFFffffff)))),
          height: 200,
          width: 200,
          child: Center(child: event),
        ),
      ],
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
  String _b36Date = "";
  String _mtArton = "";
  String _mtJitt = "";
  String _gregorianDate = "";
  String _gregorianHour = "";
  String _gregorianMinute = "";
  String _gregorianSecond = "";
  final Color _textColor = const Color.fromARGB(255, 228, 228, 228);
  Timer? _timer;
  int offset = 0;
  final ScrollController _scrollController = ScrollController();

  void _setCurrentDate([DateTime? date_]) {
    setState(() {
      // if no date is provided use the current time
      date_ ??= DateTime.now().toLocalTime;
      DateTime date = date_!;
      date = date.addMilliseconds(offset);

      Q2Date qdt = Q2Date(date);

      // TODO: make seperation characters costumizable
      _b36Date = "${qdt.b36Year}-${qdt.b36Pernor}${qdt.b36Scrop}-${qdt.b36Day}";
      _mtArton = "${qdt.mtArton}'";
      _mtJitt = " ${qdt.mtJitt}\"";

      _gregorianDate = "${qdt.grYear}-${qdt.grMonth}-${qdt.grDay}";
      _gregorianHour = qdt.sdHour;
      _gregorianMinute = ":${qdt.sdMinute}";
      _gregorianSecond = " :${qdt.sdSecond}";
    });
  }

  @override
  void initState() {
    super.initState();
    _getTime(DateTime.now());
    _timer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) => _setCurrentDate());
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) => _getTime(DateTime.now()));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getTime(DateTime time) async {
    // question: how much does this cost?
    offset = await NTP.getNtpOffset(localTime: time);
  }

  @override
  Widget build(BuildContext context) {
    _setCurrentDate();

    return Scaffold(
      body: Scrollbar(
        thumbVisibility: true,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 700,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        gregorianClock(),
                        const SizedBox(width: 30),
                        b36Clock(),
                      ]),
                ),
                post("1k6/33-c", [
                  "First of all, unfortuniatly I didn't manage to progress much these times. Partly because of work, partly because of my own lazyness getting the best of me. But still I will write down the little progress I made these 2 scrop.",
                  "I decided to post a scroply update, in a devblog style. I will do this as part of me ending the sprint by presenting the developments of that sprint to the stakeholders. It will mean a consistent update for anyone who is following the project, and a good motivation to not drift off and have something that I can actually present at the end of each sprint. (also, I'm aligning the sprints with scrops)",
                  "I also decided to not continue working on the scheduling allgorithm, as refining it is not critical now. Rather focus on the things that are most critical and give the most value. And as of right now the app is not connecting to a database. After looking around I wanted to connect it to Firebase, but there is a problem. I want this app to run on windows, but Firebase's Flutter package by default doesn't connect to windows. I was looking around and found possible solutions, but I didn't manage to make it work so far.",
                  "Anyways, connecting to a database will be the next step, after that I want to refactor my code a bit, and also start to write testing for my code, as you can never start that too early.",
                ]),
                post("1k6/31-b", [
                  "The more I'm thinking about how to solve this shuffeling problem, the more complicated it gets. Though it probably doesn't help, that I also am coming up with more and more ideas for costumization, and also features that I want my algorithm to be capable of doing.",
                  "But I'm sure it will work out in the end. And after I figure out how I really want it to work I will try to explain it, cos right now you only know that it tries to ararnges events in a calendar \"optimally\". Untill then, look forward to it, beacause I have never seen a system similar to this one, and I plan to release it for free Though right now ther is not even a platform for manual event placing/watching, so I have to do that as well."
                ]),
                post("1k6/31-a", [
                  "A few days back I started working on an algorithm that can arrange events in a calendar automatically the best way possible. Ultimatelly I want to have all kinds of features like: multi level availability, priority, breakable tasks, balancing, repeating, and others; but now I just want to make the most simple one as reliable as possible.",
                  "For this I came up with four methods that can help placing these events, these are: order them for least flexibility, pushing events up and down to make space, swap events, and grouping free spaces while planning, and spreading them after it's done. Reading back to what I just wrote I don't think any of them completely understandable, but whatever, I know what I want to do. I completed the ordering, and finished the first case for the second method, and I think this will work out.",
                  "Actually my main concern is that my ideas of trying to place and move around these events may be flawed. I tried to look for similar problems but I couldn't find any. I hope that I will not miss anything while implementing these methods, and that my methods will give a pretty good result.",
                  "I also improved on the time accuricy with the help of NTP (Network Time Protocol).",
                ]),
                post("1k6/25-7", [
                  "A start ... yet again.",
                  "I truely hope I will not loose this start. I have started this project so many times, but I have always got lost in it, got off track or moved to a different platform to make this a reality. Not long before this I started to look for something that could support my plan of releaseing this to the web, on mibile and on desktop as well, and I decided on flutter. I really hope I will not regret this decision too soon.",
                  "I have a lot of plans on what and how I want to achive with qu2s (maybe even too much), but I don't like to talk about plans, because they can change so much in development. Though maybe it would be good to document them in a way so that I can see how things changed.",
                  "Well, I will see, what the future holds...",
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column b36Clock() {
    return Column(
      children: [
        Text(
          _b36Date,
          style: TextStyle(color: _textColor, fontSize: 20, fontWeight: FontWeight.w300),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _mtArton,
              style: TextStyle(color: _textColor, fontSize: 34, fontWeight: FontWeight.w900),
            ),
            Text(
              _mtJitt,
              style: TextStyle(color: _textColor, fontSize: 20, fontWeight: FontWeight.w300, height: 1.4),
            ),
          ],
        ),
      ],
    );
  }

  Column gregorianClock() {
    return Column(
      children: [
        Text(
          _gregorianDate,
          style: TextStyle(color: _textColor, fontSize: 20, fontWeight: FontWeight.w300),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _gregorianHour,
              style: TextStyle(color: _textColor, fontSize: 34, fontWeight: FontWeight.w900),
            ),
            Text(
              _gregorianMinute,
              style: TextStyle(color: _textColor, fontSize: 34, fontWeight: FontWeight.w300),
            ),
            Text(
              _gregorianSecond,
              style: TextStyle(color: _textColor, fontSize: 20, fontWeight: FontWeight.w300, height: 1.4),
            ),
          ],
        ),
      ],
    );
  }

  Widget post(String title, List<String> content) {
    Column c = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [postTitle(title)],
    );
    for (var par in content) {
      c.children.add(postParagraph(par));
    }

    return Center(
      child: Container(
        width: 700,
        padding: const EdgeInsets.all(20),
        child: c,
      ),
    );
  }

  Text postParagraph(String par) {
    return Text(
      "\n$par",
      style:
          TextStyle(color: _textColor, fontSize: 14, fontFamily: "Fira code", fontWeight: FontWeight.w300, height: 1.5),
    );
  }

  Text postTitle(String title) {
    return Text(
      " $title \n${"-" * (title.length + 2)}",
      style: TextStyle(color: _textColor, fontSize: 18, fontFamily: "Fira code", fontWeight: FontWeight.bold),
    );
  }
}
