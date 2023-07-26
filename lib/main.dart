import 'package:firedart/auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:fluent_ui/fluent_ui.dart' as fluent_ui;

import 'q2_platform.dart';

import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/task.dart';
import 'pages/timeline.dart';

Q2Platform q2Platform = Q2Platform();

// todo: move this to a app config
const String version = 'v0.0.0-0.1';

void main() {
  connectToDatabase();
  runApp(const Qu2sApp());
}

// todo: extract database reletad things to a seperate libriray
// firestore
// - can crud all collection, all doc,
// - can stream any collection, doc
// - can use a fake db for testing
// auth
// - can do everything
// storage
// - can crud anything
void connectToDatabase() async {
  if (q2Platform.isWeb) {
    FirebaseAuth.initialize(
        'AIzaSyCFfMcpev4TWt3yst8pNID9Qicu6vX8Q9E', fd.VolatileStore());
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } else if (q2Platform.isWindows) {
    fd.FirebaseAuth.initialize(
        'AIzaSyCFfMcpev4TWt3yst8pNID9Qicu6vX8Q9E', fd.VolatileStore());
    fd.Firestore.initialize('qu2s-e9232');
  } else {
    // todo: implement for android (linux, macOS, iOS)
  }

  final auth = fd.FirebaseAuth.instance;

  // todo: move this to a user data folder
  await auth.signIn('dev@qu2s.com', 'bravebluequantumduck');
}

class Qu2sApp extends StatelessWidget {
  const Qu2sApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final auth = fd.FirebaseAuth.instance;

    return StreamBuilder(
      stream: auth.signInState,
      builder: (context, snapshot) {
        final Map<String, Widget> pages;
        if (auth.isSignedIn) {
          pages = {
            'Home': const HomePage(),
            'Task': const TaskPage(),
            'Timeline': const TimelinePage(),
            'Logout': const LoginPage(),
          };
        } else {
          pages = {
            'Home': const HomePage(),
            'Login': const LoginPage(),
          };
        }

        return MaterialApp(
          title: 'qu2s',
          theme: ThemeData(
              brightness: Brightness.dark,
              // primarySwatch: Colors.grey,
              // --text: #ecede9;
              // --background: #030302;
              // --primary: #373541;
              // --secondary: #10110e;
              // --accent: #6d6a81;
              colorSchemeSeed: const Color.fromARGB(255, 125, 118, 129),
              fontFamily: 'Fira Code'),
          themeMode: ThemeMode.dark,
          home: Stack(children: [
            DefaultTabController(
              length: pages.length,
              child: Scaffold(
                appBar: q2AppBar(pages.keys, auth.isSignedIn),
                body: q2AppBody(pages.values),
              ),
            ),
            const Positioned(
                child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 14),
                  child: Icon(
                    Icons.signpost,
                    size: 40,
                    shadows: [
                      Shadow(
                          color: Color.fromARGB(143, 255, 255, 255),
                          blurRadius: 10)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, top: 0),
                  child: Text(
                    'qu2s',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      decoration: TextDecoration.none,
                      shadows: [
                        Shadow(
                            color: Color.fromARGB(143, 255, 255, 255),
                            blurRadius: 10)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, top: 18),
                  child: Text(
                    'indev',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            )),
            const Positioned(
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    version,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Fira Code',
                      fontWeight: FontWeight.normal,
                      fontSize: 10,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ))
          ]),
        );
      },
    );
  }

  AppBar q2AppBar(Iterable<String> pages, bool isSignedIn) {
    return AppBar(
      elevation: 5,
      toolbarHeight: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kBottomNavigationBarHeight),
        child: SizedBox(
          width: isSignedIn ? 400 : 200,
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: const Color.fromARGB(100, 255, 255, 255),
            indicatorPadding: const EdgeInsets.only(bottom: 7),
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            tabs: [for (var page in pages) Tab(text: page)],
          ),
        ),
      ),
    );
  }

  TabBarView q2AppBody(Iterable<Widget> pages) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      children: pages.toList(),
    );
  }
}
