import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhenixalStore extends ChangeNotifier {
  int steps = 0;
  double miles = 0.0;
  List<dynamic> routes = [];
  List<dynamic> milestones = [];

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('phenixal_data');
    if (data != null) {
      final json = jsonDecode(data);
      steps = json['daily_steps'] ?? 0;
      miles = json['miles_walked'] ?? 0.0;
      routes = json['saved_routes'] ?? [];
      milestones = json['milestones'] ?? [];
    } else {
      steps = 8500;
      miles = 3.4;
      routes = [
        {"name": "Morning Park Loop", "distance": 2.1, "elevation": "Flat"},
        {"name": "Hillside Trail", "distance": 4.5, "elevation": "Steep"}
      ];
      milestones = [
        {"title": "First 10k Steps", "unlocked": true},
        {"title": "Mountain Climber", "unlocked": false}
      ];
    }
    notifyListeners();
  }
}
