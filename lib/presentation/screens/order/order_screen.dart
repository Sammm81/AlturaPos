import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:altura_pos/core/constants/app_strings.dart';
import 'package:altura_pos/core/utils/formatters.dart';
import 'package:altura_pos/presentation/providers/menu_provider.dart';
import 'package:altura_pos/presentation/providers/cart_provider.dart';
import 'package:altura_pos/presentation/providers/order_provider.dart';
import 'package:altura_pos/presentation/widgets/order/cart_panel.dart';
import 'package:altura_pos/presentation/widgets/order/order_type_selector.dart';
import 'package:altura_pos/presentation/widgets/order/modifier_selection_dialog.dart';
import 'package:altura_pos/presentation/widgets/menu/menu_item_card.dart';
import 'package:altura_pos/presentation/widgets/common/error_display.dart';
import 'package:altura_pos/presentation/widgets/common/loading_indicator.dart';
import 'package:altura_pos/domain/entities/menu_item.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load menu when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(menuProvider.notifier).loadMenu();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTabletOrDesktop = screenWidth >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.newOrder),
        actions: [
          // Order type selector
          const OrderTypeSelector(),
          const SizedBox(width: 8),
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: menuState.isLoading
                ? null
                : () => ref.read(menuProvider.notifier).refresh(),
          ),
        ],
      ),
      body: isTabletOrDesktop
          ? _buildSplitView()
          : _buildMobileView(),
    );
  }

  /// Build split view for tablet and desktop
  Widget _buildSplitView() {
    return Row(
      children: [
        // Menu section (left side)
        Expanded(
          flex: 2,
          child: _buildMenuSection(),
        ),
        // Divider
        const VerticalDivider(width: 1),
        // Cart section (right side)
        const SizedBox(
          width: 400,
          child: CartPanel(),
        ),
      ],
    );
  }

  /// Build mobile view (menu only, cart as bottom sheet)
  Widget _buildMobileView() {
    final cartItemCount = ref.watch(cartItemCountProvider);

    return Stack(
      children: [
        _buildMenuSection(),
        // Floating cart button
        if (cartItemCount > 0)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.extended(
              onPressed: () => _showCartBottomSheet(),
              icon: const Icon(Icons.shopping_cart),
              label: Text('$cartItemCount items'),
            ),
          ),
      ],
    );
  }

  Widget _buildMenuSection() {
    final menuState = ref.watch(menuProvider);

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: AppStrings.searchMenu,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(menuProvider.notifier).searchItems('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              ref.read(menuProvider.notifier).searchItems(value);
            },
          ),
        ),

        // Category filter chips
        if (menuState.categories.isNotEmpty)
          SizedBox(
            height: 50,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                // All categories chip
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text(AppStrings.allCategories),
                    selected: menuState.selectedCategoryId == null,
                    onSelected: (selected) {
                      if (selected) {
                        ref.read(menuProvider.notifier).filterByCategory(null);
                      }
                    },
                  ),
                ),
                // Category chips
                ...menuState.categories.map((category) {
                  final isSelected = menuState.selectedCategoryId == category.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        ref
                            .read(menuProvider.notifier)
                            .filterByCategory(selected ? category.id : null);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

        const SizedBox(height: 8),

        // Menu items grid
        Expanded(
          child: _buildMenuContent(menuState),
        ),
      ],
    );
  }

  Widget _buildMenuContent(MenuState menuState) {
    if (menuState.isLoading) {
      return const LoadingIndicator(message: 'Loading menu...');
    }

    final availableItems = menuState.filteredItems
        .where((item) => item.isAvailable)
        .toList();

    if (availableItems.isEmpty) {
      return ErrorDisplay(
        message: menuState.searchQuery.isNotEmpty ||
                menuState.selectedCategoryId != null
            ? AppStrings.noItemsFound
            : AppStrings.noData,
        onRetry: () => ref.read(menuProvider.notifier).refresh(),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(menuProvider.notifier).refresh(),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(context),
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: availableItems.length,
        itemBuilder: (context, index) {
          final item = availableItems[index];
          return MenuItemCard(
            item: item,
            canToggleAvailability: false,
            onTap: () => _handleItemTap(item),
          );
        },
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 4;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 2;
  }

  void _handleItemTap(MenuItem item) {
    if (item.hasVariants || item.modifiers.isNotEmpty) {
      // Show modifier dialog
      _showModifierDialog(item);
    } else {
      // Add directly to cart
      ref.read(cartProvider.notifier).addItem(
            menuItem: item,
            quantity: 1,
          );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.name} added to cart'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _showModifierDialog(MenuItem item) {
    showDialog(
      context: context,
      builder: (context) => ModifierSelectionDialog(menuItem: item),
    );
  }

  void _showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => const CartPanel(),
      ),
    );
  }
}
