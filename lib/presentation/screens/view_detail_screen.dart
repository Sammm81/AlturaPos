import 'package:flutter/material.dart';

enum DetailType { order, menu }

class ViewDetailScreen extends StatefulWidget {
  final String id;
  final DetailType type;

  const ViewDetailScreen({
    super.key,
    required this.id,
    required this.type,
  });

  @override
  State<ViewDetailScreen> createState() => _ViewDetailScreenState();
}

class _ViewDetailScreenState extends State<ViewDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock data
  Map<String, dynamic>? _detailData;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));
    
    setState(() {
      _detailData = widget.type == DetailType.order
          ? _getMockOrderData()
          : _getMockMenuData();
      _isLoading = false;
    });
    
    _animationController.forward();
  }

  Map<String, dynamic> _getMockOrderData() {
    return {
      'id': widget.id,
      'orderNumber': '#${widget.id}',
      'date': '30 Oct 2025, 10:30 AM',
      'status': 'Paid',
      'statusColor': const Color(0xFF4CAF50),
      'table': 'Table 5',
      'customer': 'John Doe',
      'phone': '+62 812-3456-7890',
      'items': [
        {'name': 'Burger Cheese', 'qty': 2, 'price': 45000},
        {'name': 'Iced Coffee', 'qty': 1, 'price': 25000},
        {'name': 'French Fries', 'qty': 1, 'price': 15000},
      ],
      'subtotal': 130000,
      'tax': 13000,
      'discount': 18000,
      'total': 125000,
      'paymentMethod': 'Cash',
      'notes': 'Customer requested no sugar in coffee',
      'cashier': 'Sarah Johnson',
    };
  }

  Map<String, dynamic> _getMockMenuData() {
    return {
      'id': widget.id,
      'name': 'Burger Cheese Special',
      'category': 'Main Course',
      'price': 45000,
      'description': 'Delicious beef burger with melted cheese, fresh lettuce, tomatoes, and our special sauce. Served with crispy french fries.',
      'status': 'Available',
      'statusColor': const Color(0xFF4CAF50),
      'stock': 24,
      'ingredients': ['Beef Patty', 'Cheese', 'Lettuce', 'Tomato', 'Special Sauce', 'Sesame Bun'],
      'allergens': ['Dairy', 'Gluten'],
      'prepTime': '15-20 minutes',
      'calories': '650 kcal',
    };
  }

  @override
  Widget build(BuildContext context) {
    final isOrder = widget.type == DetailType.order;
    final title = isOrder ? 'Order Details' : 'Menu Item Details';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: _buildAppBar(context, title),
      body: _isLoading ? _buildSkeletonLoader() : _buildContent(),
      bottomNavigationBar: _isLoading ? null : _buildBottomBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String title) {
    return AppBar(
      title: Text(title),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Edit functionality'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSkeletonCard(height: 120),
          const SizedBox(height: 16),
          _buildSkeletonCard(height: 200),
          const SizedBox(height: 16),
          _buildSkeletonCard(height: 150),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard({required double height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: const Color(0xFFFF6F00),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            if (widget.type == DetailType.order) ...[
              _buildCustomerInfoCard(),
              const SizedBox(height: 16),
              _buildOrderItemsCard(),
              const SizedBox(height: 16),
              _buildPaymentCard(),
              const SizedBox(height: 16),
              _buildNotesCard(),
            ] else ...[
              _buildMenuDetailsCard(),
              const SizedBox(height: 16),
              _buildIngredientsCard(),
              const SizedBox(height: 16),
              _buildNutritionCard(),
            ],
            const SizedBox(height: 80), // Space for bottom bar
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final data = _detailData!;
    final isOrder = widget.type == DetailType.order;

    return Hero(
      tag: 'detail-${widget.id}',
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6F00), Color(0xFFFFA040)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6F00).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isOrder ? data['orderNumber'] : data['name'],
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isOrder ? data['date'] : data['category'],
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(data['status'], data['statusColor']),
                ],
              ),
              if (!isOrder) ...[
                const SizedBox(height: 16),
                const Divider(color: Colors.white24, height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                    Text(
                      'Rp ${_formatCurrency(data['price'])}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoCard() {
    final data = _detailData!;
    return _buildCard(
      title: 'Customer Information',
      icon: Icons.person_outline,
      child: Column(
        children: [
          _buildInfoRow('Table', data['table']),
          const SizedBox(height: 12),
          _buildInfoRow('Customer', data['customer']),
          const SizedBox(height: 12),
          _buildInfoRow('Phone', data['phone']),
          const SizedBox(height: 12),
          _buildInfoRow('Cashier', data['cashier']),
        ],
      ),
    );
  }

  Widget _buildOrderItemsCard() {
    final data = _detailData!;
    final items = data['items'] as List<Map<String, dynamic>>;

    return _buildCard(
      title: 'Items Ordered',
      icon: Icons.shopping_bag_outlined,
      child: Column(
        children: [
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Column(
              children: [
                if (index > 0) const Divider(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6F00).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${item['qty']}x',
                          style: const TextStyle(
                            color: Color(0xFFFF6F00),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Rp ${_formatCurrency(item['price'])} each',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Rp ${_formatCurrency(item['price'] * item['qty'])}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    final data = _detailData!;
    return _buildCard(
      title: 'Payment Details',
      icon: Icons.payment_outlined,
      child: Column(
        children: [
          _buildInfoRow('Subtotal', 'Rp ${_formatCurrency(data['subtotal'])}'),
          const SizedBox(height: 12),
          _buildInfoRow('Tax (10%)', 'Rp ${_formatCurrency(data['tax'])}'),
          const SizedBox(height: 12),
          _buildInfoRow('Discount', '- Rp ${_formatCurrency(data['discount'])}',
              valueColor: Colors.green),
          const Divider(height: 24),
          _buildInfoRow(
            'Total',
            'Rp ${_formatCurrency(data['total'])}',
            isTotal: true,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6F00).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Color(0xFFFF6F00),
                ),
                const SizedBox(width: 12),
                Text(
                  'Payment Method: ${data['paymentMethod']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF6F00),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard() {
    final data = _detailData!;
    return _buildCard(
      title: 'Notes',
      icon: Icons.note_outlined,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          data['notes'],
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuDetailsCard() {
    final data = _detailData!;
    return _buildCard(
      title: 'Description',
      icon: Icons.description_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['description'],
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip('⏱️ ${data['prepTime']}'),
              _buildChip('📦 Stock: ${data['stock']}'),
              _buildChip('🔥 ${data['calories']}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsCard() {
    final data = _detailData!;
    final ingredients = data['ingredients'] as List<String>;
    final allergens = data['allergens'] as List<String>;

    return _buildCard(
      title: 'Ingredients & Allergens',
      icon: Icons.restaurant_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredients',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ingredients
                .map((ingredient) => _buildChip(ingredient, color: Colors.blue))
                .toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Allergens',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allergens
                .map((allergen) => _buildChip(allergen, color: Colors.red))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard() {
    return _buildCard(
      title: 'Additional Information',
      icon: Icons.info_outline,
      child: Column(
        children: [
          _buildInfoRow('Category', _detailData!['category']),
          const SizedBox(height: 12),
          _buildInfoRow('Availability', _detailData!['status']),
          const SizedBox(height: 12),
          _buildInfoRow('Preparation Time', _detailData!['prepTime']),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6F00).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: const Color(0xFFFF6F00), size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? (isTotal ? const Color(0xFFFF6F00) : const Color(0xFF1E1E1E)),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? const Color(0xFFFF6F00)).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (color ?? const Color(0xFFFF6F00)).withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: color ?? const Color(0xFFFF6F00),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final isOrder = widget.type == DetailType.order;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit functionality'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('EDIT'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF6F00),
                  side: const BorderSide(color: Color(0xFFFF6F00), width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (isOrder) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Printing receipt...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: Icon(isOrder ? Icons.print : Icons.close),
                label: Text(isOrder ? 'PRINT' : 'CLOSE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6F00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
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
