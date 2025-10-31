import 'package:flutter/material.dart';
import 'variant_selector_sheet.dart';
import '../../data/sample_variants.dart';
import '../../data/models/variant_models.dart';

class SelectItemBottomSheet extends StatefulWidget {
  const SelectItemBottomSheet({super.key});

  @override
  State<SelectItemBottomSheet> createState() => _SelectItemBottomSheetState();
}

class _SelectItemBottomSheetState extends State<SelectItemBottomSheet>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _sortBy = 'name';
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // Track selected items internally
  final List<Map<String, dynamic>> _selectedItems = [];
  int _totalAmount = 0;

  final List<String> _categories = [
    'All',
    'Beverages',
    'Food',
    'Snacks',
    'Dessert',
  ];

  final List<Map<String, dynamic>> _allItems = [
    {
      'name': 'Burger Cheese',
      'price': 45000,
      'category': 'Food',
      'icon': Icons.lunch_dining,
      'color': const Color(0xFFFF6F00),
    },
    {
      'name': 'Pizza Margherita',
      'price': 65000,
      'category': 'Food',
      'icon': Icons.local_pizza,
      'color': const Color(0xFFE91E63),
    },
    {
      'name': 'Iced Coffee',
      'price': 25000,
      'category': 'Beverages',
      'icon': Icons.local_cafe,
      'color': const Color(0xFF795548),
    },
    {
      'name': 'Orange Juice',
      'price': 20000,
      'category': 'Beverages',
      'icon': Icons.local_drink,
      'color': const Color(0xFFFF9800),
    },
    {
      'name': 'Caesar Salad',
      'price': 35000,
      'category': 'Food',
      'icon': Icons.set_meal,
      'color': const Color(0xFF4CAF50),
    },
    {
      'name': 'Pasta Carbonara',
      'price': 55000,
      'category': 'Food',
      'icon': Icons.ramen_dining,
      'color': const Color(0xFFFFC107),
    },
    {
      'name': 'French Fries',
      'price': 18000,
      'category': 'Snacks',
      'icon': Icons.fastfood,
      'color': const Color(0xFFFFEB3B),
    },
    {
      'name': 'Chicken Wings',
      'price': 42000,
      'category': 'Snacks',
      'icon': Icons.food_bank,
      'color': const Color(0xFFFF5722),
    },
    {
      'name': 'Ice Cream',
      'price': 22000,
      'category': 'Dessert',
      'icon': Icons.icecream,
      'color': const Color(0xFF9C27B0),
    },
    {
      'name': 'Chocolate Cake',
      'price': 38000,
      'category': 'Dessert',
      'icon': Icons.cake,
      'color': const Color(0xFF8D6E63),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _loadItems();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _animationController.forward();
    }
  }

  List<Map<String, dynamic>> get _filteredItems {
    var items = _allItems;

    if (_selectedCategory != 'All') {
      items = items.where((item) => item['category'] == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      items = items
          .where((item) => item['name']
              .toString()
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_sortBy == 'price_asc') {
      items.sort((a, b) => (a['price'] as int).compareTo(b['price'] as int));
    } else if (_sortBy == 'price_desc') {
      items.sort((a, b) => (b['price'] as int).compareTo(a['price'] as int));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF3E0), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHandle(),
                  _buildHeader(context),
                  _buildSearchBar(),
                  _buildCategoryFilter(),
                  _buildSortOptions(),
                  const Divider(height: 1),
                  Expanded(
                    child: _isLoading
                        ? _buildShimmerLoader()
                        : _buildItemList(scrollController),
                  ),
                ],
              ),
              // Persistent footer
              if (_selectedItems.isNotEmpty) _buildCartFooter(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Text(
            'Select Item',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E1E),
                ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, size: 24),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search item...',
            prefixIcon: const Icon(Icons.search, color: Color(0xFFFF6F00)),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return _CategoryChip(
            label: category,
            isSelected: isSelected,
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildSortOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.sort, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            'Sort by:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortChip('Name', 'name'),
                  const SizedBox(width: 8),
                  _buildSortChip('Price ↑', 'price_asc'),
                  const SizedBox(width: 8),
                  _buildSortChip('Price ↓', 'price_desc'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _sortBy = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6F00) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6F00) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  Widget _buildItemList(ScrollController scrollController) {
    final items = _filteredItems;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100), // Extra padding for footer
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _ItemTile(
            item: item,
            onTap: () => _onItemSelected(item),
          );
        },
      ),
    );
  }

  Future<void> _onItemSelected(Map<String, dynamic> item) async {
    // Get variants for this item
    final variants = SampleVariants.getVariantsForItem(item['name'] as String);
    
    // Open variant selector sheet
    final customizedItem = await showModalBottomSheet<CustomizedItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VariantSelectorSheet(
        item: item,
        variants: variants,
      ),
    );
    
    if (customizedItem != null && mounted) {
      setState(() {
        // Add the customized item to cart
        _selectedItems.add(customizedItem.toMap());
        _totalAmount += customizedItem.totalPrice;
      });
      
      // Show success feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${item['name']} added'),
                      if (customizedItem.getVariantSummary().isNotEmpty)
                        Text(
                          customizedItem.getVariantSummary(),
                          style: const TextStyle(fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(milliseconds: 1200),
            margin: const EdgeInsets.only(
              bottom: 80, // Above the footer
              left: 16,
              right: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _onDone() {
    Navigator.pop(context, _selectedItems);
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  Widget _buildCartFooter() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 15,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              // Cart icon with badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6F00).withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Color(0xFFFF6F00),
                      size: 24,
                    ),
                  ),
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6F00),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Center(
                        child: Text(
                          _selectedItems.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Items and subtotal info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${_selectedItems.length} item${_selectedItems.length > 1 ? 's' : ''} added',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Subtotal: Rp ${_formatCurrency(_totalAmount)}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Done button
              ElevatedButton(
                onPressed: _onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6F00),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Category Chip Widget
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF6F00) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6F00) : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF6F00).withAlpha(60),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}

// Item Tile Widget
class _ItemTile extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const _ItemTile({
    required this.item,
    required this.onTap,
  });

  @override
  State<_ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<_ItemTile> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _handleTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                (widget.item['color'] as Color).withAlpha(10),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.item['color'] as Color,
                      (widget.item['color'] as Color).withAlpha(180),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: (widget.item['color'] as Color).withAlpha(60),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  widget.item['icon'] as IconData,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              
              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${_formatCurrency(widget.item['price'] as int)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Add Button with bounce animation
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6F00),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6F00).withAlpha(60),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
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
