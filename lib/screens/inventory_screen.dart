import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _prediction;

  Future<void> _fetchPrediction() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/predict-inventory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "day_type": "weekday",
          "items_used_yesterday": "5kg coffee, 2kg milk",
          "current_stock": "1kg coffee, 0.5kg milk"
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] == true) {
           _showError(data['message'] ?? 'Backend error');
        } else {
           setState(() => _prediction = data);
        }
      } else {
        _showError('Server returned status ${response.statusCode}');
      }
    } catch (e) {
      _showError('Connection failed: \$e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Predictor')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _fetchPrediction,
              icon: _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                : const Icon(Icons.analytics),
              label: const Text('Predict Needs via Gemini'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _prediction == null
                  ? const Center(child: Text('Click predict to see suggestions.', style: TextStyle(color: Colors.grey)))
                  : _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    final orderList = List<String>.from(_prediction!['order_list'] ?? []);
    final staff = _prediction!['staff_needed']?.toString() ?? 'N/A';
    final shift = _prediction!['shift_times'] ?? 'N/A';
    final reason = _prediction!['reason'] ?? 'N/A';

    return ListView(
      children: [
        SelectableText('Reasoning: \$reason', style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.blueAccent)),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.people),
          title: const Text('Staff Needed'),
          trailing: Text(staff, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ListTile(
          leading: const Icon(Icons.schedule),
          title: const Text('Shift Times'),
          trailing: Text(shift, style: const TextStyle(fontSize: 16)),
        ),
        const Divider(),
        const Text('Items to Order:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...orderList.map((item) => Card(
          child: ListTile(
            leading: const Icon(Icons.inventory_2),
            title: Text(item),
            trailing: const Chip(label: Text('Critical'), backgroundColor: Colors.red),
          ),
        )),
      ],
    );
  }
}
