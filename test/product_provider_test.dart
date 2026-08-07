import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/providers/product_provider.dart';
import 'package:ecommerce_app/services/api_service.dart';

class MockApiService extends ApiService {
  final bool shouldSucceed;
  final List<Product> mockProducts;
  final List<String> mockCategories;
  final String? errorMessage;

  MockApiService({
    this.shouldSucceed = true,
    this.mockProducts = const [],
    this.mockCategories = const ['electronics', 'jewelery'],
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

  @override
  Future<List<String>> getCategories() async {
    if (shouldSucceed) {
      return mockCategories;
    } else {
      throw ApiException(errorMessage ?? 'Failed to load categories.');
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
      expect(provider.categories, ['All']);
      expect(provider.selectedCategory, 'All');
      expect(provider.searchQuery, '');
      expect(provider.isLoading, false);
      expect(provider.hasError, false);
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
      expect(provider.filteredProducts.length, 1);
      expect(provider.products.first.title, 'Backpack');
    });

    test('fetchCategories prepends All to categories list', () async {
      final provider = ProductProvider(
        apiService: MockApiService(
          shouldSucceed: true,
          mockCategories: ['electronics', 'jewelery'],
        ),
      );

      await provider.fetchCategories();

      expect(provider.isCategoriesLoading, false);
      expect(provider.categories, ['All', 'electronics', 'jewelery']);
    });

    test('selectCategory and setSearchQuery filter products correctly', () async {
      final sampleProducts = [
        const Product(
          id: 1,
          title: 'SanDisk 128GB SSD',
          price: 109.0,
          description: 'SSD Storage',
          category: 'electronics',
          image: 'https://fakestoreapi.com/img/ssd.jpg',
          rating: Rating(rate: 4.5, count: 10),
        ),
        const Product(
          id: 2,
          title: 'Gold Ring',
          price: 500.0,
          description: 'Jewelery',
          category: 'jewelery',
          image: 'https://fakestoreapi.com/img/ring.jpg',
          rating: Rating(rate: 4.8, count: 50),
        ),
        const Product(
          id: 3,
          title: 'Samsung Curved Monitor',
          price: 300.0,
          description: 'Monitor',
          category: 'electronics',
          image: 'https://fakestoreapi.com/img/monitor.jpg',
          rating: Rating(rate: 4.2, count: 20),
        ),
      ];

      final provider = ProductProvider(
        apiService: MockApiService(shouldSucceed: true, mockProducts: sampleProducts),
      );

      await provider.fetchProducts();

      // 1. All products initially
      expect(provider.filteredProducts.length, 3);

      // 2. Select category 'electronics'
      provider.selectCategory('electronics');
      expect(provider.filteredProducts.length, 2);
      expect(provider.filteredProducts.every((p) => p.category == 'electronics'), true);

      // 3. Search query 'ssd' within 'electronics'
      provider.setSearchQuery('ssd');
      expect(provider.filteredProducts.length, 1);
      expect(provider.filteredProducts.first.title, 'SanDisk 128GB SSD');

      // 4. Clear search query
      provider.setSearchQuery('');
      expect(provider.filteredProducts.length, 2);

      // 5. Select category 'All'
      provider.selectCategory('All');
      expect(provider.filteredProducts.length, 3);
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
