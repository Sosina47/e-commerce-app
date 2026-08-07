import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/user.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';

  /// Authenticates user with [username] and [password].
  /// Returns authentication token string on success.
  /// Throws [ApiException] with user-friendly error message on failure.
  Future<String> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final token = data['token'];
        if (token != null && token is String && token.isNotEmpty) {
          return token;
        } else {
          throw ApiException('Invalid response format from server.');
        }
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        throw ApiException('Invalid username or password.');
      } else {
        throw ApiException('Server error (${response.statusCode}). Please try again later.');
      }
    } on SocketException {
      throw ApiException('Network error. Please check your internet connection.');
    } on http.ClientException {
      throw ApiException('Network connection failed. Please try again.');
    } on FormatException {
      throw ApiException('Invalid server response format.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// Fetches all products from Fake Store API.
  /// Returns a list of [Product] items.
  /// Throws [ApiException] on network, HTTP, or parsing failure.
  Future<List<Product>> getProducts() async {
    final url = Uri.parse('$baseUrl/products');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ApiException('Failed to load products from server (${response.statusCode}).');
      }
    } on SocketException {
      throw ApiException('Network error. Please check your internet connection.');
    } on http.ClientException {
      throw ApiException('Network connection failed. Please try again.');
    } on FormatException {
      throw ApiException('Failed to process products data format.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('An error occurred while fetching products: ${e.toString()}');
    }
  }

  /// Fetches categories list from Fake Store API.
  /// Returns a list of category strings.
  Future<List<String>> getCategories() async {
    final url = Uri.parse('$baseUrl/products/categories');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item.toString()).toList();
      } else {
        throw ApiException('Failed to load categories (${response.statusCode}).');
      }
    } on SocketException {
      throw ApiException('Network error. Unable to load categories.');
    } on http.ClientException {
      throw ApiException('Network connection failed.');
    } on FormatException {
      throw ApiException('Failed to process categories data format.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('An error occurred while fetching categories: ${e.toString()}');
    }
  }

  /// Fetches products belonging to a specific category from Fake Store API.
  Future<List<Product>> getProductsByCategory(String category) async {
    final encodedCategory = Uri.encodeComponent(category);
    final url = Uri.parse('$baseUrl/products/category/$encodedCategory');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ApiException('Failed to load category products (${response.statusCode}).');
      }
    } on SocketException {
      throw ApiException('Network error. Unable to load category products.');
    } on http.ClientException {
      throw ApiException('Network connection failed.');
    } on FormatException {
      throw ApiException('Failed to process data format.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('An error occurred while fetching category products: ${e.toString()}');
    }
  }

  /// Fetches all users from Fake Store API (`GET /users`).
  Future<List<UserProfile>> getUsers() async {
    final url = Uri.parse('$baseUrl/users');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => UserProfile.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to load users (${response.statusCode}).');
      }
    } on SocketException {
      throw ApiException('Network error. Unable to load profile data.');
    } on http.ClientException {
      throw ApiException('Network connection failed.');
    } on FormatException {
      throw ApiException('Failed to process users data format.');
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('An error occurred while fetching users: ${e.toString()}');
    }
  }

  /// Locates user by matching username against users list returned by API.
  Future<UserProfile?> getUserByUsername(String username) async {
    final users = await getUsers();
    final target = username.trim().toLowerCase();
    for (final u in users) {
      if (u.username.toLowerCase() == target) {
        return u;
      }
    }
    return null;
  }
}
