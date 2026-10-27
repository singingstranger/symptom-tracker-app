import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../Domain models/bp_reading_model.dart';

class CSVExportService{
  static Future<void> exportAndShareReadings(List<BPReading> readings) async{
    List<List<dynamic>> rows = [
      ['ID', 'Timestamp', 'Systolic', 'Diastolic', 'Pulse', 'Symptom Severity', 'Notes']
    ];

    for(var reading in readings){
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
}