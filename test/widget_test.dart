// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qu2s/main.dart';

void main() {
  testWidgets('app starts up', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // expect(find.text('0'), findsOneWidget);
  });

  test('homePageState', () {
    TestHomePageState testHomePageState = TestHomePageState();

    assert(testHomePageState.isLeapYearTest(2020) == true);
    assert(testHomePageState.isLeapYearTest(2021) == false);
    assert(testHomePageState.isLeapYearTest(2022) == false);
    assert(testHomePageState.isLeapYearTest(2023) == false);
    assert(testHomePageState.isLeapYearTest(2024) == true);
    assert(testHomePageState.isLeapYearTest(2100) == false);
    assert(testHomePageState.isLeapYearTest(2000) == true);
    assert(testHomePageState.isLeapYearTest(2) == false);
  });
}
