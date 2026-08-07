import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService;

  UserProvider({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  UserProfile? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  /// Loads logged-in user profile by username.
  Future<void> loadUser(String username, {bool forceRefresh = false}) async {
    if (_isLoading) return;
    if (_user != null && _user!.username.toLowerCase() == username.toLowerCase() && !forceRefresh) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final loadedUser = await _apiService.getUserByUsername(username);
      if (loadedUser != null) {
        _user = loadedUser;
        _errorMessage = null;
      } else {
        _errorMessage = 'Unable to load profile.';
      }
      _isLoading = false;
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Unable to load profile.';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Resets user profile state upon logout.
  void clearUser() {
    _user = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
