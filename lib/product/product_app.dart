import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens.dart';
import 'phenixal_store.dart';

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PhenixalStore()..loadData(),
      child: MaterialApp(
        title: 'Phenixal',
        theme: ThemeData(useMaterial3: true),
        home: const PhenixalDashboardScreen(),
      ),
    );
  }
}
