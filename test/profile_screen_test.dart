import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/providers/auth_provider.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:ecommerce_app/screens/profile/profile_screen.dart';
import 'package:ecommerce_app/utils/app_theme.dart';

class MockUserApiService extends ApiService {
  @override
  Future<UserProfile?> getUserByUsername(String username) async {
    return const UserProfile(
      id: 1,
      email: 'john@gmail.com',
      username: 'johnd',
      firstName: 'john',
      lastName: 'doe',
      phone: '123456789',
      street: '120 Main Street',
      city: 'New York',
      zipcode: '10001',
    );
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'auth_token': 'dummy', 'auth_username': 'johnd'});
  });

  testWidgets('Renders Profile Screen user details and handles Logout', (WidgetTester tester) async {
    final authProvider = AuthProvider(apiService: MockUserApiService());
    final cartProvider = CartProvider(autoLoad: false);
    final userProvider = UserProvider(apiService: MockUserApiService());

    await authProvider.checkAuthStatus();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
          ChangeNotifierProvider<UserProvider>.value(value: userProvider),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ProfileScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Profile Header & Details
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('johnd'), findsOneWidget);
    expect(find.text('john@gmail.com'), findsOneWidget);
    expect(find.text('123456789'), findsOneWidget);

    final logoutButton = find.widgetWithText(ElevatedButton, 'Logout');
    expect(logoutButton, findsOneWidget);

    // Scroll into view and tap Logout button
    await tester.ensureVisible(logoutButton);
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    // Verify User navigated to Login Screen and auth state cleared
    expect(authProvider.isAuthenticated, false);
    expect(userProvider.user, null);
    expect(find.text('Welcome Back'), findsOneWidget);
  });
}
