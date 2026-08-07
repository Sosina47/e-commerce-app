import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  static const String _keyCart = 'shopping_cart';
  final Map<int, CartItem> _items = {};
  bool _isLoaded = false;

  CartProvider({bool autoLoad = true}) {
    if (autoLoad) {
      loadCart();
    }
  }

  Map<int, CartItem> get items => Map.unmodifiable(_items);

  List<CartItem> get cartItems => _items.values.toList();

  bool get isLoaded => _isLoaded;

  int get itemCount {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  int get totalItems => itemCount;

  double calculateTotal() {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Loads cart items from SharedPreferences on app launch.
  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString(_keyCart);

      if (cartString != null && cartString.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(cartString);
        _items.clear();
        for (final itemJson in decodedList) {
          if (itemJson != null) {
            final item = CartItem.fromJson(itemJson);
            if (item.product.id > 0) {
              _items[item.product.id] = item;
            }
          }
        }
      }
    } catch (e) {
      // In case of error/corrupted JSON, fallback to empty cart without crashing
      _items.clear();
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  /// Saves current cart state to SharedPreferences under 'shopping_cart'.
  Future<void> saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> cartJson =
          _items.values.map((item) => item.toJson()).toList();
      await prefs.setString(_keyCart, jsonEncode(cartJson));
    } catch (_) {}
  }

  /// Clears in-memory cart and removes saved cart from SharedPreferences.
  Future<void> clearSavedCart() async {
    _items.clear();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyCart);
    } catch (_) {}
    notifyListeners();
  }

  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItem(product: product, quantity: 1);
    }
    saveCart();
    notifyListeners();
  }

  void removeItem(int productId) {
    if (_items.containsKey(productId)) {
      _items.remove(productId);
      saveCart();
      notifyListeners();
    }
  }

  void increaseQuantity(int productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity += 1;
      saveCart();
      notifyListeners();
    }
  }

  void decreaseQuantity(int productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      _items.remove(productId);
    }
    saveCart();
    notifyListeners();
  }

  void clearCart() {
    clearSavedCart();
  }
}
