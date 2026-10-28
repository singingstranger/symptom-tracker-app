import '../Domain models/urine_reading_model.dart';
import '../Services/database_service.dart';

class UrineRepository {
  final DatabaseService _dbService = DatabaseService.instance;
  Future<void> addReading(UrineReading reading) async{
    await _dbService.insertUrineReading(reading.toMap());
  }
  Future<List<UrineReading>> fetchReadings() async{
    final rawData = await _dbService.getAllUrineReadings();
    return rawData.map((map) => UrineReading.fromMap(map)).toList();
  }
  Future<void> removeReading(int id) async {
    await _dbService.deleteUrineReading(id);
  }
}