import 'package:flutter/material.dart';
import 'screens/home_dashboard.dart';

void main() {
  runApp(const AuraOSApp());
}

class AuraOSApp extends StatelessWidget {
  const AuraOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aura OS',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const HomeDashboard(),
    );
  }
}
