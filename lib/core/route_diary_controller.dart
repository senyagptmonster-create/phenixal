import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TrailDifficulty { easy, moderate, hard, expert }

class TrailRoute {
  final String id;
  final String name;
  final String region;
  final double distanceMiles;
  final int elevationGainFt;
  final TrailDifficulty difficulty;
  final int photosCount;
  final String completionDate;
  final String terrainNotes;
  final double rating;

  const TrailRoute({
    required this.id,
    required this.name,
    required this.region,
    required this.distanceMiles,
    required this.elevationGainFt,
    required this.difficulty,
    required this.photosCount,
    required this.completionDate,
    required this.terrainNotes,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'region': region,
      'distanceMiles': distanceMiles,
      'elevationGainFt': elevationGainFt,
      'difficulty': difficulty.index,
      'photosCount': photosCount,
      'completionDate': completionDate,
      'terrainNotes': terrainNotes,
      'rating': rating,
    };
  }

  factory TrailRoute.fromMap(Map<String, dynamic> map) {
    return TrailRoute(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? 'Untitled Trail',
      region: map['region'] as String? ?? 'Wilderness Area',
      distanceMiles: (map['distanceMiles'] as num?)?.toDouble() ?? 3.5,
      elevationGainFt: (map['elevationGainFt'] as num?)?.toInt() ?? 450,
      difficulty: TrailDifficulty.values[(map['difficulty'] as int? ?? 1).clamp(0, TrailDifficulty.values.length - 1)],
      photosCount: (map['photosCount'] as num?)?.toInt() ?? 0,
      completionDate: map['completionDate'] as String? ?? '2026-09-12',
      terrainNotes: map['terrainNotes'] as String? ?? 'Scenic overlook with pine needle footpaths.',
      rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
    );
  }
}

class ExplorerBadge {
  final String id;
  final String title;
  final String description;
  final String category;
  final int requiredCount;
  final bool isUnlocked;

