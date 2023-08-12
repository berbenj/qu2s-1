import 'dart:io';

import 'package:firedart/auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'q2_platform.dart';

import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/task.dart';
import 'pages/timeline.dart';

Q2Platform q2Platform = Q2Platform();

const String version = 'v0.0.0::06';

void main() {
  connectToDatabase();
  runApp(const Qu2sApp());
}

void connectToDatabase() async {
  if (q2Platform.isWeb) {
    FirebaseAuth.initialize('AIzaSyCFfMcpev4TWt3yst8pNID9Qicu6vX8Q9E', fd.VolatileStore());
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } else if (q2Platform.isWindows) {
    fd.FirebaseAuth.initialize('AIzaSyCFfMcpev4TWt3yst8pNID9Qicu6vX8Q9E', fd.VolatileStore());
    fd.Firestore.initialize('qu2s-e9232');
  } else {
    // todo: implement for android
  }

  final auth = fd.FirebaseAuth.instance;

  await auth.signIn('dev@qu2s.com', 'bravebluequantumduck');
}

class Qu2sApp extends StatelessWidget {
  const Qu2sApp({super.key});

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
              colorSchemeSeed: const Color.fromARGB(255, 0, 26, 255),
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
                )),
            Positioned(top: -78, child: IgnorePointer(child: Image.asset('img/logo.png', scale: 5))),
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
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
