import 'package:flutter/material.dart';
import '../../data/models/variant_models.dart';

class VariantSelectorSheet extends StatefulWidget {
  final Map<String, dynamic> item;
  final List<VariantGroup> variants;

  const VariantSelectorSheet({
    super.key,
    required this.item,
    required this.variants,
  });

  @override
  State<VariantSelectorSheet> createState() => _VariantSelectorSheetState();
}

class _VariantSelectorSheetState extends State<VariantSelectorSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  int _quantity = 1;
  final Map<String, List<VariantOption>> _selectedVariants = {};
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
    
    // Initialize default selections for required single-select groups
    for (final group in widget.variants) {
      if (group.isRequired && !group.isMultiple && group.options.isNotEmpty) {
        _selectedVariants[group.id] = [group.options.first];
        group.options.first.selected = true;
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int _calculateTotal() {
    int basePrice = widget.item['price'] as int;
    int variantPrice = 0;
    
    _selectedVariants.forEach((groupId, options) {
      for (final option in options) {
        variantPrice += option.extraPrice;
      }
    });
    
    return (basePrice + variantPrice) * _quantity;
  }

  bool _canAddToOrder() {
    // Check all required groups have selections
    for (final group in widget.variants) {
      if (group.isRequired) {
        final selected = _selectedVariants[group.id];
        if (selected == null || selected.isEmpty) {
          return false;
        }
        if (group.minSelection != null && selected.length < group.minSelection!) {
          return false;
        }
      }
    }
    return _quantity > 0;
  }

  void _handleSingleSelect(VariantGroup group, VariantOption option) {
    setState(() {
      // Deselect all options in this group
      for (final opt in group.options) {
        opt.selected = false;
      }
      
      // Select the chosen option
      option.selected = true;
      _selectedVariants[group.id] = [option];
    });
  }

  void _handleMultiSelect(VariantGroup group, VariantOption option) {
    setState(() {
      if (option.selected) {
        // Deselect
        option.selected = false;
        _selectedVariants[group.id]?.remove(option);
        if (_selectedVariants[group.id]?.isEmpty ?? false) {
          _selectedVariants.remove(group.id);
        }
      } else {
        // Check max selection
        final currentCount = _selectedVariants[group.id]?.length ?? 0;
        if (group.maxSelection != null && currentCount >= group.maxSelection!) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Maximum ${group.maxSelection} selections allowed'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
            ),
          );
          return;
        }
        
        // Select
        option.selected = true;
        _selectedVariants.putIfAbsent(group.id, () => []);
        _selectedVariants[group.id]!.add(option);
      }
    });
  }

  void _addToOrder() {
    final customizedItem = CustomizedItem(
      itemId: widget.item['name'] as String,
      itemName: widget.item['name'] as String,
      basePrice: widget.item['price'] as int,
      category: widget.item['category'] as String,
      selectedVariants: Map.from(_selectedVariants),
      quantity: _quantity,
      specialNotes: _notesController.text.trim().isNotEmpty 
          ? _notesController.text.trim() 
          : null,
      totalPrice: _calculateTotal(),
    );
    
    Navigator.pop(context, customizedItem);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildItemInfo(),
                    const SizedBox(height: 24),
                    ...widget.variants.map((group) => _buildVariantGroup(group)),
                    const SizedBox(height: 16),
                    _buildSpecialNotes(),
                    const SizedBox(height: 100), // Space for footer
                  ],
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Customize Your Order',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select your preferences',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF1E1E1E)),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6F00).withAlpha(25),
            const Color(0xFFFF6F00).withAlpha(10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF6F00).withAlpha(60),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6F00),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.item['icon'] as IconData,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item['name'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Base Price: Rp ${_formatCurrency(widget.item['price'] as int)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantGroup(VariantGroup group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  group.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
              ),
              if (group.isRequired)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6F00).withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'REQUIRED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6F00),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
          if (group.maxSelection != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Select up to ${group.maxSelection}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: group.options.map((option) {
              if (group.isMultiple) {
                return FilterChip(
                  label: Text(_buildOptionLabel(option)),
                  selected: option.selected,
                  onSelected: (selected) => _handleMultiSelect(group, option),
                  backgroundColor: Colors.grey[50],
                  selectedColor: const Color(0xFFFF6F00).withAlpha(40),
                  checkmarkColor: const Color(0xFFFF6F00),
                  labelStyle: TextStyle(
                    color: option.selected 
                        ? const Color(0xFFFF6F00) 
                        : Colors.grey[800],
                    fontWeight: option.selected 
                        ? FontWeight.w600 
                        : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: option.selected 
                          ? const Color(0xFFFF6F00) 
                          : Colors.grey[300]!,
                      width: 1.5,
                    ),
                  ),
                );
              } else {
                return ChoiceChip(
                  label: Text(_buildOptionLabel(option)),
                  selected: option.selected,
                  onSelected: (selected) => _handleSingleSelect(group, option),
                  backgroundColor: Colors.grey[50],
                  selectedColor: const Color(0xFFFF6F00).withAlpha(40),
                  labelStyle: TextStyle(
                    color: option.selected 
                        ? const Color(0xFFFF6F00) 
                        : Colors.grey[800],
                    fontWeight: option.selected 
                        ? FontWeight.w600 
                        : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: option.selected 
                          ? const Color(0xFFFF6F00) 
                          : Colors.grey[300]!,
                      width: 1.5,
                    ),
                  ),
                );
              }
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _buildOptionLabel(VariantOption option) {
    if (option.extraPrice > 0) {
      return '${option.label} (+Rp ${_formatCurrency(option.extraPrice)})';
    }
    return option.label;
  }

  Widget _buildSpecialNotes() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Special Notes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E1E),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Any special requests? (optional)',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFFF6F00), width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final total = _calculateTotal();
    final canAdd = _canAddToOrder();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quantity Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 20),
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                      color: const Color(0xFFFF6F00),
                      disabledColor: Colors.grey[400],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      onPressed: () => setState(() => _quantity++),
                      color: const Color(0xFFFF6F00),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Add to Order Button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: canAdd
                  ? const LinearGradient(
                      colors: [Color(0xFFFF6F00), Color(0xFFFFA726)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : LinearGradient(
                      colors: [Colors.grey[300]!, Colors.grey[400]!],
                    ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: canAdd
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFF6F00).withAlpha(60),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: ElevatedButton(
              onPressed: canAdd ? _addToOrder : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add to Order',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Rp ${_formatCurrency(total)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
