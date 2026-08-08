# Page 4: State Management & Providers

This page provides an exhaustive guide to the State Management layer (`lib/providers/`).

---

## 1. Overview of Providers

The Providers layer manages reactive state and business logic using Dart’s `ChangeNotifier`.

| Provider | File Path | Main Responsibility | Persistent Storage Key |
| :--- | :--- | :--- | :--- |
| **`AuthProvider`** | [auth_provider.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/providers/auth_provider.dart) | User session token, login & logout logic | `'auth_token'`, `'auth_username'` |
| **`CartProvider`** | [cart_provider.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/providers/cart_provider.dart) | Cart item quantities, total calculation | `'shopping_cart'` |
| **`ProductProvider`** | [product_provider.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/providers/product_provider.dart) | Product catalog, categories, search/filter | None (Memory cached) |
| **`UserProvider`** | [user_provider.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/providers/user_provider.dart) | Profile data for authenticated user | None (Fetched dynamically) |

---

## 2. Exhaustive Provider Analysis

### 2.1 [AuthProvider](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/providers/auth_provider.dart)

Manages session lifecycle, token retrieval, and local user state.

#### State Properties
- `_isLoading` (`bool`): `true` while HTTP login request is active.
- `_isAuthenticated` (`bool`): `true` when a valid token exists.
- `_isInitialized` (`bool`): `true` once startup token check finishes.
- `_token` (`String?`): Stored JWT auth token string.
- `_username` (`String?`): Active logged-in username string.
- `_errorMessage` (`String?`): Error message string on failed login attempts.

#### Core Methods
1. **`checkAuthStatus()`**:
   - Executes on app startup in `AuthWrapper`.
   - Reads `auth_token` and `auth_username` from `SharedPreferences`.
   - Sets `_isAuthenticated = true` if token is non-empty, sets `_isInitialized = true`, and calls `notifyListeners()`.
2. **`login(String username, String password)`**:
   - Sets `_isLoading = true` and notifies listeners.
   - Calls `ApiService.login()`.
   - On success, saves token and username to `SharedPreferences`, sets `_isAuthenticated = true`, and notifies listeners.
   - On failure, catches `ApiException` and sets `_errorMessage`.
3. **`logout()`**:
   - Clears saved token and username from `SharedPreferences`.
   - Clears `shopping_cart` storage key.
   - Resets state variables to null/false and broadcasts update.

---

### 2.2 [CartProvider](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/providers/cart_provider.dart)

Manages shopping cart operations with offline persistence.

#### State Properties
- `_items`: `Map<int, CartItem>` mapping product ID to `CartItem` for $O(1)$ fast lookup and modification.
- `_isLoaded` (`bool`): Flag indicating if persistent cart has finished loading from disk.

#### Calculated Getters
- `int get itemCount`: Sum of all item quantities (`_items.values.fold(0, (sum, item) => sum + item.quantity)`).
- `double calculateTotal()`: Sum of total costs across all items.

#### Persistence Methods
- **`loadCart()`**: Reads `'shopping_cart'` JSON string from `SharedPreferences`, parses items, updates `_items`, and calls `notifyListeners()`.
- **`saveCart()`**: Converts `_items` to JSON array via `item.toJson()` and writes to `SharedPreferences`.
- **`addToCart(Product product)`**: Increments quantity if product exists in `_items`; otherwise inserts new `CartItem`. Saves to disk and calls `notifyListeners()`.
- **`increaseQuantity(int id)` / `decreaseQuantity(int id)`**: Mutates item quantity, removes item if quantity reaches 0, saves, and notifies listeners.

---

### 2.3 [ProductProvider](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/providers/product_provider.dart)

Handles store catalog retrieval, search filtering, and category selection.

#### State Properties
- `_products` (`List<Product>`): Complete catalog fetched from API.
- `_categories` (`List<String>`): Categories list starting with `'All'`.
- `_selectedCategory` (`String`): Currently selected filter category (defaults to `'All'`).
- `_searchQuery` (`String`): Active text query typed in search bar.

#### Dynamic Computed Getter: `filteredProducts`
```dart
List<Product> get filteredProducts {
  return _products.where((product) {
    final matchesCategory = _selectedCategory == 'All' ||
        product.category.trim().toLowerCase() == _selectedCategory.trim().toLowerCase();

    final query = _searchQuery.trim().toLowerCase();
    final matchesSearch = query.isEmpty || product.title.toLowerCase().contains(query);

    return matchesCategory && matchesSearch;
  }).toList();
}
```

#### Core Methods
- **`fetchProducts({bool forceRefresh = false})`**: Calls `ApiService.getProducts()` and caches product list in memory.
- **`fetchCategories({bool forceRefresh = false})`**: Calls `ApiService.getCategories()` and updates `_categories = ['All', ...fetched]`.
- **`selectCategory(String category)`**: Updates `_selectedCategory` and notifies UI.
- **`setSearchQuery(String query)`**: Updates `_searchQuery` string and notifies UI.

---

### 2.4 [UserProvider](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/providers/user_provider.dart)

Manages profile details for the active user.

#### Methods
- **`loadUser(String username)`**: Queries `ApiService.getUserByUsername(username)` and populates `_user` object.
- **`clearUser()`**: Resets profile state during logout.
