import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/services/api_service.dart';

class MockApiService extends ApiService {
  final bool shouldSucceed;
  final List<Product> mockProducts;
  final String? errorMessage;

  MockApiService({
    this.shouldSucceed = true,
    this.mockProducts = const [],
    this.errorMessage,
  });

  @override
  Future<List<Product>> getProducts() async {
    if (shouldSucceed) {
      return mockProducts;
    } else {
      throw ApiException(errorMessage ?? 'Failed to load products.');
    }
  }
}

void main() {
  group('Product Model Tests', () {
    test('Product.fromJson parses valid JSON correctly', () {
      final json = {
        'id': 1,
        'title': 'Test Product',
        'price': 109.95,
        'description': 'Product description',
        'category': 'electronics',
        'image': 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
        'rating': {'rate': 3.9, 'count': 120},
      };

      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.title, 'Test Product');
      expect(product.price, 109.95);
      expect(product.rating.rate, 3.9);
      expect(product.rating.count, 120);
    });
  });

  group('ProductProvider Tests', () {
    test('Initial state is empty, not loading, no error', () {
      final provider = ProductProvider(apiService: MockApiService());
      expect(provider.products, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.hasError, false);
      expect(provider.errorMessage, null);
    });

    test('fetchProducts populates products list on success', () async {
      final sampleProducts = [
        const Product(
          id: 1,
          title: 'Backpack',
          price: 99.99,
          description: 'A nice backpack',
          category: 'men\'s clothing',
          image: 'https://fakestoreapi.com/img/sample.jpg',
          rating: Rating(rate: 4.5, count: 10),
        ),
      ];

      final provider = ProductProvider(
        apiService: MockApiService(shouldSucceed: true, mockProducts: sampleProducts),
      );

      await provider.fetchProducts();

      expect(provider.isLoading, false);
      expect(provider.hasError, false);
      expect(provider.products.length, 1);
      expect(provider.products.first.title, 'Backpack');
    });

    test('fetchProducts sets errorMessage on API failure', () async {
      final provider = ProductProvider(
        apiService: MockApiService(shouldSucceed: false, errorMessage: 'Network error.'),
      );

      await provider.fetchProducts();

      expect(provider.isLoading, false);
      expect(provider.hasError, true);
      expect(provider.errorMessage, 'Network error.');
      expect(provider.products, isEmpty);
    });
  });
}
