import 'package:flutter/material.dart';

class SelectItemScreen extends StatelessWidget {
  const SelectItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample menu items
    final List<Map<String, dynamic>> menuItems = [
      {'name': 'Burger', 'price': 5.99, 'icon': Icons.lunch_dining},
      {'name': 'Pizza', 'price': 8.99, 'icon': Icons.local_pizza},
      {'name': 'Coffee', 'price': 2.99, 'icon': Icons.local_cafe},
      {'name': 'Salad', 'price': 4.99, 'icon': Icons.set_meal},
      {'name': 'Pasta', 'price': 7.99, 'icon': Icons.ramen_dining},
      {'name': 'Soda', 'price': 1.99, 'icon': Icons.local_drink},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Item'),
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(
                item['icon'] as IconData,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                item['name'] as String,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                '\$${(item['price'] as double).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Navigator.pop(context, item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item['name']} added to order'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
