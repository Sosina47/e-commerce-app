import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/product_card.dart';
import '../cart/cart_screen.dart';
import '../product/product_details_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        final provider = context.read<ProductProvider>();
        provider.fetchCategories();
        provider.fetchProducts();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.deepPurple;
    final productProvider = context.watch<ProductProvider>();
    final cartItemCount = context.watch<CartProvider>().itemCount;

    String appBarTitle = 'Fake Store';
    if (_currentBottomNavIndex == 1) {
      appBarTitle = 'Shopping Cart';
    } else if (_currentBottomNavIndex == 2) {
      appBarTitle = 'Profile';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  setState(() {
                    _currentBottomNavIndex = 1;
                  });
                },
              ),
              if (cartItemCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              setState(() {
                _currentBottomNavIndex = 2;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBodyContent(productProvider),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentBottomNavIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          elevation: 0,
          backgroundColor: Colors.white,
          onTap: (index) {
            setState(() {
              _currentBottomNavIndex = index;
            });
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: cartItemCount > 0,
                label: Text('$cartItemCount'),
                backgroundColor: primaryColor,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: cartItemCount > 0,
                label: Text('$cartItemCount'),
                backgroundColor: primaryColor,
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent(ProductProvider productProvider) {
    if (_currentBottomNavIndex == 1) {
      return const CartScreen();
    }
    if (_currentBottomNavIndex == 2) {
      return const ProfileScreen();
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<ProductProvider>().setSearchQuery(value);
              },
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Color(0xFF64748B)),
                        onPressed: () {
                          _searchController.clear();
                          context.read<ProductProvider>().setSearchQuery('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Section
            _buildCategorySection(productProvider),
            const SizedBox(height: 16),

            // Product Grid / Loading / Error / Empty States
            Expanded(
              child: _buildProductContent(productProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(ProductProvider provider) {
    if (provider.isCategoriesLoading) {
      return const SizedBox(
        height: 42,
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(color: Colors.deepPurple, strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text(
              'Loading Categories...',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ],
        ),
      );
    }

    if (provider.hasCategoriesError) {
      return SizedBox(
        height: 42,
        child: Row(
          children: [
            const Text(
              'Unable to load categories.',
              style: TextStyle(fontSize: 13, color: Colors.redAccent),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                context.read<ProductProvider>().fetchCategories(forceRefresh: true);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (provider.categories.isEmpty) {
      return const SizedBox(
        height: 42,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'No categories available.',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ),
      );
    }

    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: provider.categories.length,
        itemBuilder: (context, index) {
          final category = provider.categories[index];
          final isSelected = provider.selectedCategory == category;
          return CategoryChip(
            label: category,
            isSelected: isSelected,
            onTap: () {
              context.read<ProductProvider>().selectCategory(category);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductContent(ProductProvider provider) {
    // 1. Loading State
    if (provider.isLoading) {
      return const LoadingWidget(message: 'Loading Products...');
    }

    // 2. Error State
    if (provider.hasError) {
      return AppErrorWidget(
        title: 'Unable to connect.',
        message: 'Please try again.',
        onRetry: () {
          context.read<ProductProvider>().fetchProducts(forceRefresh: true);
        },
      );
    }

    // 3. Empty Products (initial fetch returned empty)
    if (provider.products.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.inventory_2_outlined,
        title: 'No products available.',
      );
    }

    final filteredProducts = provider.filteredProducts;

    // 4. Empty Search State (search or category returned empty)
    if (filteredProducts.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.search_off_outlined,
        title: 'No products found.',
      );
    }

    // 5. Success State (Product Grid)
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth > 900) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 600) {
          crossAxisCount = 3;
        }

        return GridView.builder(
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: filteredProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.70,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return ProductCard(
              product: product,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(product: product),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
