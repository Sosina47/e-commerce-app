# Page 5: Screens, Widgets & Styling Layer

This page details the presentation layer: screens (`lib/screens/`), reusable UI components (`lib/widgets/`), and the design system theme (`lib/utils/app_theme.dart`).

---

## 1. Design System & Theme (`lib/utils/app_theme.dart`)

The design system is defined in [app_theme.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/utils/app_theme.dart) using Material 3 color seeds.

### 1.1 Color Tokens
- **Primary Color**: `#6366F1` (Indigo)
- **Primary Light Color**: `#818CF8`
- **Secondary Color**: `#10B981` (Emerald)
- **Background Color**: `#F8FAFC` (Slate 50)
- **Surface Color**: `#FFFFFF` (Pure White)
- **Error Color**: `#EF4444` (Red)
- **Text Primary**: `#0F172A` (Slate 900)
- **Text Secondary**: `#64748B` (Slate 500)

### 1.2 Material 3 Theme Configurations
- **`CardTheme`**: Circular border radius (16px), subtle elevation (2px), slate drop shadows.
- **`InputDecorationTheme`**: Filled white inputs, 12px border radius, slate borders (`#E2E8F0`), primary indigo focus border.
- **`ElevatedButtonTheme`**: Primary color background, white text, 12px rounded corners, padding (16px vertical, 24px horizontal).

---

## 2. Reusable UI Components (`lib/widgets/`)

Atomic presentational components used across screens.

| Component | File Path | Responsibilities |
| :--- | :--- | :--- |
| **`ProductCard`** | [product_card.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/widgets/product_card.dart) | Grid item card rendering product image, loading progress, title truncation (`maxLines: 2`), and formatted price tag. |
| **`CategoryChip`** | [category_chip.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/widgets/category_chip.dart) | Filter chip button using `AnimatedContainer` for smooth background/border color animations on select. |
| **`LoadingWidget`** | [loading_widget.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/widgets/loading_widget.dart) | Centered `CircularProgressIndicator` with optional descriptive text message. |
| **`AppErrorWidget`** | [error_widget.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/widgets/error_widget.dart) | Displays error icon, title, error message text, and an interactive "Retry" button callback. |
| **`EmptyStateWidget`** | [empty_state_widget.dart](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/widgets/empty_state_widget.dart) | Centered layout displaying an icon inside a soft primary circle, title, and guidance text. |

---

## 3. Screens Layer (`lib/screens/`)

Top-level screen page views.

### 3.1 [LoginScreen](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/screens/login/login_screen.dart)
- **Role**: Handles user login authentication.
- **Features**:
  - Username & password text input fields with form validation.
  - Quick-fill demo credentials box (`johnd` / `m38rmF$`).
  - Calls `context.read<AuthProvider>().login()` and redirects to `HomeScreen` on success.

### 3.2 [HomeScreen](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/screens/home/home_screen.dart)
- **Role**: Main catalog dashboard view.
- **Features**:
  - AppBar with cart item counter badge button and user profile shortcut icon.
  - Real-time search bar calling `productProvider.setSearchQuery()`.
  - Horizontal scrolling list of [CategoryChip](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/widgets/category_chip.dart) elements.
  - 2-column Grid displaying [ProductCard](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/widgets/product_card.dart) widgets.
  - Pull-to-refresh (`RefreshIndicator`) for refetching product data.

### 3.3 [CartScreen](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/screens/cart/cart_screen.dart)
- **Role**: Shopping cart and order overview page.
- **Features**:
  - Scrollable list of cart items displaying image, title, price, and quantity increment/decrement controls.
  - Dismissible / delete item action buttons.
  - Bottom summary sheet showing total items, subtotal cost, delivery fees, and grand total.
  - Clear cart modal dialog and checkout button.

### 3.4 [ProductDetailsScreen](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/screens/product/product_details_screen.dart)
- **Role**: Detailed single product view.
- **Features**:
  - High-resolution product image presentation.
  - Rating badge display (star rating rate and review count).
  - Price, category badge, and complete product description text.
  - Bottom sticky bar with "Add to Cart" button and feedback `SnackBar`.

### 3.5 [ProfileScreen](file:///c:/Users/hp/OneDrive/Desktop/insa_projects/ecommerce_app/lib/screens/profile/profile_screen.dart)
- **Role**: Account settings and profile details page.
- **Features**:
  - User avatar, full name, email, phone number, and physical street/city/zipcode address.
  - Action button executing `AuthProvider.logout()`, clearing token and redirecting to login.
