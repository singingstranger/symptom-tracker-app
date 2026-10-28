import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../Domain models/bp_reading_model.dart';
import '../Domain models/urine_reading_model.dart'; // Added missing import

class CSVExportService {
  static Future<void> exportAndShareBpReadings(List<BPReading> readings) async {
    List<List<dynamic>> rows = [
      ['ID', 'Timestamp', 'Systolic', 'Diastolic', 'Pulse', 'Symptom Severity', 'Notes']
    ];

    for (var reading in readings) {
      rows.add([
        reading.id ?? '',
        reading.timeStamp.toIso8601String(),
        reading.systolic,
        reading.diastolic,
        reading.pulse,
        reading.symptomSeverity,
        reading.notes ?? '',
      ]);
    }
    String csvData = const ListToCsvConverter().convert(rows);

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/bp_readings_export.csv';
    final file = File(path);
    await file.writeAsString(csvData);

    await Share.shareXFiles([XFile(path)], text: "Exported Blood Pressure Data");
  }

  static Future<void> exportAndShareUrineReadings(List<UrineReading> readings) async {
    List<List<dynamic>> rows = [
      ['ID', 'Timestamp', 'Volume (ml)', 'Pain Level (0-10)', 'Symptoms', 'Notes']
    ];
    
    for (var reading in readings) {
      rows.add([
        reading.id ?? '',
        reading.timeStamp.toIso8601String(), // Fixed comma to dot
        reading.volumeMl,
        reading.painLevel,
        reading.symptoms.join('; '),
        reading.notes ?? '',
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    // Added file generation and share mechanism
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/urine_readings_export.csv';
    final file = File(path);
    await file.writeAsString(csvData);

    await Share.shareXFiles([XFile(path)], text: "Exported Urine Tracking Data");
  }
}