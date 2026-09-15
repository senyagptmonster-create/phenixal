import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/phenixal_theme.dart';
import '../../core/route_diary_controller.dart';

class TrailSettingsScreen extends StatefulWidget {
  const TrailSettingsScreen({super.key});

  @override
  State<TrailSettingsScreen> createState() => _TrailSettingsScreenState();
}

class _TrailSettingsScreenState extends State<TrailSettingsScreen> {
  String _distanceUnit = 'Miles (mi)';
  String _elevationUnit = 'Feet (ft)';
  bool _offlineCache = true;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RouteDiaryController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trail Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Step Target Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: PhenixalTheme.forestPrimary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.flag_outlined,
                          color: PhenixalTheme.forestPrimary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Daily Step Goal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: PhenixalTheme.textDark,
                              ),
                            ),
                            Text(
                              'Target cadence for hiking & trail walks',
                              style: TextStyle(fontSize: 12, color: PhenixalTheme.textMuted),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${controller.dailyStepGoal}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: PhenixalTheme.forestPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: controller.dailyStepGoal.toDouble(),
                    min: 4000,
                    max: 30000,
                    divisions: 26,
                    activeColor: PhenixalTheme.forestPrimary,
                    label: '${controller.dailyStepGoal} steps',
                    onChanged: (val) {
                      controller.updateStepGoal(val.toInt());
                    },
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('4k Steps', style: TextStyle(fontSize: 11, color: PhenixalTheme.textMuted)),
                      Text('Target Range', style: TextStyle(fontSize: 11, color: PhenixalTheme.textMuted)),
                      Text('30k Steps', style: TextStyle(fontSize: 11, color: PhenixalTheme.textMuted)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Navigation & GPS Emulation
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sensors & Telemetry',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: PhenixalTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('GPS Simulation', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Emulate satellite trail coordinates without hardware drain'),
                    value: controller.gpsSimulationActive,
                    activeTrackColor: PhenixalTheme.forestPrimary,
                    onChanged: (val) => controller.setGpsSimulation(val),
                  ),
                  const Divider(),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Offline Topo Caching', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Store contour lines and elevation vectors locally'),
                    value: _offlineCache,
                    activeTrackColor: PhenixalTheme.forestPrimary,
                    onChanged: (val) => setState(() => _offlineCache = val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Measurement Units
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trail Measurement Units',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: PhenixalTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Distance Metric'),
                    trailing: DropdownButton<String>(
                      value: _distanceUnit,
                      underline: const SizedBox(),
                      items: ['Miles (mi)', 'Kilometers (km)'].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _distanceUnit = val);
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Elevation Metric'),
                    trailing: DropdownButton<String>(
                      value: _elevationUnit,
                      underline: const SizedBox(),
                      items: ['Feet (ft)', 'Meters (m)'].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _elevationUnit = val);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Reset and Maintenance
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Expedition Data Management',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: PhenixalTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Clear local routes, reset milestone badges and restore initial trail calibration.',
                    style: TextStyle(fontSize: 12, color: PhenixalTheme.textMuted),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: () => _confirmReset(context, controller),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    icon: const Icon(Icons.restore_outlined),
                    label: const Text('Reset All Trail Logs'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // About Phenixal
          Center(
            child: Column(
              children: [
                const Icon(Icons.nature, color: PhenixalTheme.forestPrimary, size: 28),
                const SizedBox(height: 6),
                const Text(
                  'Phenixal Trail Explorer v3.2.0',
                  style: TextStyle(fontWeight: FontWeight.w600, color: PhenixalTheme.textMuted, fontSize: 13),
                ),
                Text(
                  'Feature-First Outdoor Navigation Engine',
                  style: TextStyle(color: PhenixalTheme.textMuted.withValues(alpha: 0.7), fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, RouteDiaryController controller) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Trail Data?'),
        content: const Text('This will reset your recorded steps, diary routes, and milestones back to initial trail defaults.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              controller.resetData();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Trail diary restored to baseline.')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
