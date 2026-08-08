# Technical Documentation Hub

Welcome to the documentation hub for the **Flutter E-Commerce Application**.

The technical documentation is organized into modular, detailed pages located inside the [`docs/`](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/docs/index.md) folder:

- **[Master Documentation Index](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/docs/index.md)**

---

## 📖 Quick Links to Documentation Pages

1. **[Page 1: Flutter Architecture & Core Concepts](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/docs/01_flutter_architecture_and_concepts.md)**
   - Framework layers (Framework, Engine, Embedder), the Three Trees (Widget, Element, RenderObject), reactive rebuild cycles, Provider state management, and compilation modes (JIT/AOT).

2. **[Page 2: Directory & Architecture Overview](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/docs/02_directory_and_architecture_overview.md)**
   - Modular directory layout, Layered Architecture design, Mermaid dependency flow diagrams, and real-world data/event execution scenarios.

3. **[Page 3: Models & Services Layer](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/docs/03_models_and_services.md)**
   - Data transfer objects ([product.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/models/product.dart), [cart_item.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/models/cart_item.dart), [user.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/models/user.dart)), defensive JSON parsing, and REST HTTP communication ([api_service.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/services/api_service.dart)).

4. **[Page 4: State Management & Providers](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/docs/04_state_management_and_providers.md)**
   - In-depth guide to state providers ([AuthProvider](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/providers/auth_provider.dart), [CartProvider](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/providers/cart_provider.dart), [ProductProvider](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/providers/product_provider.dart), [UserProvider](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/providers/user_provider.dart)) and `SharedPreferences` local storage.

5. **[Page 5: Screens, Widgets & Styling Layer](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/docs/05_screens_widgets_and_styling.md)**
   - Material 3 theme design tokens ([app_theme.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/utils/app_theme.dart)), presentational UI components (`ProductCard`, `CategoryChip`, `LoadingWidget`, `AppErrorWidget`, `EmptyStateWidget`), and page screens (`LoginScreen`, `HomeScreen`, `CartScreen`, `ProductDetailsScreen`, `ProfileScreen`).

6. **[Page 6: Testing & Platform Configurations](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/docs/06_testing_and_platform_configurations.md)**
   - Automated unit, provider, and widget test suites in `test/`, native target platform runners (`android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/`), configuration files, and build outputs.
