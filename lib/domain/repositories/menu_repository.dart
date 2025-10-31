import 'package:dartz/dartz.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/entities/category.dart';
import 'package:altura_pos/domain/entities/menu_item.dart';

/// Menu repository interface
abstract class MenuRepository {
  /// Get all menu items
  Future<Either<Failure, List<MenuItem>>> getMenuItems();

  /// Get menu items by category
  Future<Either<Failure, List<MenuItem>>> getMenuItemsByCategory(
    String categoryId,
  );

  /// Get menu item by ID
  Future<Either<Failure, MenuItem>> getMenuItemById(String id);

  /// Search menu items by name
  Future<Either<Failure, List<MenuItem>>> searchMenuItems(String query);

  /// Get all categories
  Future<Either<Failure, List<Category>>> getCategories();

  /// Get category by ID
  Future<Either<Failure, Category>> getCategoryById(String id);

  /// Update menu item
  Future<Either<Failure, MenuItem>> updateMenuItem(MenuItem item);

  /// Toggle menu item availability
  Future<Either<Failure, MenuItem>> toggleAvailability(
    String id,
    bool isAvailable,
  );

  /// Sync menu data from server
  Future<Either<Failure, void>> syncMenuData();
}
