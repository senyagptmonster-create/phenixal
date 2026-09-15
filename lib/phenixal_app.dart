import 'package:flutter/material.dart';
import 'theme/phenixal_theme.dart';
import 'screens/trail_hub_screen.dart';

class PhenixalApp extends StatelessWidget {
  const PhenixalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phenixal Trail Explorer',
      debugShowCheckedModeBanner: false,
      theme: PhenixalTheme.theme,
      home: const TrailHubScreen(),
    );
  }
}
