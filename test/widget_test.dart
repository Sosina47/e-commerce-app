import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/widgets/category_chip.dart';
import 'package:ecommerce_app/widgets/product_card.dart';

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

  testWidgets('Renders Home Screen UI components when authenticated', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'auth_token': 'test_token',
      'auth_username': 'mor_2314',
    });

    await tester.pumpWidget(const EcommerceApp());
    await tester.pumpAndSettle();

    // Verify App Bar
    expect(find.text('Fake Store'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsAtLeast(1));
    expect(find.byIcon(Icons.person_outline), findsAtLeast(1));

    // Verify Search Bar
    expect(find.byType(TextField), findsOneWidget);

    // Verify Category Chips
    expect(find.byType(CategoryChip), findsAtLeast(3));
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Electronics'), findsOneWidget);

    // Verify Product Cards Grid
    expect(find.byType(ProductCard), findsAtLeast(2));

    // Verify Bottom Navigation Bar
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
