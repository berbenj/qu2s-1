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
        final List<Widget> pageNames;
        final List<Widget> pages;
        if (auth.isSignedIn) {
          pageNames = [
            const Tab(text: 'Home'),
            const Tab(text: 'Task'),
            const Tab(text: 'Timeline'),
            const Tab(text: 'Logout'),
          ];
          pages = [
            const HomePage(),
            const TaskPage(),
            const TimelinePage(),
            const LoginPage(),
          ];
        } else {
          pageNames = [
            const Tab(text: 'Home'),
            const Tab(text: 'Login'),
          ];
          pages = [
            const HomePage(),
            const LoginPage(),
          ];
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
          home: DefaultTabController(
            length: pages.length,
            child: Scaffold(
              appBar: q2AppBar(pageNames, auth.isSignedIn),
              body: q2AppBody(pages),
            ),
          ),
        );
      },
    );
  }

  AppBar q2AppBar(List<Widget> pageNames, bool isSignedIn) {
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
            tabs: pageNames,
          ),
        ),
      ),
    );
  }

  TabBarView q2AppBody(List<Widget> pages) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      children: pages,
    );
  }
}
