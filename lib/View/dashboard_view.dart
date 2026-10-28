import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModel/health_view_model.dart';
import '../ViewModel/blood_pressure_chart.dart';
import 'add_readings_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthViewModel>().loadBpReadings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BP Tracker Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),
            tooltip: 'Export CSV',
            onPressed: () => context.read<HealthViewModel>().exportBpCSV(),
          ),
        ],
      ),
      body: Consumer<HealthViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.bpReadings.isEmpty) {
            return const Center(
              child: Text('No readings recorded yet. Tap + to add one!'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const Text('Blood Pressure Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      BloodPressureChart(readings: viewModel.bpReadings),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddReadingsView()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Reading'),
      ),
    );
  }
}