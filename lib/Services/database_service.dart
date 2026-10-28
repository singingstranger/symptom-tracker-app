import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService{
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("bp-tracker.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path, 
      version: 1,
      onCreate: _createDB,
    );
  }
  Future<void> _createDB(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE readings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        systolic INTEGER NOT NULL, 
        diastolic INTEGER NOT NULL,
        pulse INTEGER NOT NULL,
        symptom_severity INTEGER NOT NULL,
        notes TEXT
        )'''
    );
    await db.execute('''
    CREATE TABLE urine_readings (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      timestamp TEXT NOT NULL,
      volume_ml INTEGER NOT NULL,
      pain_level INTEGER NOT NULL,
      symptoms TEXT,
      notes TEXT
      )
      '''
    );
  }

  //CRUD OPERATIONS

  Future<int> insertReadings(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('readings', row);
  }

  Future<List<Map<String,dynamic>>> getAllReadings() async {
    final db = await instance.database;
    return await db.query('readings', orderBy: 'timestamp DESC');
  }

  Future<int> deleteReading(int id) async{
    final db = await instance.database;
    return await db.delete(
      'readings', 
      where: 'id = ?', 
      whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

}