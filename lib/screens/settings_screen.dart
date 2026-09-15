import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expedition Settings')),
      body: ListView(
        children: const [
          SwitchListTile(value: true, onChanged: null, title: Text('GPS Auto-tracking')),
          SwitchListTile(value: false, onChanged: null, title: Text('Offline Topo Caching')),
        ],
      ),
    );
  }
}
