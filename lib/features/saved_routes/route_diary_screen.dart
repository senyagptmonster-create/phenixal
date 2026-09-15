import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/phenixal_theme.dart';
import '../../core/route_diary_controller.dart';

class RouteDiaryScreen extends StatefulWidget {
  const RouteDiaryScreen({super.key});

  @override
  State<RouteDiaryScreen> createState() => _RouteDiaryScreenState();
}

class _RouteDiaryScreenState extends State<RouteDiaryScreen> {
  TrailDifficulty? _filterDifficulty;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RouteDiaryController>();
    final routes = controller.routes.where((r) {
      if (_filterDifficulty == null) return true;
      return r.difficulty == _filterDifficulty;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trail Route Diary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: PhenixalTheme.forestPrimary, size: 28),
            tooltip: 'Log New Trail',
            onPressed: () => _showAddRouteSheet(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Difficulty Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All Trails'),
                  selected: _filterDifficulty == null,
                  onSelected: (selected) {
                    setState(() => _filterDifficulty = null);
                  },
                  selectedColor: PhenixalTheme.forestPrimary.withValues(alpha: 0.15),
                  checkmarkColor: PhenixalTheme.forestPrimary,
                ),
                const SizedBox(width: 8),
                ...TrailDifficulty.values.map((diff) {
                  final isSelected = _filterDifficulty == diff;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(diff.name.toUpperCase()),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _filterDifficulty = selected ? diff : null;
                        });
                      },
                      selectedColor: _getDifficultyColor(diff).withValues(alpha: 0.18),
                      checkmarkColor: _getDifficultyColor(diff),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Routes list summary banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${routes.length} Recorded Expeditions',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: PhenixalTheme.textMuted,
                  ),
                ),
                Text(
                  'Total ${controller.totalMilesHiked.toStringAsFixed(1)} mi',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: PhenixalTheme.forestPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Route Cards List
          Expanded(
            child: routes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.terrain, size: 56, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        const Text(
                          'No trail routes in this category.',
                          style: TextStyle(color: PhenixalTheme.textMuted, fontSize: 15),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: routes.length,
                    itemBuilder: (context, index) {
                      final route = routes[index];
                      return _RouteCard(
                        route: route,
                        onDelete: () => controller.deleteRoute(route.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRouteSheet(context),
        backgroundColor: PhenixalTheme.forestPrimary,
        icon: const Icon(Icons.add_location_alt_outlined, color: Colors.white),
        label: const Text('Log Hike', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Color _getDifficultyColor(TrailDifficulty diff) {
    switch (diff) {
      case TrailDifficulty.easy:
        return const Color(0xFF2E7D32);
      case TrailDifficulty.moderate:
        return const Color(0xFFE65100);
      case TrailDifficulty.hard:
        return const Color(0xFFC62828);
      case TrailDifficulty.expert:
        return const Color(0xFF6A1B9A);
    }
  }

  void _showAddRouteSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final regionCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    double distance = 5.0;
    double elevation = 600.0;
    TrailDifficulty selectedDiff = TrailDifficulty.moderate;
    int photoCount = 6;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Log Trail Expedition',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: PhenixalTheme.textDark,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Trail / Ridge Name',
                        prefixIcon: Icon(Icons.hiking, color: PhenixalTheme.forestPrimary),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: regionCtrl,
                      decoration: const InputDecoration(
                        labelText: 'National Park / Region',
                        prefixIcon: Icon(Icons.place_outlined, color: PhenixalTheme.forestPrimary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Distance: ${distance.toStringAsFixed(1)} miles',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Slider(
                      value: distance,
                      min: 0.5,
                      max: 25.0,
                      divisions: 49,
                      activeColor: PhenixalTheme.forestPrimary,
                      onChanged: (val) => setSheetState(() => distance = val),
                    ),
                    Text(
                      'Elevation Gain: ${elevation.toInt()} ft',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Slider(
                      value: elevation,
                      min: 50.0,
                      max: 5000.0,
                      divisions: 99,
                      activeColor: PhenixalTheme.terraOrange,
                      onChanged: (val) => setSheetState(() => elevation = val),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Difficulty: ', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        DropdownButton<TrailDifficulty>(
                          value: selectedDiff,
                          items: TrailDifficulty.values.map((d) {
                            return DropdownMenuItem(
                              value: d,
                              child: Text(d.name.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setSheetState(() => selectedDiff = val);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Photos Captured: ', style: TextStyle(fontWeight: FontWeight.w600)),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: photoCount > 0 ? () => setSheetState(() => photoCount--) : null,
                        ),
                        Text('$photoCount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setSheetState(() => photoCount++),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: notesCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Terrain notes & landmarks',
                        prefixIcon: Icon(Icons.notes, color: PhenixalTheme.forestPrimary),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final title = nameCtrl.text.trim().isEmpty ? 'Highland Trail' : nameCtrl.text.trim();
                          final reg = regionCtrl.text.trim().isEmpty ? 'Highland Wilderness' : regionCtrl.text.trim();
                          final notes = notesCtrl.text.trim().isEmpty ? 'Rugged rocky paths with scenic vistas.' : notesCtrl.text.trim();

                          final newRoute = TrailRoute(
                            id: 'rt_${DateTime.now().millisecondsSinceEpoch}',
                            name: title,
                            region: reg,
                            distanceMiles: distance,
                            elevationGainFt: elevation.toInt(),
                            difficulty: selectedDiff,
                            photosCount: photoCount,
                            completionDate: DateTime.now().toIso8601String().substring(0, 10),
                            terrainNotes: notes,
                            rating: 4.8,
                          );

                          context.read<RouteDiaryController>().addRoute(newRoute);
                          Navigator.pop(ctx);
                        },
                        child: const Text('Save to Route Diary'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _RouteCard extends StatelessWidget {
  final TrailRoute route;
  final VoidCallback onDelete;

  const _RouteCard({required this.route, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    route.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: PhenixalTheme.textDark,
                    ),
                  ),
                ),
                _DifficultyBadge(difficulty: route.difficulty),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_pin, size: 14, color: PhenixalTheme.terraOrange),
                const SizedBox(width: 4),
                Text(
                  route.region,
                  style: const TextStyle(
                    fontSize: 12,
                    color: PhenixalTheme.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  route.completionDate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: PhenixalTheme.textMuted,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _RouteMetric(
                  icon: Icons.straighten,
                  value: '${route.distanceMiles.toStringAsFixed(1)} mi',
                  label: 'Distance',
                ),
                _RouteMetric(
                  icon: Icons.trending_up,
                  value: '+${route.elevationGainFt} ft',
                  label: 'Elevation',
                ),
                _RouteMetric(
                  icon: Icons.camera_alt_outlined,
                  value: '${route.photosCount}',
                  label: 'Photos',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Trail Log?'),
                        content: Text('Remove "${route.name}" from your diary?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () {
                              Navigator.pop(ctx);
                              onDelete();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            if (route.terrainNotes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: PhenixalTheme.earthSand,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  route.terrainNotes,
                  style: const TextStyle(
                    fontSize: 12,
                    color: PhenixalTheme.textDark,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final TrailDifficulty difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (difficulty) {
      case TrailDifficulty.easy:
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        break;
      case TrailDifficulty.moderate:
        bg = const Color(0xFFFFF3E0);
        fg = const Color(0xFFE65100);
        break;
      case TrailDifficulty.hard:
        bg = const Color(0xFFFFEBEE);
        fg = const Color(0xFFC62828);
        break;
      case TrailDifficulty.expert:
        bg = const Color(0xFFF3E5F5);
        fg = const Color(0xFF6A1B9A);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        difficulty.name.toUpperCase(),
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RouteMetric extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _RouteMetric({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: PhenixalTheme.forestPrimary),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: PhenixalTheme.textDark,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: PhenixalTheme.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
