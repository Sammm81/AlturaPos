class ApiEndpoints {
  static const String baseUrl = 'https://api.example.com/api';
  
  // Authentication
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  
  // Menu
  static const String menuItems = '/menu/items';
  static const String categories = '/menu/categories';
  static String menuItem(String id) => '/menu/items/$id';
  
  // Orders
  static const String orders = '/orders';
  static String order(String id) => '/orders/$id';
  
  // Transactions
  static const String transactions = '/transactions';
  static String transaction(String id) => '/transactions/$id';
  
  // Sync
  static const String syncPull = '/sync/pull';
  static const String syncPush = '/sync/push';
  
  // Analytics
  static const String salesAnalytics = '/analytics/sales';
  static const String topItems = '/analytics/top-items';
  
  ApiEndpoints._();
}
