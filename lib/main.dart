import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ViewModel/bp_view_model.dart';
import 'View/dashboard_view.dart';

void main() async {
  // Required so sqflite and native channels can initialize before runApp
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => BPViewModel(),
      child: const Tracker(),
    ),
  );
}

class Tracker extends StatelessWidget {
  const Tracker({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = "Health Tracker Helper";
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const DashboardView(),
    );
  }
}