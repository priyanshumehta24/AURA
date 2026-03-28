import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded mock data
    final mockInventory = [
      {'item': 'Coffee Beans', 'status': 'Low Stock', 'suggestion': 'Order 10kg soon'},
      {'item': 'Milk', 'status': 'Sufficient', 'suggestion': 'No action needed'},
      {'item': 'Sugar', 'status': 'Critical', 'suggestion': 'Order immediately'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Predictor')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockInventory.length,
        itemBuilder: (context, index) {
          final item = mockInventory[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.inventory_2),
              title: Text(item['item']!),
              subtitle: Text(item['suggestion']!),
              trailing: Chip(
                label: Text(item['status']!),
                backgroundColor: item['status'] == 'Critical'
                    ? Colors.red.withOpacity(0.2)
                    : item['status'] == 'Low Stock'
                        ? Colors.orange.withOpacity(0.2)
                        : Colors.green.withOpacity(0.2),
              ),
            ),
          );
        },
      ),
    );
  }
}
