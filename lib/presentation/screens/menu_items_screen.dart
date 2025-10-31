import 'package:flutter/material.dart';
import 'view_detail_screen.dart';

class MenuItemsScreen extends StatefulWidget {
  const MenuItemsScreen({super.key});

  @override
  State<MenuItemsScreen> createState() => _MenuItemsScreenState();
}

class _MenuItemsScreenState extends State<MenuItemsScreen> {
  final List<Map<String, dynamic>> _menuItems = [
    {'name': 'Burger', 'price': 45000, 'icon': Icons.lunch_dining, 'category': 'Food', 'color': const Color(0xFFFF6F00)},
    {'name': 'Pizza', 'price': 65000, 'icon': Icons.local_pizza, 'category': 'Food', 'color': const Color(0xFFE91E63)},
    {'name': 'Coffee', 'price': 25000, 'icon': Icons.local_cafe, 'category': 'Beverages', 'color': const Color(0xFF795548)},
    {'name': 'Salad', 'price': 35000, 'icon': Icons.set_meal, 'category': 'Food', 'color': const Color(0xFF4CAF50)},
    {'name': 'Pasta', 'price': 55000, 'icon': Icons.ramen_dining, 'category': 'Food', 'color': const Color(0xFFFFC107)},
    {'name': 'Soda', 'price': 15000, 'icon': Icons.local_drink, 'category': 'Beverages', 'color': const Color(0xFF2196F3)},
  ];

  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Food', 'Beverages'];

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Menu Item'),
        content: const Text('Menu item creation form will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item added successfully'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredItems {
    if (_selectedCategory == 'All') return _menuItems;
    return _menuItems.where((item) => item['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Menu Items'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Category Filter Chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xFFFF6F00).withOpacity(0.2),
                  checkmarkColor: const Color(0xFFFF6F00),
                  labelStyle: TextStyle(
                    color: isSelected ? const Color(0xFFFF6F00) : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFFFF6F00) : Colors.grey[300]!,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Grid of menu items
          Expanded(
            child: _filteredItems.isEmpty
                ? _buildEmptyState(context)
                : GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return _buildMenuItem(context, item, index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddItemDialog,
        icon: const Icon(Icons.add),
        label: const Text('ADD ITEM'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No menu items',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first menu item',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item, int index) {
    final color = item['color'] as Color? ?? const Color(0xFFFF6F00);
    
    return Hero(
      tag: 'menu-item-$index',
      child: Card(
        elevation: 4,
        shadowColor: color.withAlpha(80),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewDetailScreen(
                  id: item['name'] as String,
                  type: DetailType.menu,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  color.withAlpha(15),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Futuristic Icon Header
                Container(
                  height: 105,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color,
                        color.withAlpha(200),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Animated circles background
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withAlpha(25),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -10,
                        left: -10,
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withAlpha(15),
                          ),
                        ),
                      ),
                      // Icon
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withAlpha(40),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            size: 38,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Category Badge
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(230),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(20),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            item['category'] as String,
                            style: TextStyle(
                              color: color,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title
                        Text(
                          item['name'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E1E),
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        
                        // Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Rp ${_formatCurrency(item['price'] as int)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: color,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
