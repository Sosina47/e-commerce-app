# Page 3: Models & Services Layer

This page provides a file-by-file breakdown of the Data Transfer Models (`lib/models/`) and Network Communication Services (`lib/services/`).

---

## 1. Models Layer (`lib/models/`)

The Models layer defines the structured data schemas used throughout the app. All model classes feature defensive JSON parsing constructors (`fromJson`) and map exporters (`toJson`).

### 1.1 [product.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/models/product.dart)

Contains the data classes representing items in the e-commerce store catalog.

#### `Rating` Class
```dart
class Rating {
  final double rate;
  final int count;
  ...
}
```
- **Fields**:
  - `rate` (`double`): Average customer review rating (e.g. `4.5`).
  - `count` (`int`): Total count of customer reviews.
- **Methods**:
  - `Rating.fromJson(dynamic json)`: Safely casts `rate` using `(map['rate'] as num?)?.toDouble() ?? 0.0` and `count` using `(map['count'] as num?)?.toInt() ?? 0`.
  - `toJson()`: Converts rating object into `Map<String, dynamic>`.

#### `Product` Class
```dart
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;
  ...
}
```
- **Fields**:
  - `id` (`int`): Unique product identifier.
  - `title` (`String`): Product name.
  - `price` (`double`): Cost in USD.
  - `description` (`String`): Detailed product description text.
  - `category` (`String`): Product category string (e.g., `"electronics"`, `"jewelery"`).
  - `image` (`String`): Remote HTTP URL pointing to product image.
  - `rating` (`Rating`): Nested `Rating` object instance.
- **Defensive Design**: If API response contains null or unexpected types, `Product.fromJson()` supplies fallback default values to ensure the app never crashes on missing JSON fields.

---

### 1.2 [cart_item.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/models/cart_item.dart)

Represents an individual product entry inside the user's shopping cart.

```dart
class CartItem {
  final Product product;
  int quantity;
  ...
}
```
- **Fields**:
  - `product` (`Product`): The associated store product.
  - `quantity` (`int`): Quantity ordered (defaults to `1`).
- **Computed Getters**:
  - `double get totalPrice => product.price * quantity;`
- **Serialization**: `toJson()` and `fromJson()` enable serializing cart state into JSON strings for local disk caching in `SharedPreferences`.

---

### 1.3 [user.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/models/user.dart)

Represents user profile information retrieved from `GET /users`.

```dart
class UserProfile {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;
  final String street;
  final String city;
  final String zipcode;
  ...
}
```
- **Nested JSON Parsing**: Fake Store API returns nested structures:
  - `name`: `{ "firstname": "john", "lastname": "doe" }`
  - `address`: `{ "city": "kilkenny", "street": "7835 new rd", "zipcode": "12926-3874" }`
- **Helper Getters**:
  - `String get fullName`: Combines capitalized `firstName` and `lastName` with fallback to `username`.
  - `String get formattedAddress`: Joins street, city, and zipcode into formatted multi-line address text.

---

## 2. Services Layer (`lib/services/`)

The Services layer encapsulates all external REST API interaction with `https://fakestoreapi.com`.

### 2.1 [api_service.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/services/api_service.dart)

#### `ApiException` Class
Custom exception class thrown whenever network operations fail:
```dart
class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}
```

#### `ApiService` Class Methods
- **`login({required String username, required String password})`**:
  - Endpoint: `POST https://fakestoreapi.com/auth/login`
  - Body: `{"username": "...", "password": "..."}`
  - Returns authentication token string on HTTP `200`/`201`.
  - Throws user-friendly `ApiException('Invalid username or password.')` on HTTP `400`/`401`.

- **`getProducts()`**:
  - Endpoint: `GET https://fakestoreapi.com/products`
  - Returns `List<Product>`.

- **`getCategories()`**:
  - Endpoint: `GET https://fakestoreapi.com/products/categories`
  - Returns list of category strings (`List<String>`).

- **`getProductsByCategory(String category)`**:
  - Endpoint: `GET https://fakestoreapi.com/products/category/{category}`
  - Uses `Uri.encodeComponent(category)` to safely format URI strings.

- **`getUsers()` & `getUserByUsername(String username)`**:
  - Endpoint: `GET https://fakestoreapi.com/users`
  - Fetches users and finds the matching profile by username.

- **Robust Network Error Handling**: All HTTP requests are set with a 15-second timeout (`.timeout(const Duration(seconds: 15))`) and handle:
  - `SocketException`: Internet connectivity unavailable.
  - `http.ClientException`: HTTP socket connection failure.
  - `FormatException`: Corrupted JSON payload.
