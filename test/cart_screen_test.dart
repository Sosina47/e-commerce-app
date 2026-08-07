import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/screens/cart/cart_screen.dart';
import 'package:ecommerce_app/utils/app_theme.dart';

void main() {
  const sampleProduct = Product(
    id: 1,
    title: 'Fjallraven Backpack',
    price: 100.0,
    description: 'Durable backpack',
    category: 'electronics',
    image: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
    rating: Rating(rate: 4.5, count: 10),
  );

  testWidgets('Renders empty cart state when cart has no items', (WidgetTester tester) async {
    final cartProvider = CartProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<CartProvider>.value(
        value: cartProvider,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const CartScreen(),
        ),
      ),
    );

    expect(find.text('Your cart is empty.'), findsOneWidget);
    expect(find.text('Start shopping.'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
  });

  testWidgets('Renders cart item, handles quantity controls, total calculation, and Checkout SnackBar',
      (WidgetTester tester) async {
    final cartProvider = CartProvider();
    cartProvider.addToCart(sampleProduct);

    await tester.pumpWidget(
      ChangeNotifierProvider<CartProvider>.value(
        value: cartProvider,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const CartScreen(),
        ),
      ),
    );

    // Verify product information and total
    expect(find.text('Fjallraven Backpack'), findsOneWidget);
    expect(find.text('\$100.00'), findsNWidgets(2)); // Unit price & Total
    expect(find.text('1'), findsOneWidget); // Quantity

    // Tap '+' icon to increase quantity
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('2'), findsOneWidget);
    expect(find.text('\$200.00'), findsOneWidget);

    // Tap '-' icon to decrease quantity
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
    expect(find.text('\$100.00'), findsNWidgets(2));

    // Tap Checkout button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Checkout'));
    await tester.pump();

    expect(find.text('Checkout coming soon.'), findsOneWidget);

    // Remove item
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.text('Your cart is empty.'), findsOneWidget);
  });
}
