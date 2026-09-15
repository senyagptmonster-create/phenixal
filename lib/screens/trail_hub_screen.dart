import 'package:flutter/material.dart';
import '../theme/phenixal_theme.dart';
import '../painters/elevation_profile_painter.dart';
import 'routes_diary_screen.dart';
import 'badges_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class TrailHubScreen extends StatelessWidget {
  const TrailHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phenixal Trail Explorer', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero card with elevation profile custom paint
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: PhenixalTheme.alpineCard,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Expanded(
                        child: Text('Current Expedition', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ),
                      Text('Pacific Crest Ridge',
                          style: TextStyle(fontWeight: FontWeight.bold, color: PhenixalTheme.trailEmerald)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('14.2 Miles Logged',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 90,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: ElevationProfilePainter(
                        elevations: [840, 920, 1150, 1080, 1340, 1480, 1260, 1580],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Trail Expeditions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 14),
            // Hub Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              children: [
                _HubCard(
                  icon: Icons.map,
                  title: 'Routes Diary',
                  subtitle: 'Saved pathways',
                  color: PhenixalTheme.trailEmerald,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RoutesDiaryScreen())),
                ),
                _HubCard(
                  icon: Icons.military_tech,
                  title: 'Peak Badges',
                  subtitle: '12 Summits',
                  color: PhenixalTheme.peakAmber,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BadgesScreen())),
                ),
                _HubCard(
                  icon: Icons.show_chart,
                  title: 'Elevation Log',
                  subtitle: '+2,480m gain',
                  color: const Color(0xFF48CAE4),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                ),
                _HubCard(
                  icon: Icons.tune,
                  title: 'Expedition Spec',
                  subtitle: 'GPS & Stride',
                  color: const Color(0xFFF77F00),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HubCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _HubCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: PhenixalTheme.alpineCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
