import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(dynamic json) {
    if (json is Map) {
      final map = Map<String, dynamic>.from(json);
      return CartItem(
        product: Product.fromJson(map['product']),
        quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      );
    }
    return CartItem(
      product: const Product(
        id: 0,
        title: '',
        price: 0.0,
        description: '',
        category: '',
        image: '',
        rating: Rating(rate: 0.0, count: 0),
      ),
      quantity: 1,
    );
  }
}
