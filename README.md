# Fake Store E-Commerce App 🛒

A modern, responsive, full-featured Flutter e-commerce application built with **Provider Architecture**, state management, local data persistence using `SharedPreferences`, and real-time network integration with the [Fake Store API](https://fakestoreapi.com/).

---

## 🌟 Key Features

- **🔐 User Authentication & Session Persistence**:
  - Secure login using Fake Store API (`POST https://fakestoreapi.com/auth/login`).
  - Automatic session restoration on app startup via local token storage.

- **🛍️ Dynamic Product Catalog**:
  - Fetches and displays products from `GET https://fakestoreapi.com/products`.
  - Responsive product grid with automatic column scaling for mobile, tablet, and web viewports.
  - Image loading placeholders and fallback error handling.

- **🏷️ Category Filtering & Title Search**:
  - Live category list fetched from `GET https://fakestoreapi.com/products/categories`.
  - Real-time product search by title with clear button functionality.

- **📖 Product Details View**:
  - Full product view with aspect-ratio image scaling, rating badge (`⭐ 4.2 / 5`), price, category badge, and complete scrollable description.
  - One-tap "Add to Cart" action with interactive feedback toast.

- **🛒 Shopping Cart & Local Persistence**:
  - Quantity controls (`[-]` / `[+]`), item removal, and total price calculation.
  - **Cart Persistence**: Automatically saves cart items as JSON in `SharedPreferences` (`shopping_cart`) and restores state across app restarts.

- **👤 User Profile & Logout**:
  - Fetches user profile from `GET https://fakestoreapi.com/users` matching the authenticated username.
  - Displays user avatar, full name, email, phone number, and mailing address.
  - Complete **Logout flow**: clears token, clears cart storage, resets state, and returns to the Login screen with route stack clearing.

- **🎨 States & Responsiveness**:
  - Consistent Loading (`LoadingWidget`), Empty (`EmptyStateWidget`), and Connection Error (`AppErrorWidget` with Retry) feedback across all screens.

---

## 🏗️ Project Architecture & Structure

The project follows a clean, modular layer structure separating models, network services, state providers, screens, and UI widgets.

```text
lib/
├── models/             # Data models (Product, Rating, CartItem, UserProfile) with fromJson/toJson
├── providers/          # State management (AuthProvider, ProductProvider, CartProvider, UserProvider)
├── services/           # HTTP API client (ApiService with HTTP error handling)
├── screens/            # Screen views (LoginScreen, HomeScreen, ProductDetailsScreen, CartScreen, ProfileScreen)
├── widgets/            # Reusable UI widgets (ProductCard, CategoryChip, LoadingWidget, AppErrorWidget, EmptyStateWidget)
├── utils/              # Application theme (AppTheme design system)
└── main.dart           # Application entrypoint & AuthWrapper
```

---

## 🌐 API Integration Summary

| Feature | Method | Endpoint | Description |
|---|---|---|---|
| Login | `POST` | `https://fakestoreapi.com/auth/login` | Authenticates username & password, returns JWT token |
| Products | `GET` | `https://fakestoreapi.com/products` | Retrieves all product items |
| Categories | `GET` | `https://fakestoreapi.com/products/categories` | Retrieves product category list |
| Users | `GET` | `https://fakestoreapi.com/users` | Retrieves user profiles to match authenticated user |

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0+)
- [Dart SDK](https://dart.dev/get-started/sdk)

### Installation & Run Steps

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Sosina47/e-commerce-app.git
   cd e-commerce-app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run
   ```

4. **Run for Web**:
   ```bash
   flutter run -d chrome
   ```

---

## 🧪 Testing & Verification

The application includes a test suite covering unit logic and widget interactions.

### Running Tests
```bash
flutter test
```

### Static Analysis
```bash
flutter analyze
```

### Web Build
```bash
flutter build web
```
