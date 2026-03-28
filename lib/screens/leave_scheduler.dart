import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaveSchedulerScreen extends StatefulWidget {
  const LeaveSchedulerScreen({super.key});

  @override
  State<LeaveSchedulerScreen> createState() => _LeaveSchedulerScreenState();
}

class _LeaveSchedulerScreenState extends State<LeaveSchedulerScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _scheduleResult;

  Future<void> _generateSchedule() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/schedule-leave'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "staff_names": ["Riya", "Sam", "Dev", "Arjun"],
          "week_days": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] == true) {
           _showError(data['message'] ?? 'Backend error');
        } else {
           setState(() => _scheduleResult = data);
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
      appBar: AppBar(title: const Text('Leave Scheduler')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _generateSchedule,
              icon: _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                : const Icon(Icons.auto_awesome),
              label: const Text('Auto-Generate Schedule via Gemini'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
          ),
          if (_scheduleResult != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _scheduleResult!['note'] ?? '',
                style: const TextStyle(color: Colors.orangeAccent, fontStyle: FontStyle.italic),
              ),
            ),
          Expanded(
            child: _scheduleResult == null
              ? const Center(child: Text('Click auto-generate to create schedule.', style: TextStyle(color: Colors.grey)))
              : _buildScheduleList(),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleList() {
    final schedule = _scheduleResult!['schedule'] as Map<String, dynamic>? ?? {};
    final days = schedule.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        final dayData = schedule[day] as Map<String, dynamic>;
        final working = List<String>.from(dayData['working'] ?? []);
        final off = List<String>.from(dayData['off'] ?? []);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            title: Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('\${working.length} working, \${off.length} off'),
            children: [
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Working'),
                subtitle: Text(working.join(', ')),
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.redAccent),
                title: const Text('Off/Leave'),
                subtitle: Text(off.join(', ')),
              ),
            ],
          ),
        );
      },
    );
  }
}
