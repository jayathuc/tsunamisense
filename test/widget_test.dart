// Basic Flutter widget test for TsunamiSense

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:tsunamisense_app/main.dart';
import 'package:tsunamisense_app/providers/earthquake_provider.dart';
import 'package:tsunamisense_app/providers/lesson_provider.dart';
import 'package:tsunamisense_app/providers/checklist_provider.dart';

void main() {
  testWidgets('TsunamiSense app loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TsunamiSenseApp());

    // Wait for the widget to build
    await tester.pumpAndSettle();

    // Verify that the app loads with Home navigation
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Learn'), findsOneWidget);
  });
}
