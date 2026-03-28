import 'package:flutter/material.dart';

class LeaveSchedulerScreen extends StatelessWidget {
  const LeaveSchedulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded mock data
    final mockLeaves = [
      {'name': 'Alice', 'dates': 'Oct 10 - Oct 12', 'status': 'Approved'},
      {'name': 'Bob', 'dates': 'Oct 15 - Oct 16', 'status': 'Pending'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Leave Scheduler')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Request Leave'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: mockLeaves.length,
              itemBuilder: (context, index) {
                final leave = mockLeaves[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(leave['name']!),
                    subtitle: Text(leave['dates']!),
                    trailing: Chip(
                      label: Text(leave['status']!),
                      backgroundColor: leave['status'] == 'Approved'
                          ? Colors.green.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
