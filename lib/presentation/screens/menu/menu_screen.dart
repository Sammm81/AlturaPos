import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:altura_pos/core/constants/app_strings.dart';
import 'package:altura_pos/presentation/providers/menu_provider.dart';
import 'package:altura_pos/presentation/providers/auth_provider.dart';
import 'package:altura_pos/presentation/widgets/menu/menu_item_card.dart';
import 'package:altura_pos/presentation/widgets/common/error_display.dart';
import 'package:altura_pos/presentation/widgets/common/loading_indicator.dart';
import 'package:altura_pos/domain/entities/user.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = ref.watch(menuProvider);
    final currentUser = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    // Listen to errors
    ref.listen<MenuState>(menuProvider, (previous, next) {
      if (next.errorMessage != null) {
        ErrorSnackBar.show(context, next.errorMessage!);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.menu),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: menuState.isLoading
                ? null
                : () => ref.read(menuProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
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
                    final isSelected = 
                        menuState.selectedCategoryId == category.id;
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
            child: _buildMenuContent(menuState, currentUser),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuContent(MenuState menuState, User? currentUser) {
    if (menuState.isLoading) {
      return const LoadingIndicator(message: 'Loading menu...');
    }

    if (menuState.filteredItems.isEmpty) {
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
        itemCount: menuState.filteredItems.length,
        itemBuilder: (context, index) {
          final item = menuState.filteredItems[index];
          final canToggle = currentUser?.role == UserRole.manager ||
              currentUser?.role == UserRole.admin;

          return MenuItemCard(
            item: item,
            canToggleAvailability: canToggle,
            onTap: () {
              // Navigate to item detail or add to cart
              // For now, just show a placeholder
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected: ${item.name}')),
              );
            },
            onToggleAvailability: canToggle
                ? () => _toggleAvailability(item)
                : null,
          );
        },
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 5;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  Future<void> _toggleAvailability(item) async {
    final success = await ref
        .read(menuProvider.notifier)
        .toggleItemAvailability(item);

    if (!mounted) return;

    if (success) {
      SuccessSnackBar.show(
        context,
        AppStrings.menuItemUpdated,
      );
    }
  }
}
