import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/auth_provider.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/services/api_service.dart';
import 'package:ecommerce_app/screens/home/home_screen.dart';
import 'package:ecommerce_app/screens/login/login_screen.dart';
import 'package:ecommerce_app/widgets/product_card.dart';

import 'package:ecommerce_app/utils/app_theme.dart';

class MockApiService extends ApiService {
  @override
  Future<List<Product>> getProducts() async {
    return const [
      Product(
        id: 1,
        title: 'Fjallraven Backpack',
        price: 99.99,
        description: 'Nice bag with great durability',
        category: 'electronics',
        image: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
        rating: Rating(rate: 3.9, count: 120),
      ),
      Product(
        id: 2,
        title: 'Mens Casual T-Shirt',
        price: 22.30,
        description: 'Cool t-shirt',
        category: 'men\'s clothing',
        image: 'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg',
        rating: Rating(rate: 4.1, count: 259),
      ),
    ];
  }

  @override
  Future<List<String>> getCategories() async {
    return const ['electronics', 'jewelery', 'men\'s clothing', 'women\'s clothing'];
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Renders Login Screen elements when unauthenticated', (WidgetTester tester) async {
    final authProvider = AuthProvider();
    final productProvider = ProductProvider(apiService: MockApiService());
    final cartProvider = CartProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ChangeNotifierProvider<ProductProvider>.value(value: productProvider),
          ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const LoginScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Welcome text
    expect(find.text('Fake Store'), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);

    // Verify Username & Password input fields
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });

  testWidgets('Triggers empty form validation on Login press', (WidgetTester tester) async {
    final authProvider = AuthProvider();
    final productProvider = ProductProvider(apiService: MockApiService());
    final cartProvider = CartProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ChangeNotifierProvider<ProductProvider>.value(value: productProvider),
          ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const LoginScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap Login button with empty fields
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    // Verify validation messages appear
    expect(find.text('Please enter your username'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Navigates to Product Details Screen and adds item to cart', (WidgetTester tester) async {
    final productProvider = ProductProvider(apiService: MockApiService());
    final cartProvider = CartProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider<ProductProvider>.value(value: productProvider),
          ChangeNotifierProvider<CartProvider>.value(value: cartProvider),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const HomeScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Product Cards Grid
    expect(find.byType(ProductCard), findsNWidgets(2));

    // Tap on the first product card ('Fjallraven Backpack')
    await tester.tap(find.text('Fjallraven Backpack'));
    await tester.pumpAndSettle();

    // Verify Product Details Screen is opened
    expect(find.text('Product Details'), findsOneWidget);
    expect(find.text('Nice bag with great durability'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Add To Cart'), findsOneWidget);

    // Tap 'Add To Cart' button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add To Cart'));
    await tester.pump();

    // Verify SnackBar appears and item added to cartProvider
    expect(find.text('Added to cart successfully.'), findsOneWidget);
    expect(cartProvider.itemCount, 1);
  });
}
