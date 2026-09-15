import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/phenixal_theme.dart';
import '../../core/route_diary_controller.dart';

class ExplorerBadgesScreen extends StatefulWidget {
  const ExplorerBadgesScreen({super.key});

  @override
  State<ExplorerBadgesScreen> createState() => _ExplorerBadgesScreenState();
}

class _ExplorerBadgesScreenState extends State<ExplorerBadgesScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RouteDiaryController>();
    final allBadges = controller.badges;
    final unlockedCount = allBadges.where((b) => b.isUnlocked).length;
    final progressPercent = ((unlockedCount / allBadges.length) * 100).toInt();

    final filtered = allBadges.where((b) {
      if (_filter == 'Unlocked') return b.isUnlocked;
      if (_filter == 'Locked') return !b.isUnlocked;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorer Badges'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [PhenixalTheme.forestPrimary, Color(0xFF285438)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: PhenixalTheme.forestPrimary.withValues(alpha: 0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: PhenixalTheme.terraOrange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: PhenixalTheme.terraOrange.withValues(alpha: 0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.military_tech,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Trail Honor Rank',
                          style: TextStyle(
                            color: Color(0xFFB4D8C2),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$unlockedCount of ${allBadges.length} Badges Earned',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: unlockedCount / allBadges.length,
                            minHeight: 6,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              PhenixalTheme.terraWarm,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$progressPercent% Completed',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Filter Tabs
            Row(
              children: ['All', 'Unlocked', 'Locked'].map((filterName) {
                final isSelected = _filter == filterName;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filterName),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _filter = filterName);
                    },
                    selectedColor: PhenixalTheme.forestPrimary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : PhenixalTheme.textDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Grid of Badges
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.86,
              ),
              itemBuilder: (context, index) {
                final badge = filtered[index];
                return _BadgeItemCard(
                  badge: badge,
                  onTap: () => _showBadgeDetailDialog(context, badge),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetailDialog(BuildContext context, ExplorerBadge badge) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              badge.isUnlocked ? Icons.verified : Icons.lock_outline,
              color: badge.isUnlocked ? PhenixalTheme.terraOrange : Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                badge.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: PhenixalTheme.forestPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Category: ${badge.category}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: PhenixalTheme.forestPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              badge.description,
              style: const TextStyle(fontSize: 14, color: PhenixalTheme.textDark),
            ),
            const SizedBox(height: 16),
            Text(
              badge.isUnlocked
                  ? 'Status: Achieved & recorded in your trail honor roll.'
                  : 'Status: In Progress. Continue hiking to unlock.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: badge.isUnlocked ? Colors.green.shade700 : Colors.orange.shade800,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _BadgeItemCard extends StatelessWidget {
  final ExplorerBadge badge;
  final VoidCallback onTap;

  const _BadgeItemCard({required this.badge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: badge.isUnlocked ? PhenixalTheme.terraWarm.withValues(alpha: 0.4) : PhenixalTheme.surfaceBorder,
            width: badge.isUnlocked ? 1.5 : 1.0,
          ),
          boxShadow: badge.isUnlocked
              ? [
                  BoxShadow(
                    color: PhenixalTheme.terraOrange.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badge.isUnlocked
                    ? PhenixalTheme.terraOrange.withValues(alpha: 0.15)
                    : Colors.grey.withValues(alpha: 0.12),
              ),
              child: Icon(
                badge.isUnlocked ? Icons.workspace_premium_rounded : Icons.lock_clock,
                size: 28,
                color: badge.isUnlocked ? PhenixalTheme.terraOrange : Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              badge.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: badge.isUnlocked ? PhenixalTheme.textDark : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              badge.category,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: badge.isUnlocked ? PhenixalTheme.forestPrimary : Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: badge.isUnlocked ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge.isUnlocked ? 'Unlocked' : 'Locked',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: badge.isUnlocked ? const Color(0xFF2E7D32) : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
