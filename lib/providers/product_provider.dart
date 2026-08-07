import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService;

  ProductProvider({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  List<Product> _products = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  bool _isLoading = false;
  String? _errorMessage;

  bool _isCategoriesLoading = false;
  String? _categoriesError;

  List<Product> get products => List.unmodifiable(_products);
  List<String> get categories => List.unmodifiable(_categories);
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  bool get isCategoriesLoading => _isCategoriesLoading;
  String? get categoriesError => _categoriesError;
  bool get hasCategoriesError => _categoriesError != null;

  /// Filtered products computed from [selectedCategory] and [searchQuery]
  List<Product> get filteredProducts {
    return _products.where((product) {
      // Category filter
      final matchesCategory = _selectedCategory == 'All' ||
          product.category.trim().toLowerCase() == _selectedCategory.trim().toLowerCase();

      // Search query filter against product.title
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty || product.title.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  bool get isFilteredEmpty =>
      !_isLoading && _errorMessage == null && filteredProducts.isEmpty;

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

  /// Fetches categories list from Fake Store API.
  Future<void> fetchCategories({bool forceRefresh = false}) async {
    if (_isCategoriesLoading) return;
    if (_categories.length > 1 && !forceRefresh) return;

    _isCategoriesLoading = true;
    _categoriesError = null;
    notifyListeners();

    try {
      final fetchedCategories = await _apiService.getCategories();
      _categories = ['All', ...fetchedCategories];
      _isCategoriesLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _categoriesError = e.message;
      _isCategoriesLoading = false;
      notifyListeners();
    } catch (e) {
      _categoriesError = 'Unable to load categories. Tap to Retry';
      _isCategoriesLoading = false;
      notifyListeners();
    }
  }

  /// Updates selected category filter
  void selectCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    notifyListeners();
  }

  /// Updates search query string
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
