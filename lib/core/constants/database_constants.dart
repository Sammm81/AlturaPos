class DatabaseConstants {
  static const String databaseName = 'altura_pos.db';
  static const int databaseVersion = 1;
  
  // Table names
  static const String usersTable = 'users';
  static const String categoriesTable = 'categories';
  static const String menuItemsTable = 'menu_items';
  static const String ordersTable = 'orders';
  static const String orderItemsTable = 'order_items';
  static const String transactionsTable = 'transactions';
  static const String syncQueueTable = 'sync_queue';
  
  DatabaseConstants._();
}
