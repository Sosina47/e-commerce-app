import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/providers/user_provider.dart';
import 'package:ecommerce_app/services/api_service.dart';

class MockUserApiService extends ApiService {
  final bool shouldSucceed;
  final UserProfile? mockUser;

  MockUserApiService({
    this.shouldSucceed = true,
    this.mockUser,
  });

  @override
  Future<UserProfile?> getUserByUsername(String username) async {
    if (shouldSucceed) {
      return mockUser ??
          const UserProfile(
            id: 1,
            email: 'john@gmail.com',
            username: 'johnd',
            firstName: 'john',
            lastName: 'doe',
            phone: '123456789',
            street: '120 Main Street',
            city: 'New York',
            zipcode: '10001',
          );
    } else {
      throw ApiException('Unable to load profile.');
    }
  }
}

void main() {
  group('UserProfile Model Tests', () {
    test('UserProfile.fromJson parses JSON correctly', () {
      final json = {
        'id': 1,
        'email': 'john@gmail.com',
        'username': 'johnd',
        'name': {'firstname': 'john', 'lastname': 'doe'},
        'phone': '123456789',
        'address': {
          'number': 120,
          'street': 'Main Street',
          'city': 'New York',
          'zipcode': '10001',
        },
      };

      final user = UserProfile.fromJson(json);

      expect(user.id, 1);
      expect(user.username, 'johnd');
      expect(user.fullName, 'John Doe');
      expect(user.phone, '123456789');
      expect(user.formattedAddress, '120 Main Street\nNew York\n10001');
    });
  });

  group('UserProvider Tests', () {
    test('Initial state is empty', () {
      final provider = UserProvider(apiService: MockUserApiService());
      expect(provider.user, null);
      expect(provider.isLoading, false);
      expect(provider.hasError, false);
    });

    test('loadUser populates user profile on success', () async {
      final provider = UserProvider(apiService: MockUserApiService(shouldSucceed: true));
      await provider.loadUser('johnd');

      expect(provider.isLoading, false);
      expect(provider.hasError, false);
      expect(provider.user, isNotNull);
      expect(provider.user!.username, 'johnd');
      expect(provider.user!.fullName, 'John Doe');
    });

    test('loadUser sets error message on failure', () async {
      final provider = UserProvider(apiService: MockUserApiService(shouldSucceed: false));
      await provider.loadUser('johnd');

      expect(provider.isLoading, false);
      expect(provider.hasError, true);
      expect(provider.errorMessage, 'Unable to load profile.');
      expect(provider.user, null);
    });

    test('clearUser resets provider state', () async {
      final provider = UserProvider(apiService: MockUserApiService(shouldSucceed: true));
      await provider.loadUser('johnd');
      expect(provider.user, isNotNull);

      provider.clearUser();
      expect(provider.user, null);
      expect(provider.hasError, false);
    });
  });
}
