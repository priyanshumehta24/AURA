import 'package:flutter/material.dart';

class GenZVibeCheckScreen extends StatelessWidget {
  const GenZVibeCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GenZ Vibe Check')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mood, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'Overall Team Vibe:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Chip(
                label: const Text('LOW RISK', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                backgroundColor: Colors.green.withOpacity(0.2),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              const SizedBox(height: 24),
              const Text(
                'Mock Data: The team is feeling good. No immediate burnout risk detected.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
