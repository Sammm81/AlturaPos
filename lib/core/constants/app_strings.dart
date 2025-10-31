/// App string constants
class AppStrings {
  AppStrings._();

  // App Info
  static const String appName = 'Altura POS';
  static const String appVersion = '1.0.0';

  // Authentication
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String username = 'Username';
  static const String password = 'Password';
  static const String enterUsername = 'Enter username';
  static const String enterPassword = 'Enter password';
  static const String invalidCredentials = 'Invalid username or password';
  static const String loginSuccess = 'Login successful';
  static const String logoutConfirmation = 'Are you sure you want to logout?';

  // Navigation
  static const String dashboard = 'Dashboard';
  static const String menu = 'Menu';
  static const String orders = 'Orders';
  static const String newOrder = 'New Order';
  static const String analytics = 'Analytics';
  static const String settings = 'Settings';

  // Order
  static const String dineIn = 'Dine In';
  static const String takeAway = 'Take Away';
  static const String tableNumber = 'Table Number';
  static const String enterTableNumber = 'Enter table number';
  static const String addToCart = 'Add to Cart';
  static const String cart = 'Cart';
  static const String emptyCart = 'Cart is empty';
  static const String emptyCartMessage = 'Add items to get started';
  static const String subtotal = 'Subtotal';
  static const String tax = 'Tax';
  static const String discount = 'Discount';
  static const String total = 'Total';
  static const String proceedToPayment = 'Proceed to Payment';
  static const String orderConfirmed = 'Order Confirmed';
  static const String orderCompleted = 'Order Completed';
  static const String orderCancelled = 'Order Cancelled';
  static const String cancelOrder = 'Cancel Order';
  static const String cancelOrderConfirmation = 
      'Are you sure you want to cancel this order?';

  // Menu
  static const String allCategories = 'All';
  static const String searchMenu = 'Search menu items...';
  static const String noItemsFound = 'No items found';
  static const String available = 'Available';
  static const String unavailable = 'Unavailable';
  static const String toggleAvailability = 'Toggle Availability';
  static const String menuItemUpdated = 'Menu item updated';

  // Payment
  static const String payment = 'Payment';
  static const String selectPaymentMethod = 'Select Payment Method';
  static const String cash = 'Cash';
  static const String qris = 'QRIS';
  static const String card = 'Card';
  static const String other = 'Other';
  static const String amountPaid = 'Amount Paid';
  static const String change = 'Change';
  static const String confirmPayment = 'Confirm Payment';
  static const String paymentSuccess = 'Payment Successful';
  static const String paymentFailed = 'Payment Failed';
  static const String insufficientAmount = 'Amount paid is less than total';

  // Receipt
  static const String receipt = 'Receipt';
  static const String printReceipt = 'Print Receipt';
  static const String shareReceipt = 'Share Receipt';
  static const String emailReceipt = 'Email Receipt';
  static const String thankYou = 'Thank you for your order!';

  // Sync
  static const String sync = 'Sync';
  static const String syncing = 'Syncing...';
  static const String syncComplete = 'Sync Complete';
  static const String syncFailed = 'Sync Failed';
  static const String lastSync = 'Last sync';
  static const String pendingSync = 'Pending sync';
  static const String online = 'Online';
  static const String offline = 'Offline';
  static const String pullToRefresh = 'Pull to refresh';

  // Analytics
  static const String todaySales = 'Today\'s Sales';
  static const String totalOrders = 'Total Orders';
  static const String avgOrderValue = 'Avg Order Value';
  static const String topSellingItems = 'Top Selling Items';
  static const String salesByCategory = 'Sales by Category';
  static const String salesByHour = 'Sales by Hour';
  static const String paymentMethodDistribution = 'Payment Methods';
  static const String exportReport = 'Export Report';

  // Settings
  static const String darkMode = 'Dark Mode';
  static const String autoSync = 'Auto Sync';
  static const String wifiOnly = 'WiFi Only';
  static const String notifications = 'Notifications';
  static const String language = 'Language';
  static const String about = 'About';

  // Error Messages
  static const String errorOccurred = 'An error occurred';
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'Unknown error occurred';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String ok = 'OK';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String add = 'Add';
  static const String update = 'Update';
  static const String close = 'Close';

  // Validation
  static const String fieldRequired = 'This field is required';
  static const String invalidEmail = 'Invalid email address';
  static const String invalidPhone = 'Invalid phone number';
  static const String passwordTooShort = 'Password must be at least 6 characters';

  // Empty States
  static const String noOrdersToday = 'No orders yet';
  static const String noOrdersTodayMessage = 'Orders will appear here';
  static const String noSearchResults = 'No results found';
  static const String noData = 'No data available';
}
