import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/phenixal_theme.dart';
import '../../core/route_diary_controller.dart';

class TrailTrackerScreen extends StatelessWidget {
  const TrailTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RouteDiaryController>();
    final progress = controller.stepProgressRatio;
    final percent = (progress * 100).toInt();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phenixal Trail Tracker'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: controller.gpsSimulationActive
                  ? PhenixalTheme.forestPrimary.withValues(alpha: 0.12)
                  : Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.gps_fixed,
                  size: 14,
                  color: controller.gpsSimulationActive
                      ? PhenixalTheme.forestPrimary
                      : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  controller.gpsSimulationActive ? 'GPS Live' : 'GPS Idle',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: controller.gpsSimulationActive
                        ? PhenixalTheme.forestPrimary
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Step Counter Ring
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [PhenixalTheme.forestPrimary, PhenixalTheme.forestDeep],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: PhenixalTheme.forestPrimary.withValues(alpha: 0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TODAY\'S HIKE PROGRESS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: Color(0xFFB0D5BE),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$percent%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 170,
                        height: 170,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 14,
                          strokeCap: StrokeCap.round,
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            PhenixalTheme.terraWarm,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.directions_walk_rounded,
                            color: Colors.white70,
                            size: 26,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.dailySteps.toString(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Goal: ${controller.dailyStepGoal}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatColumn(
                        label: 'EST. MILES',
                        value: '${controller.estimatedTrailMiles.toStringAsFixed(2)} mi',
                        icon: Icons.map_outlined,
                      ),
                      Container(width: 1, height: 32, color: Colors.white24),
                      _StatColumn(
                        label: 'CALORIES',
                        value: '${controller.estimatedCaloriesBurned} kcal',
                        icon: Icons.local_fire_department_outlined,
                      ),
                      Container(width: 1, height: 32, color: Colors.white24),
                      _StatColumn(
                        label: 'ELEVATION',
                        value: '${controller.totalElevationRecorded} ft',
                        icon: Icons.landscape_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Trail Stimulation Actions
            const Text(
              'Log Step Simulation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: PhenixalTheme.textDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StepButton(
                    title: '+500',
                    subtitle: 'Valley Walk',
                    icon: Icons.nature_people_outlined,
                    onTap: () => controller.addStepCount(500),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StepButton(
                    title: '+1,500',
                    subtitle: 'Ridge Hike',
                    icon: Icons.terrain_outlined,
                    onTap: () => controller.addStepCount(1500),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StepButton(
                    title: '+3,000',
                    subtitle: 'Alpine Climb',
                    icon: Icons.nordic_walking_outlined,
                    onTap: () => controller.addStepCount(3000),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Live Trail Telemetry Card
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
                            color: PhenixalTheme.terraOrange.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.explore_outlined,
                            color: PhenixalTheme.terraOrange,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Trail Cadence & Weather',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: PhenixalTheme.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _TelemetryItem(label: 'Avg Pace', val: '19m 20s / mi'),
                        _TelemetryItem(label: 'Trail Temp', val: '68°F Clear'),
                        _TelemetryItem(label: 'Heading', val: '284° WNW'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: PhenixalTheme.earthSand,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          PhenixalTheme.forestPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(controller.dailyStepGoal - controller.dailySteps).clamp(0, 99999)} steps remaining to achieve today\'s target.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: PhenixalTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatColumn({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: PhenixalTheme.terraWarm, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.65),
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PhenixalTheme.surfaceBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: PhenixalTheme.forestPrimary, size: 22),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: PhenixalTheme.forestPrimary,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: PhenixalTheme.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TelemetryItem extends StatelessWidget {
  final String label;
  final String val;

  const _TelemetryItem({required this.label, required this.val});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: PhenixalTheme.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          val,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: PhenixalTheme.textDark,
          ),
        ),
      ],
    );
  }
}
