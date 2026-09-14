import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/brand.dart';
import '../app/theme.dart';
import 'phenixal_store.dart';

class PhenixalDashboardScreen extends StatelessWidget {
  const PhenixalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<PhenixalStore>();
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(title: Text('Phenixal Hub', style: AppTheme.display(cInk)), backgroundColor: cSurface),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Steps: ${store.steps}', style: AppTheme.text(cInk)),
            Text('Miles: ${store.miles}', style: AppTheme.text(cInk)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedRoutesScreen()));
              },
              child: const Text('Saved Routes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MilestonesScreen()));
              },
              child: const Text('Milestone Badges'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ExplorerSettingsScreen()));
              },
              child: const Text('Explorer Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class SavedRoutesScreen extends StatelessWidget {
  const SavedRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<PhenixalStore>();
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(title: Text('Saved Routes', style: AppTheme.text(cInk)), backgroundColor: cSurface),
      body: ListView.builder(
        itemCount: store.routes.length,
        itemBuilder: (context, index) {
          final route = store.routes[index];
          return ListTile(
            title: Text(route['name'], style: AppTheme.text(cInk)),
            subtitle: Text('${route['distance']} miles - ${route['elevation']}', style: AppTheme.text(cInk)),
          );
        },
      ),
    );
  }
}

class MilestonesScreen extends StatelessWidget {
  const MilestonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<PhenixalStore>();
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(title: Text('Milestone Badges', style: AppTheme.text(cInk)), backgroundColor: cSurface),
      body: ListView.builder(
        itemCount: store.milestones.length,
        itemBuilder: (context, index) {
          final m = store.milestones[index];
          return ListTile(
            title: Text(m['title'], style: AppTheme.text(cInk)),
            trailing: Icon(m['unlocked'] ? Icons.check_circle : Icons.lock, color: cAccent),
          );
        },
      ),
    );
  }
}

class ExplorerSettingsScreen extends StatelessWidget {
  const ExplorerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(title: Text('Explorer Settings', style: AppTheme.text(cInk)), backgroundColor: cSurface),
      body: Center(
        child: Text('Settings Content', style: AppTheme.text(cInk)),
      ),
    );
  }
}
