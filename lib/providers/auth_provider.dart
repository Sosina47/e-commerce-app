import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;

  AuthProvider({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  static const String _keyToken = 'auth_token';
  static const String _keyUsername = 'auth_username';

  bool _isLoading = false;
  bool _isAuthenticated = false;
  bool _isInitialized = false;
  String? _token;
  String? _username;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  bool get isInitialized => _isInitialized;
  String? get token => _token;
  String? get username => _username;
  String? get errorMessage => _errorMessage;

  /// Checks local storage on application startup to verify if token exists
  Future<void> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString(_keyToken);
      _username = prefs.getString(_keyUsername);

      if (_token != null && _token!.isNotEmpty) {
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
      }
    } catch (e) {
      _isAuthenticated = false;
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Authenticates user with [username] and [password].
  /// Returns `true` if login succeeds, `false` otherwise.
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _apiService.login(
        username: username.trim(),
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyToken, token);
      await prefs.setString(_keyUsername, username.trim());

      _token = token;
      _username = username.trim();
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logs out the user, clears stored tokens, and resets authentication state
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyToken);
      await prefs.remove(_keyUsername);
    } catch (_) {}

    _token = null;
    _username = null;
    _isAuthenticated = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Clears error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
