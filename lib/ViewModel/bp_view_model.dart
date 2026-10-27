import 'package:flutter/foundation.dart';
import '../Domain models/bp_reading_model.dart';
import '../Repositories/bp_repository.dart';
import '../Services/csv_export_service.dart';

class BPViewModel extends ChangeNotifier {
  final BPRepository _repository = BPRepository();
  
  List<BPReading> _readings = [];
  List<BPReading> get readings => _readings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadReadings() async {
    _isLoading = true;
    notifyListeners();

    _readings = await _repository.fetchReadings();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addReading(BPReading reading) async {
    await _repository.addReading(reading);
    await loadReadings(); // Refresh list
  }

  Future<void> exportCSV() async {
    if (_readings.isNotEmpty) {
      await CSVExportService.exportAndShareReadings(_readings);
    }
  }
}