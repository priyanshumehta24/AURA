import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class OwnerCopilotScreen extends StatefulWidget {
  const OwnerCopilotScreen({super.key});

  @override
  State<OwnerCopilotScreen> createState() => _OwnerCopilotScreenState();
}

class _OwnerCopilotScreenState extends State<OwnerCopilotScreen> {
  final TextEditingController _dumpController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _briefResult;

  Future<void> _fetchBriefing() async {
    if (_dumpController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/owner-brief'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"dump": _dumpController.text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] == true) {
           _showError(data['message'] ?? 'Backend error');
        } else {
           setState(() => _briefResult = data);
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
      appBar: AppBar(title: const Text('Owner Co-Pilot')),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Dump input
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Brain Dump', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: TextField(
                      controller: _dumpController,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        hintText: 'Dump your stress, thoughts, and todos here...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _fetchBriefing,
                    icon: _isLoading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                      : const Icon(Icons.psychology),
                    label: const Text('Generate Co-Pilot Brief'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          // Right side: Results
          Expanded(
            flex: 2,
            child: _briefResult == null
              ? const Center(child: Text('Enter dump and generate brief', style: TextStyle(color: Colors.grey)))
              : _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final priorities = List<String>.from(_briefResult!['priorities'] ?? []);
    final delegate = List<String>.from(_briefResult!['delegate'] ?? []);
    final burnoutScore = _briefResult!['burnout_score'] ?? 0;
    final burnoutMsg = _briefResult!['burnout_message'] ?? '';
    final selfCare = _briefResult!['self_care'] ?? '';

    Color scoreColor = Colors.green;
    if (burnoutScore > 7) scoreColor = Colors.red;
    else if (burnoutScore > 4) scoreColor = Colors.orange;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Burnout Alert Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scoreColor.withOpacity(0.2),
            border: Border.all(color: scoreColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Burnout Score', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('\$burnoutScore/10', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: scoreColor)),
                ],
              ),
              const SizedBox(height: 8),
              Text(burnoutMsg),
              const SizedBox(height: 8),
              Text('Self Care: \$selfCare', style: const TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('7-Day Burnout Trend', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                      if (value.toInt() >= 0 && value.toInt() < days.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(days[value.toInt()], style: const TextStyle(fontSize: 12)),
                        );
                      }
                      return const Text('');
                    },
                    interval: 1,
                  ),
                ),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: 6,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 5),
                    FlSpot(1, 6),
                    FlSpot(2, 6),
                    FlSpot(3, 7),
                    FlSpot(4, 8),
                    FlSpot(5, 7),
                    FlSpot(6, 6),
                  ],
                  isCurved: true,
                  color: Colors.orangeAccent,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.orangeAccent.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Top Priorities', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...priorities.map((p) => ListTile(
          leading: const Icon(Icons.priority_high, color: Colors.redAccent),
          title: Text(p),
        )),
        const SizedBox(height: 24),
        const Text('To Delegate', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...delegate.map((d) => ListTile(
          leading: const Icon(Icons.arrow_forward_ios, color: Colors.orangeAccent),
          title: Text(d),
        )),
      ],
    );
  }
}
