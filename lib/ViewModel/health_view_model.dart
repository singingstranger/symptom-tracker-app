import 'package:flutter/foundation.dart';
import 'package:health_tracker_helper/Domain%20models/urine_reading_model.dart';
import 'package:health_tracker_helper/Repositories/urine_repository.dart';
import '../Domain models/bp_reading_model.dart';
import '../Repositories/bp_repository.dart';
import '../Services/csv_export_service.dart';

class HealthViewModel extends ChangeNotifier {
  final BPRepository _bpRepository = BPRepository();
  final UrineRepository _urineRepository = UrineRepository();

  List<BPReading> _bpReadings = [];
  List<BPReading> get bpReadings => _bpReadings;
  List<UrineReading> _urineReadings = [];
  List<UrineReading> get urineReadings => _urineReadings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadBpReadings() async {
    _isLoading = true;
    _bpReadings = await _bpRepository.fetchReadings();

    _isLoading = false;
    notifyListeners();
  }
  Future<void> loadUrineReadings() async {
    _urineReadings = await _urineRepository.fetchReadings();
    notifyListeners();
  }

  Future<void> addBpReading(BPReading reading) async {
    await _bpRepository.addReading(reading);
    await loadBpReadings(); // Refresh list
  }
  Future<void> addUrineReading(UrineReading reading) async{
    await _urineRepository.addReading(reading);
    await loadUrineReadings();
  }

  Future<void> exportBpCSV() async {
    if (_bpReadings.isNotEmpty) {
      await CSVExportService.exportAndShareBpReadings(_bpReadings);
    }
  }
  Future<void> exportUrineCSV() async {
    if(_urineReadings.isNotEmpty){
      await CSVExportService.exportAndShareUrineReadings(_urineReadings);
    }
  }
}