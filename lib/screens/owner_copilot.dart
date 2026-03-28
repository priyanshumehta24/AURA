import 'package:flutter/material.dart';

class OwnerCopilotScreen extends StatelessWidget {
  const OwnerCopilotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Owner Co-Pilot & Vibe Check')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Staff Vibe Check'),
            const SizedBox(height: 8),
            _buildVibeCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('Burnout Trend (Coming Soon)'),
            const SizedBox(height: 8),
            _buildPlaceholderChartCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('Daily Briefing'),
            const SizedBox(height: 8),
            _buildBriefingCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildVibeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Overall Team Mood:', style: TextStyle(fontSize: 16)),
                Chip(
                  label: Text('MEDIUM RISK'),
                  backgroundColor: Colors.yellow,
                  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Mock Data: Team seems slightly stressed due to upcoming holidays. Consider a team building activity.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Run Vibe Check Analysis'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderChartCard() {
    return Card(
      child: Container(
        height: 150,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: const Text(
          'Chart Placeholder\n(Will be replaced in T-5)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildBriefingCard() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '''Good Morning, Boss!
- Inventory: You need to restock Sugar today.
- Staff: Alice is on leave. Bob might be covering her shift.
- Action items: Review pending leave request for Bob.''',
          style: TextStyle(height: 1.5),
        ),
      ),
    );
  }
}