  const ExplorerBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.requiredCount,
    required this.isUnlocked,
  });

  ExplorerBadge copyWith({bool? isUnlocked}) {
    return ExplorerBadge(
      id: id,
      title: title,
      description: description,
      category: category,
      requiredCount: requiredCount,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}

class RouteDiaryController extends ChangeNotifier {
  static const String _keyDailySteps = 'phenixal_daily_steps';
  static const String _keyStepGoal = 'phenixal_step_goal';
  static const String _keyGpsSim = 'phenixal_gps_sim';
  static const String _keyRoutesJson = 'phenixal_routes_json';
  static const String _keyUnlockedBadges = 'phenixal_unlocked_badges';

  int _dailySteps = 7840;
  int _dailyStepGoal = 10000;
  bool _gpsSimulationActive = true;
  bool _isLoading = true;

  List<TrailRoute> _routes = [];
  List<ExplorerBadge> _badges = [];

  int get dailySteps => _dailySteps;
  int get dailyStepGoal => _dailyStepGoal;
  bool get gpsSimulationActive => _gpsSimulationActive;
  bool get isLoading => _isLoading;
  List<TrailRoute> get routes => List.unmodifiable(_routes);
  List<ExplorerBadge> get badges => List.unmodifiable(_badges);

  double get estimatedTrailMiles => (_dailySteps * 0.000473).clamp(0.0, 999.0);
  int get estimatedCaloriesBurned => (_dailySteps * 0.043).round();
  double get stepProgressRatio => (_dailySteps / _dailyStepGoal).clamp(0.0, 1.0);

  int get totalElevationRecorded =>
      _routes.fold(0, (sum, route) => sum + route.elevationGainFt);

  double get totalMilesHiked =>
      _routes.fold(0.0, (sum, route) => sum + route.distanceMiles);

  RouteDiaryController() {
    _initBadges();
    _loadFromStorage();
  }

  void _initBadges() {
    _badges = [
      const ExplorerBadge(
        id: 'ridge_walker',
        title: 'Ridge Walker',
        description: 'Record over 5,000 daily trail steps.',
        category: 'Steps',
        requiredCount: 5000,
        isUnlocked: true,
      ),
      const ExplorerBadge(
        id: 'canopy_scout',
        title: 'Canopy Scout',
        description: 'Complete 3 routes in forest terrain.',
        category: 'Expeditions',
        requiredCount: 3,
        isUnlocked: true,
      ),
      const ExplorerBadge(
        id: 'summit_conqueror',
        title: 'Summit Conqueror',
        description: 'Climb a total elevation gain above 2,500 feet.',
        category: 'Elevation',
        requiredCount: 2500,
        isUnlocked: false,
      ),
      const ExplorerBadge(
        id: 'trail_photographer',
        title: 'Trail Photographer',
        description: 'Log 25 or more outdoor trail survey photos.',
        category: 'Survey',
        requiredCount: 25,
        isUnlocked: true,
      ),
      const ExplorerBadge(
        id: 'ultra_trekker',
        title: 'Ultra Trekker',
        description: 'Reach 15,000 steps in a single hiking session.',
        category: 'Endurance',
        requiredCount: 15000,
        isUnlocked: false,
      ),
      const ExplorerBadge(
        id: 'highland_pioneer',
        title: 'Highland Pioneer',
        description: 'Complete an Expert grade wilderness trail.',
        category: 'Mastery',
        requiredCount: 1,
        isUnlocked: false,
      ),
    ];
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _dailySteps = prefs.getInt(_keyDailySteps) ?? 7840;
      _dailyStepGoal = prefs.getInt(_keyStepGoal) ?? 10000;
      _gpsSimulationActive = prefs.getBool(_keyGpsSim) ?? true;

      final routesRaw = prefs.getString(_keyRoutesJson);
      if (routesRaw != null && routesRaw.isNotEmpty) {
        final List decoded = jsonDecode(routesRaw) as List;
        _routes = decoded.map((e) => TrailRoute.fromMap(e as Map<String, dynamic>)).toList();
      } else {
        _routes = [
          const TrailRoute(
            id: 'rt_101',
            name: 'Piedmont Pine Ridge Loop',
            region: 'Blackwood National Forest',
            distanceMiles: 6.4,
            elevationGainFt: 820,
            difficulty: TrailDifficulty.moderate,
            photosCount: 12,
            completionDate: '2026-09-14',
            terrainNotes: 'Crushed shale bed with continuous pine tree shade and switchbacks.',
            rating: 4.8,
          ),
          const TrailRoute(
            id: 'rt_102',
            name: 'Cedar Creek Canyon Run',
            region: 'Red Rock Highlands',
            distanceMiles: 4.2,
            elevationGainFt: 510,
            difficulty: TrailDifficulty.easy,
            photosCount: 8,
            completionDate: '2026-09-11',
            terrainNotes: 'Stream crossings with wet mossy boulders; hiking poles recommended.',
            rating: 4.6,
          ),
          const TrailRoute(
            id: 'rt_103',
            name: 'Eagle Bluff Precipice',
            region: 'Appalachian Spur',
            distanceMiles: 8.9,
            elevationGainFt: 1640,
            difficulty: TrailDifficulty.hard,
            photosCount: 19,
            completionDate: '2026-09-08',
            terrainNotes: 'Steep granite scramble on northern ridge with gusty crosswinds.',
            rating: 4.9,
          ),
        ];
      }

      final unlockedIds = prefs.getStringList(_keyUnlockedBadges) ?? ['ridge_walker', 'canopy_scout', 'trail_photographer'];
      _badges = _badges.map((b) => b.copyWith(isUnlocked: unlockedIds.contains(b.id))).toList();
    } catch (_) {
      // Fallback to defaults gracefully
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveRoutes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_routes.map((e) => e.toMap()).toList());
    await prefs.setString(_keyRoutesJson, jsonString);
  }

  Future<void> addStepCount(int steps) async {
    _dailySteps += steps;
    if (_dailySteps > 99999) _dailySteps = 99999;
    _checkMilestones();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyDailySteps, _dailySteps);
  }

  Future<void> updateStepGoal(int newGoal) async {
    _dailyStepGoal = newGoal.clamp(3000, 35000);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyStepGoal, _dailyStepGoal);
  }

  Future<void> setGpsSimulation(bool active) async {
    _gpsSimulationActive = active;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyGpsSim, _gpsSimulationActive);
  }

  Future<void> addRoute(TrailRoute route) async {
    _routes.insert(0, route);
    _checkMilestones();
    notifyListeners();
    await _saveRoutes();
  }

  Future<void> deleteRoute(String id) async {
    _routes.removeWhere((r) => r.id == id);
    notifyListeners();
    await _saveRoutes();
  }

  void _checkMilestones() {
    bool updated = false;
    final unlockedIds = <String>[];

    _badges = _badges.map((b) {
      bool unlock = b.isUnlocked;
      if (b.id == 'ridge_walker' && _dailySteps >= 5000) unlock = true;
      if (b.id == 'canopy_scout' && _routes.length >= 3) unlock = true;
      if (b.id == 'summit_conqueror' && totalElevationRecorded >= 2500) unlock = true;
      if (b.id == 'ultra_trekker' && _dailySteps >= 15000) unlock = true;
      if (b.id == 'highland_pioneer' && _routes.any((r) => r.difficulty == TrailDifficulty.expert)) unlock = true;

      if (unlock) unlockedIds.add(b.id);
      if (unlock != b.isUnlocked) updated = true;
      return b.copyWith(isUnlocked: unlock);
    }).toList();

    if (updated) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setStringList(_keyUnlockedBadges, unlockedIds);
      });
    }
  }

  Future<void> resetData() async {
    _dailySteps = 2400;
    _dailyStepGoal = 10000;
    _gpsSimulationActive = true;
    _routes.clear();
    _routes.add(
      const TrailRoute(
        id: 'rt_init',
        name: 'Whispering Pines Baseline Trail',
        region: 'Hearthstone Park',
        distanceMiles: 3.1,
        elevationGainFt: 320,
        difficulty: TrailDifficulty.easy,
        photosCount: 4,
        completionDate: '2026-09-15',
        terrainNotes: 'Soft moss-covered pathway with gentle elevation gradient.',
        rating: 4.7,
      ),
    );
    _initBadges();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _saveRoutes();
  }
}
