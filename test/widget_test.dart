// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cnoder/widget/topics.dart';
import 'package:cnoder/store/view_model/topics.dart';
import 'package:cnoder/store/root_state.dart';

void main() {
  testWidgets('index scene test', (WidgetTester tester) async {
    final binding = tester.binding as AutomatedTestWidgetsFlutterBinding;
    binding.addTime(const Duration(seconds: 13));

    final rootState = new RootState();
    final vm = new TopicsViewModel(
      topicsOfCategory: rootState.topicsOfCategory,
      isLoading: true,
      resetTopics: null,
      fetchTopics: null
    );
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MaterialApp(home: TopicsScene(vm: vm)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
