import '../Domain models/bp_reading_model.dart';
import '../Services/database_service.dart';

class BPRepository{
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<void> addReading(BPReading reading) async{
    await _databaseService.insertReadings(reading.toMap());
  }

  Future<List<BPReading>> fetchReadings() async{
    final rawData = await _databaseService.getAllReadings();
    return rawData.map((map) => BPReading.fromMap(map)).toList();
  }

  Future<void> removeReading(int id) async{
    await _databaseService.deleteReading(id);
  }
}