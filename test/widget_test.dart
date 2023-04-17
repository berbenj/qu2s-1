// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qu2s/main.dart';

void main() {
  testWidgets('app starts up', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    Qu2sApp myApp = const Qu2sApp();
    await tester.pumpWidget(myApp);
    await tester.pump();

    expect(find.byKey(const Key('date_text')), findsOneWidget);
    expect(
        find.byWidgetPredicate(
          (widget) => widget is Text && widget.style?.color == Colors.white,
          description: '`Text` widget with strike through',
        ),
        findsOneWidget);
  });
}
