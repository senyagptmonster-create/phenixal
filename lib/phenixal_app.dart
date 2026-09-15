import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/phenixal_theme.dart';
import 'core/route_diary_controller.dart';
import 'features/trail_dashboard/trail_tracker_screen.dart';
import 'features/saved_routes/route_diary_screen.dart';
import 'features/milestones/explorer_badges_screen.dart';
import 'features/settings/trail_settings_screen.dart';

class PhenixalApp extends StatelessWidget {
  const PhenixalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RouteDiaryController(),
      child: MaterialApp(
        title: 'Phenixal Trail Explorer',
        debugShowCheckedModeBanner: false,
        theme: PhenixalTheme.themeData,
        home: const _PhenixalNavigationHost(),
      ),
    );
  }
}

class _PhenixalNavigationHost extends StatefulWidget {
  const _PhenixalNavigationHost();

  @override
  State<_PhenixalNavigationHost> createState() => _PhenixalNavigationHostState();
}

class _PhenixalNavigationHostState extends State<_PhenixalNavigationHost> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TrailTrackerScreen(),
    RouteDiaryScreen(),
    ExplorerBadgesScreen(),
    TrailSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk_outlined),
            activeIcon: Icon(Icons.directions_walk),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Routes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.military_tech_outlined),
            activeIcon: Icon(Icons.military_tech),
            label: 'Badges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tune_outlined),
            activeIcon: Icon(Icons.tune),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
