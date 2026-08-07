import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService;

  ProductProvider({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => !_isLoading && _errorMessage == null && _products.isEmpty;

  /// Fetches products from Fake Store API.
  Future<void> fetchProducts({bool forceRefresh = false}) async {
    if (_isLoading) return;
    if (_products.isNotEmpty && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedProducts = await _apiService.getProducts();
      _products = fetchedProducts;
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Something went wrong. Tap to Retry';
      _isLoading = false;
      notifyListeners();
    }
  }
}
