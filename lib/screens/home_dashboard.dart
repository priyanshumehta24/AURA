import 'package:flutter/material.dart';
import 'inventory_screen.dart';
import 'leave_scheduler.dart';
import 'owner_copilot.dart';
import 'vibe_check_screen.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aura OS Dashboard')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            alignment: WrapAlignment.center,
            children: [
              _buildDashboardCard(
                context,
                title: 'Inventory',
                icon: Icons.inventory,
                color: Colors.blueAccent,
                destination: const InventoryScreen(),
              ),
              _buildDashboardCard(
                context,
                title: 'Leave Scheduler',
                icon: Icons.calendar_today,
                color: Colors.orangeAccent,
                destination: const LeaveSchedulerScreen(),
              ),
              _buildDashboardCard(
                context,
                title: 'Owner Co-Pilot',
                icon: Icons.flight_takeoff,
                color: Colors.greenAccent,
                destination: const OwnerCopilotScreen(),
              ),
              _buildDashboardCard(
                context,
                title: 'GenZ Vibe Check',
                icon: Icons.emoji_people, // People/emoji icon
                color: Colors.green, // Green color
                destination: const GenZVibeCheckScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget destination,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 200,
          height: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color.withOpacity(0.3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
