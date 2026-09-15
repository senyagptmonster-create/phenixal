import 'package:flutter/material.dart';
import '../theme/phenixal_theme.dart';

class RoutesDiaryScreen extends StatelessWidget {
  const RoutesDiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = [
      {'name': 'Desolation Wilderness Pass', 'miles': '11.4 mi', 'gain': '+640m'},
      {'name': 'Eagle Peak Summit Loop', 'miles': '8.2 mi', 'gain': '+920m'},
      {'name': 'Glacier Lake Basin', 'miles': '14.0 mi', 'gain': '+480m'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Routes Diary')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: routes.length,
        itemBuilder: (context, idx) {
          final r = routes[idx];
          return Card(
            color: PhenixalTheme.alpineCard,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.terrain, color: PhenixalTheme.trailEmerald),
              title: Text(r['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${r['miles']} • ${r['gain']} elevation gain'),
            ),
          );
        },
      ),
    );
  }
}
