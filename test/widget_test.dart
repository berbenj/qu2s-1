import 'package:flutter_test/flutter_test.dart';

import 'package:qu2s/main.dart';
import 'package:qu2s/q2_platform.dart';

void main() {
  group('Windows', () {
    q2Platform = Q2Platform(forcePlatform: 'Windows');
    connectToDatabase();

    testWidgets('app starts up', (WidgetTester tester) async {
      await tester.pumpWidget(const Qu2sApp());
    });
    testWidgets('Home page accessable', (WidgetTester tester) async {
      await tester.pumpWidget(const Qu2sApp());
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
    });
    testWidgets('Calendar page accessable', (WidgetTester tester) async {
      await tester.pumpWidget(const Qu2sApp());
      await tester.tap(find.text('Calendar'));
      await tester.pumpAndSettle();
    });
  });

  group('Web', () {
    q2Platform = Q2Platform(forcePlatform: 'Web');
    connectToDatabase();

    testWidgets('app starts up', (WidgetTester tester) async {
      await tester.pumpWidget(const Qu2sApp());
    });
    testWidgets('Home page accessable', (WidgetTester tester) async {
      await tester.pumpWidget(const Qu2sApp());
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
    });
    testWidgets('Calendar page accessable', (WidgetTester tester) async {
      await tester.pumpWidget(const Qu2sApp());
      await tester.tap(find.text('Calendar'));
      await tester.pumpAndSettle();
    });
  });

  // todo: test in browser and android
  // todo: test database connection
}
