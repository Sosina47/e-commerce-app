import 'package:flutter/material.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  int _currentBottomNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Electronics',
    'Jewelery',
    "Men's Clothing",
    "Women's Clothing",
  ];

  final List<Map<String, dynamic>> _placeholderProducts = [
    {
      'title': 'Fjallraven - Foldsack No. 1 Backpack',
      'price': '\$99.99',
      'icon': Icons.backpack_outlined,
    },
    {
      'title': 'Mens Casual Premium Slim Fit T-Shirt',
      'price': '\$99.99',
      'icon': Icons.checkroom_outlined,
    },
    {
      'title': 'Mens Cotton Jacket Outdoor Casual',
      'price': '\$99.99',
      'icon': Icons.dry_cleaning_outlined,
    },
    {
      'title': 'Mens Casual Slim Fit Long Sleeve',
      'price': '\$99.99',
      'icon': Icons.checkroom_outlined,
    },
    {
      'title': 'John Hardy Womens Legends Naga Bracelet',
      'price': '\$99.99',
      'icon': Icons.diamond_outlined,
    },
    {
      'title': 'Solid Gold Petite Micropave Ring',
      'price': '\$99.99',
      'icon': Icons.style_outlined,
    },
    {
      'title': 'WD 2TB Elements Portable Hard Drive',
      'price': '\$99.99',
      'icon': Icons.sd_storage_outlined,
    },
    {
      'title': 'SanDisk SSD PLUS 1TB Internal SSD',
      'price': '\$99.99',
      'icon': Icons.memory_outlined,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.deepPurple;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Fake Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search, color: primaryColor),
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
                    borderSide: const BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category Section
              SizedBox(
                height: 42,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return CategoryChip(
                      label: _categories[index],
                      isSelected: _selectedCategoryIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Product Grid
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                    return GridView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: _placeholderProducts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemBuilder: (context, index) {
                        final product = _placeholderProducts[index];
                        return ProductCard(
                          title: product['title'] as String,
                          price: product['price'] as String,
                          icon: product['icon'] as IconData,
                          onTap: () {},
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
