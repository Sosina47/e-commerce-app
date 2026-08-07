import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_app/providers/auth_provider.dart';
import 'package:ecommerce_app/services/api_service.dart';

class MockApiService extends ApiService {
  final bool shouldSucceed;
  final String mockToken;
  final String? errorMessage;

  MockApiService({
    this.shouldSucceed = true,
    this.mockToken = 'fake_jwt_token_12345',
    this.errorMessage,
  });

  @override
  Future<String> login({required String username, required String password}) async {
    if (shouldSucceed) {
      return mockToken;
    } else {
      throw ApiException(errorMessage ?? 'Invalid username or password.');
    }
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AuthProvider Tests', () {
    test('Initial state is unauthenticated and uninitialized', () {
      final provider = AuthProvider(apiService: MockApiService());
      expect(provider.isAuthenticated, false);
      expect(provider.isInitialized, false);
      expect(provider.isLoading, false);
      expect(provider.token, null);
    });

    test('checkAuthStatus initializes state and detects stored token', () async {
      SharedPreferences.setMockInitialValues({
        'auth_token': 'existing_saved_token',
        'auth_username': 'mor_2314',
      });

      final provider = AuthProvider(apiService: MockApiService());
      await provider.checkAuthStatus();

      expect(provider.isInitialized, true);
      expect(provider.isAuthenticated, true);
      expect(provider.token, 'existing_saved_token');
      expect(provider.username, 'mor_2314');
    });

    test('Successful login updates state and persists token in SharedPreferences', () async {
      final provider = AuthProvider(
        apiService: MockApiService(shouldSucceed: true, mockToken: 'test_jwt_777'),
      );

      final success = await provider.login('mor_2314', '83r5^_');

      expect(success, true);
      expect(provider.isAuthenticated, true);
      expect(provider.token, 'test_jwt_777');
      expect(provider.username, 'mor_2314');
      expect(provider.errorMessage, null);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('auth_token'), 'test_jwt_777');
      expect(prefs.getString('auth_username'), 'mor_2314');
    });

    test('Failed login sets error message and leaves user unauthenticated', () async {
      final provider = AuthProvider(
        apiService: MockApiService(shouldSucceed: false, errorMessage: 'Invalid username or password.'),
      );

      final success = await provider.login('wrong_user', 'bad_password');

      expect(success, false);
      expect(provider.isAuthenticated, false);
      expect(provider.token, null);
      expect(provider.errorMessage, 'Invalid username or password.');
    });

    test('Logout clears state and SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'auth_token': 'saved_token',
        'auth_username': 'mor_2314',
      });

      final provider = AuthProvider(apiService: MockApiService());
      await provider.checkAuthStatus();
      expect(provider.isAuthenticated, true);

      await provider.logout();

      expect(provider.isAuthenticated, false);
      expect(provider.token, null);
      expect(provider.username, null);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('auth_token'), null);
    });
  });
}
