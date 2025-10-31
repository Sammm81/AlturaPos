import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:altura_pos/core/constants/app_strings.dart';
import 'package:altura_pos/presentation/theme/app_theme.dart';
import 'package:altura_pos/presentation/screens/splash/splash_screen.dart';
import 'package:altura_pos/presentation/screens/auth/login_screen.dart';
import 'package:altura_pos/presentation/screens/menu/menu_screen.dart';
import 'package:altura_pos/presentation/screens/order/order_screen.dart';
import 'package:altura_pos/presentation/screens/payment/payment_screen.dart';
import 'package:altura_pos/presentation/screens/receipt/receipt_screen.dart';
import 'package:altura_pos/core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  Logger.logInfo('Application starting...');

  // Run app with Riverpod
  runApp(
    const ProviderScope(
      child: AlturaApp(),
    ),
  );
}

class AlturaApp extends StatelessWidget {
  const AlturaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/menu': (context) => const MenuScreen(),
        '/order': (context) => const OrderScreen(),
        '/payment': (context) => const PaymentScreen(),
        '/receipt': (context) => const ReceiptScreen(),
      },
    );
  }
}

/// Dashboard screen with navigation to main features
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Navigate to login
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _DashboardCard(
              icon: Icons.shopping_cart,
              title: AppStrings.newOrder,
              color: theme.colorScheme.primary,
              onTap: () => Navigator.of(context).pushNamed('/order'),
            ),
            _DashboardCard(
              icon: Icons.restaurant_menu,
              title: AppStrings.menu,
              color: theme.colorScheme.secondary,
              onTap: () => Navigator.of(context).pushNamed('/menu'),
            ),
            _DashboardCard(
              icon: Icons.receipt_long,
              title: AppStrings.orders,
              color: Colors.orange,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Orders history - Coming soon')),
                );
              },
            ),
            _DashboardCard(
              icon: Icons.analytics,
              title: AppStrings.analytics,
              color: Colors.green,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Analytics - Coming soon')),
                );
              },
            ),
            _DashboardCard(
              icon: Icons.settings,
              title: AppStrings.settings,
              color: Colors.blueGrey,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings - Coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.7),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
