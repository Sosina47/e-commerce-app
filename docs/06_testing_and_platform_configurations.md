# Page 6: Testing & Platform Configurations

This page covers the automated test suite (`test/`), platform native build wrappers, root project settings, and build output directories.

---

## 1. Automated Test Suite (`test/`)

The application contains automated tests covering Unit logic, Provider state mutations, and Widget UI rendering.

| Test File | Test Type | Coverage & Verification |
| :--- | :--- | :--- |
| [auth_provider_test.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/test/auth_provider_test.dart) | Unit / Provider Test | Verifies initial state, token storage check, login authentication flows, and logout cleanups. |
| [cart_provider_test.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/test/cart_provider_test.dart) | Unit / Provider Test | Tests adding products, increasing/decreasing quantities, item removal, price calculations, and clearing cart. |
| [product_provider_test.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/test/product_provider_test.dart) | Unit / Provider Test | Verifies product catalog fetching, category list population, search string filtering, and category selection. |
| [user_provider_test.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/test/user_provider_test.dart) | Unit / Provider Test | Tests profile retrieval by username, error handling on network failure, and profile clearing. |
| [cart_screen_test.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/test/cart_screen_test.dart) | Widget Test | Renders `CartScreen` in mock providers to verify empty cart message and populated item layout. |
| [profile_screen_test.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/test/profile_screen_test.dart) | Widget Test | Verifies profile layout rendering, user details text display, and logout button interaction. |
| [widget_test.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/test/widget_test.dart) | Smoke Test | Top-level widget initialization test verifying full app launch tree. |

### 1.1 Running Tests
Execute test suites via Flutter CLI:
```bash
flutter test
```

---

## 2. Platform Target Wrappers

Native platform subdirectories house OS-specific configurations and embedder code:

- **`android/`**:
  - `AndroidManifest.xml`: Permissions (Internet access), application permissions, app icons, theme launcher.
  - `build.gradle` & `app/build.gradle`: Gradle build scripts, minification rules, target SDK versions (`compileSdkVersion`, `targetSdkVersion`).
  - `MainActivity.kt`: Native Android activity host embedding the Flutter Engine.
- **`ios/`**:
  - `Info.plist`: iOS app permissions, orientation limits, display properties.
  - `Podfile`: CocoaPods iOS dependency manager configuration.
  - `AppDelegate.swift`: Swift native application delegate.
- **`web/`**:
  - `index.html`: Entry HTML5 web page hosting the compiled Flutter Web assembly script canvas.
  - `manifest.json`: Web app PWA installation manifest.
- **`windows/`**, **`macos/`**, **`linux/`**: Native desktop runners (`main.cpp`, `Runner.xcworkspace`) wrapping the engine in desktop native C++ / Swift windows.

---

## 3. Tooling & Output Directories

- **`.dart_tool/`**: Internal Dart SDK package dependency cache, analyzer data, and build system configuration files. Git-ignored.
- **`build/`**: Intermediate compilation outputs (compiled APKs, IPAs, web JavaScript files, desktop native executables). Git-ignored.
- **`.idea/`**: IntelliJ IDEA workspace configuration settings. Git-ignored.
