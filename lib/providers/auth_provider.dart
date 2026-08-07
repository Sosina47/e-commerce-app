import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void loginPlaceholder() {
    _isAuthenticated = true;
    notifyListeners();
  }

  void logoutPlaceholder() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
