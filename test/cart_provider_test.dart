import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  const sampleProduct1 = Product(
    id: 1,
    title: 'Fjallraven Backpack',
    price: 100.0,
    description: 'Nice bag',
    category: 'men\'s clothing',
    image: 'https://fakestoreapi.com/img/sample.jpg',
    rating: Rating(rate: 4.5, count: 10),
  );

  const sampleProduct2 = Product(
    id: 2,
    title: 'Mens Casual T-Shirt',
    price: 50.0,
    description: 'Cool shirt',
    category: 'men\'s clothing',
    image: 'https://fakestoreapi.com/img/sample2.jpg',
    rating: Rating(rate: 4.0, count: 20),
  );

  group('CartProvider Tests', () {
    test('Initial cart state is empty', () {
      final cart = CartProvider();
      expect(cart.items, isEmpty);
      expect(cart.itemCount, 0);
      expect(cart.calculateTotal(), 0.0);
    });

    test('addToCart adds new item and increments quantity on duplicate add', () {
      final cart = CartProvider();

      cart.addToCart(sampleProduct1);
      expect(cart.cartItems.length, 1);
      expect(cart.itemCount, 1);
      expect(cart.calculateTotal(), 100.0);

      // Add same product again
      cart.addToCart(sampleProduct1);
      expect(cart.cartItems.length, 1);
      expect(cart.itemCount, 2);
      expect(cart.calculateTotal(), 200.0);
    });

    test('increaseQuantity and decreaseQuantity modify item quantity', () {
      final cart = CartProvider();

      cart.addToCart(sampleProduct1);
      cart.increaseQuantity(sampleProduct1.id);
      expect(cart.itemCount, 2);
      expect(cart.calculateTotal(), 200.0);

      cart.decreaseQuantity(sampleProduct1.id);
      expect(cart.itemCount, 1);
      expect(cart.calculateTotal(), 100.0);

      // Decrease when quantity is 1 removes item
      cart.decreaseQuantity(sampleProduct1.id);
      expect(cart.items, isEmpty);
      expect(cart.itemCount, 0);
      expect(cart.calculateTotal(), 0.0);
    });

    test('removeItem removes product from cart', () {
      final cart = CartProvider();

      cart.addToCart(sampleProduct1);
      cart.addToCart(sampleProduct2);
      expect(cart.cartItems.length, 2);
      expect(cart.calculateTotal(), 150.0);

      cart.removeItem(sampleProduct1.id);
      expect(cart.cartItems.length, 1);
      expect(cart.cartItems.first.product.id, sampleProduct2.id);
      expect(cart.calculateTotal(), 50.0);
    });

    test('saveCart and loadCart persist cart state across app restarts', () async {
      final cart1 = CartProvider();
      cart1.addToCart(sampleProduct1);
      cart1.addToCart(sampleProduct1); // quantity 2
      cart1.addToCart(sampleProduct2); // quantity 1

      await cart1.saveCart();

      final cart2 = CartProvider();
      await cart2.loadCart();

      expect(cart2.cartItems.length, 2);
      expect(cart2.itemCount, 3);
      expect(cart2.calculateTotal(), 250.0);
    });

    test('clearSavedCart removes cart from SharedPreferences and resets memory state', () async {
      final cart = CartProvider();
      cart.addToCart(sampleProduct1);
      await cart.clearSavedCart();

      expect(cart.items, isEmpty);

      final reloadedCart = CartProvider();
      await reloadedCart.loadCart();
      expect(reloadedCart.items, isEmpty);
    });
  });
}
