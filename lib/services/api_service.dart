import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';

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
}
