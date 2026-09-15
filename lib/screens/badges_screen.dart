import 'package:flutter/material.dart';
import '../theme/phenixal_theme.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explorer Badges')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.stars, color: PhenixalTheme.peakAmber),
            title: Text('High Altitude Nomad'),
            subtitle: Text('Climbed over 3,000 vertical meters cumulative'),
          ),
          ListTile(
            leading: Icon(Icons.stars, color: PhenixalTheme.peakAmber),
            title: Text('100-Mile Thru-Hiker'),
            subtitle: Text('Completed 100 trail miles across single season'),
          ),
        ],
      ),
    );
  }
}
