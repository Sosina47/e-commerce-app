import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Renders Login Screen elements when unauthenticated', (WidgetTester tester) async {
    await tester.pumpWidget(const EcommerceApp());
    await tester.pumpAndSettle();

    // Verify Title & Welcome text
    expect(find.text('Fake Store'), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);

    // Verify Username & Password input fields
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });

  testWidgets('Triggers empty form validation on Login press', (WidgetTester tester) async {
    await tester.pumpWidget(const EcommerceApp());
    await tester.pumpAndSettle();

    // Tap Login button with empty fields
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    // Verify validation messages appear
    expect(find.text('Please enter your username'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });
}
