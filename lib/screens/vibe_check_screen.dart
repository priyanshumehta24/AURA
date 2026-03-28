import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GenZVibeCheckScreen extends StatefulWidget {
  const GenZVibeCheckScreen({super.key});

  @override
  State<GenZVibeCheckScreen> createState() => _GenZVibeCheckScreenState();
}

class _GenZVibeCheckScreenState extends State<GenZVibeCheckScreen> {
  bool _isLoading = false;
  List<dynamic>? _riskFlags;

  Future<void> _fetchVibeCheck() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/vibe-check'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "responses": [
            {"name": "Riya", "q1": "feeling low", "q2": "ignored", "q3": "thinking of leaving"},
            {"name": "Sam", "q1": "good", "q2": "supported", "q3": "happy here"}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] == true) {
           _showError(data['message'] ?? 'Backend error');
        } else {
           setState(() => _riskFlags = data['risk_flags']);
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
      appBar: AppBar(title: const Text('GenZ Vibe Check')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _fetchVibeCheck,
              icon: _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                : const Icon(Icons.groups),
              label: const Text('Analyze Weekly Survey Responses'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _riskFlags == null
                  ? const Center(child: Text('Click analyze to fetch vibe check.', style: TextStyle(color: Colors.grey)))
                  : _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    return ListView.builder(
      itemCount: _riskFlags!.length,
      itemBuilder: (context, index) {
        final flag = _riskFlags![index] as Map<String, dynamic>;
        final risk = flag['risk'] ?? 'UNKNOWN';
        
        Color chipColor = Colors.grey;
        if (risk == 'HIGH') chipColor = Colors.red;
        else if (risk == 'MEDIUM') chipColor = Colors.orange;
        else if (risk == 'LOW') chipColor = Colors.green;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: chipColor.withOpacity(0.2),
              child: Icon(Icons.person, color: chipColor),
            ),
            title: Text(flag['name'] ?? 'Unknown'),
            subtitle: Text(flag['action'] ?? ''),
            trailing: Chip(
              label: Text(risk, style: const TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: chipColor.withOpacity(0.3),
            ),
          ),
        );
      },
    );
  }
}
