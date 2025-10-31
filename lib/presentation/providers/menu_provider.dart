import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/entities/category.dart';
import 'package:altura_pos/domain/entities/menu_item.dart';
import 'package:altura_pos/domain/usecases/menu/get_menu_items.dart';
import 'package:altura_pos/domain/usecases/menu/get_categories.dart';
import 'package:altura_pos/domain/usecases/menu/toggle_menu_item_availability.dart';
import 'package:altura_pos/presentation/providers/repository_providers.dart';

/// Menu state
class MenuState {
  final List<MenuItem> allItems;
  final List<MenuItem> filteredItems;
  final List<Category> categories;
  final String? selectedCategoryId;
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;

  const MenuState({
    this.allItems = const [],
    this.filteredItems = const [],
    this.categories = const [],
    this.selectedCategoryId,
    this.searchQuery = '',
    this.isLoading = false,
    this.errorMessage,
  });

  MenuState copyWith({
    List<MenuItem>? allItems,
    List<MenuItem>? filteredItems,
    List<Category>? categories,
    String? selectedCategoryId,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MenuState(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  MenuState clearError() {
    return MenuState(
      allItems: allItems,
      filteredItems: filteredItems,
      categories: categories,
      selectedCategoryId: selectedCategoryId,
      searchQuery: searchQuery,
      isLoading: isLoading,
      errorMessage: null,
    );
  }
}

/// Menu notifier
class MenuNotifier extends StateNotifier<MenuState> {
  MenuNotifier(
    this._getMenuItems,
    this._getCategories,
    this._toggleAvailability,
  ) : super(const MenuState()) {
    loadMenu();
  }

  final GetMenuItems _getMenuItems;
  final GetCategories _getCategories;
  final ToggleMenuItemAvailability _toggleAvailability;

  /// Load menu items and categories
  Future<void> loadMenu() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Load categories
    final categoriesResult = await _getCategories();
    
    // Load menu items
    final itemsResult = await _getMenuItems();

    categoriesResult.fold(
      (failure) {
        final errorMessage = _getErrorMessage(failure);
        state = state.copyWith(
          isLoading: false,
          errorMessage: errorMessage,
        );
      },
      (categories) {
        itemsResult.fold(
          (failure) {
            final errorMessage = _getErrorMessage(failure);
            state = state.copyWith(
              categories: categories,
              isLoading: false,
              errorMessage: errorMessage,
            );
          },
          (items) {
            state = MenuState(
              allItems: items,
              filteredItems: items,
              categories: categories,
              isLoading: false,
            );
          },
        );
      },
    );
  }

  /// Filter by category
  void filterByCategory(String? categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
    _applyFilters();
  }

  /// Search menu items
  void searchItems(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  /// Apply filters (category and search)
  void _applyFilters() {
    var filtered = state.allItems;

    // Apply category filter
    if (state.selectedCategoryId != null) {
      filtered = filtered
          .where((item) => item.categoryId == state.selectedCategoryId)
          .toList();
    }

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((item) {
        final nameMatch = item.name.toLowerCase().contains(query);
        final descMatch = 
            item.description?.toLowerCase().contains(query) ?? false;
        return nameMatch || descMatch;
      }).toList();
    }

    state = state.copyWith(filteredItems: filtered);
  }

  /// Toggle menu item availability
  Future<bool> toggleItemAvailability(MenuItem item) async {
    final result = await _toggleAvailability(
      id: item.id,
      isAvailable: !item.isAvailable,
    );

    return result.fold(
      (failure) {
        final errorMessage = _getErrorMessage(failure);
        state = state.copyWith(errorMessage: errorMessage);
        return false;
      },
      (updatedItem) {
        // Update the item in both lists
        final updatedAllItems = state.allItems.map((i) {
          return i.id == updatedItem.id ? updatedItem : i;
        }).toList();

        final updatedFilteredItems = state.filteredItems.map((i) {
          return i.id == updatedItem.id ? updatedItem : i;
        }).toList();

        state = state.copyWith(
          allItems: updatedAllItems,
          filteredItems: updatedFilteredItems,
        );
        return true;
      },
    );
  }

  /// Refresh menu data
  Future<void> refresh() async {
    await loadMenu();
  }

  /// Clear error message
  void clearError() {
    state = state.clearError();
  }

  /// Clear filters
  void clearFilters() {
    state = MenuState(
      allItems: state.allItems,
      filteredItems: state.allItems,
      categories: state.categories,
      selectedCategoryId: null,
      searchQuery: '',
      isLoading: false,
    );
  }

  /// Get error message from failure
  String _getErrorMessage(Failure failure) {
    return failure.when(
      server: (message, statusCode) => message,
      network: (message) => message,
      database: (message, error) => message,
      authentication: (message) => message,
      validation: (message) => message,
      cache: (message) => message,
      unknown: (message) => message,
    );
  }
}

/// Menu provider
final menuProvider = StateNotifierProvider<MenuNotifier, MenuState>((ref) {
  final menuRepository = ref.watch(menuRepositoryProvider);

  return MenuNotifier(
    GetMenuItems(menuRepository),
    GetCategories(menuRepository),
    ToggleMenuItemAvailability(menuRepository),
  );
});

/// Available items provider (items that are available for ordering)
final availableItemsProvider = Provider<List<MenuItem>>((ref) {
  final menuState = ref.watch(menuProvider);
  return menuState.filteredItems.where((item) => item.isAvailable).toList();
});

/// Categories provider
final categoriesProvider = Provider<List<Category>>((ref) {
  return ref.watch(menuProvider).categories;
});

/// Selected category provider
final selectedCategoryProvider = Provider<String?>((ref) {
  return ref.watch(menuProvider).selectedCategoryId;
});

/// Search query provider
final searchQueryProvider = Provider<String>((ref) {
  return ref.watch(menuProvider).searchQuery;
});
