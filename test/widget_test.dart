import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/main.dart';

void main() {
  testWidgets('App smoke test - renders Login Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EcommerceApp());

    // Verify that the login screen title appears.
    expect(find.text('FakeStore E-Commerce'), findsOneWidget);
    expect(find.text('Login (Placeholder)'), findsOneWidget);
  });
}
