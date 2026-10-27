import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Domain models/bp_reading_model.dart';
import '../ViewModel/bp_view_model.dart';
import 'ocr_scan_view.dart'; // Added missing import for the camera scan view

class AddReadingsView extends StatefulWidget {
  const AddReadingsView({super.key});

  @override
  State<AddReadingsView> createState() => _AddReadingsViewState();
}

class _AddReadingsViewState extends State<AddReadingsView> {
  int systolic = 120;
  int diastolic = 80;
  int pulse = 70;
  int symptomSeverity = 1;
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add reading"),
        actions: [
          // Camera button properly placed inside the AppBar actions array
          IconButton(
            icon: const Icon(Icons.camera_alt),
            tooltip: 'Scan via Camera',
            onPressed: () async {
              final scannedData = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OCRScanView()),
              );

              if (scannedData != null && scannedData is Map<String, int?>) {
                setState(() {
                  if (scannedData['systolic'] != null) systolic = scannedData['systolic']!;
                  if (scannedData['diastolic'] != null) diastolic = scannedData['diastolic']!;
                  if (scannedData['pulse'] != null) pulse = scannedData['pulse']!;
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Successfully scanned values! Please verify.')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStepperTile('Systolic (mmHg)', systolic, (val) => setState(() => systolic = val), min: 50, max: 220),
            _buildStepperTile('Diastolic (mmHg)', diastolic, (val) => setState(() => diastolic = val), min: 30, max: 140),
            _buildStepperTile('Pulse (BPM)', pulse, (val) => setState(() => pulse = val), min: 40, max: 200),

            const SizedBox(height: 16),
            Text("Symptom Severity (1-5)", style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: symptomSeverity.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: "$symptomSeverity",
              onChanged: (val) => setState(() => symptomSeverity = val.toInt()),
            ),

            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: "Notes",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: () async {
                final newReading = BPReading(
                  timeStamp: DateTime.now(), 
                  systolic: systolic.toDouble(), 
                  diastolic: diastolic.toDouble(), 
                  pulse: pulse, 
                  symptomSeverity: symptomSeverity,
                  notes: _notesController.text.isEmpty ? null : _notesController.text,
                );
                await context.read<BPViewModel>().addReading(newReading);
                if (mounted) Navigator.pop(context);
              },
              child: const Text("Save Reading", style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStepperTile(String label, int value, ValueChanged<int> onChanged, {required int min, required int max}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              children: [
                IconButton.filledTonal(
                  icon: const Icon(Icons.remove),
                  onPressed: value > min ? () => onChanged(value - 1) : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text('$value', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                IconButton.filledTonal(
                  icon: const Icon(Icons.add),
                  onPressed: value < max ? () => onChanged(value + 1) : null,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}