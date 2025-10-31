import 'package:drift/drift.dart';
import 'package:altura_pos/data/local/database.dart';

part 'menu_dao.g.dart';

/// Data Access Object for Menu tables
@DriftAccessor(tables: [Categories, MenuItems])
class MenuDao extends DatabaseAccessor<AppDatabase> with _$MenuDaoMixin {
  MenuDao(super.db);

  // Category operations
  
  /// Get all categories
  Future<List<Category>> getAllCategories() {
    return (select(categories)
          ..orderBy([(c) => OrderingTerm.asc(c.displayOrder)]))
        .get();
  }

  /// Get active categories
  Future<List<Category>> getActiveCategories() {
    return (select(categories)
          ..where((c) => c.isActive.equals(true))
          ..orderBy([(c) => OrderingTerm.asc(c.displayOrder)]))
        .get();
  }

  /// Get category by ID
  Future<Category?> getCategoryById(String id) {
    return (select(categories)..where((c) => c.id.equals(id)))
        .getSingleOrNull();
  }

  /// Insert category
  Future<int> insertCategory(CategoriesCompanion category) {
    return into(categories).insert(category);
  }

  /// Update category
  Future<bool> updateCategory(Category category) {
    return update(categories).replace(category);
  }

  // Menu Item operations
  
  /// Get all menu items
  Future<List<MenuItem>> getAllMenuItems() {
    return select(menuItems).get();
  }

  /// Get available menu items
  Future<List<MenuItem>> getAvailableMenuItems() {
    return (select(menuItems)..where((m) => m.isAvailable.equals(true))).get();
  }

  /// Get menu items by category
  Future<List<MenuItem>> getMenuItemsByCategory(String categoryId) {
    return (select(menuItems)..where((m) => m.categoryId.equals(categoryId)))
        .get();
  }

  /// Get menu item by ID
  Future<MenuItem?> getMenuItemById(String id) {
    return (select(menuItems)..where((m) => m.id.equals(id)))
        .getSingleOrNull();
  }

  /// Search menu items by name
  Future<List<MenuItem>> searchMenuItems(String query) {
    return (select(menuItems)
          ..where((m) => m.name.contains(query)))
        .get();
  }

  /// Insert menu item
  Future<int> insertMenuItem(MenuItemsCompanion item) {
    return into(menuItems).insert(item);
  }

  /// Update menu item
  Future<bool> updateMenuItem(MenuItem item) {
    return update(menuItems).replace(item);
  }

  /// Toggle menu item availability
  Future<int> toggleAvailability(String id, bool isAvailable) {
    return (update(menuItems)..where((m) => m.id.equals(id))).write(
      MenuItemsCompanion(
        isAvailable: Value(isAvailable),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Batch insert menu items
  Future<void> batchInsertMenuItems(List<MenuItemsCompanion> items) {
    return batch((batch) {
      batch.insertAll(menuItems, items, mode: InsertMode.replace);
    });
  }

  /// Batch insert categories
  Future<void> batchInsertCategories(List<CategoriesCompanion> cats) {
    return batch((batch) {
      batch.insertAll(categories, cats, mode: InsertMode.replace);
    });
  }
}
