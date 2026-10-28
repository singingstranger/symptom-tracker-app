class UrineReading{
  final int? id;
  final DateTime timeStamp;
  final int volumeMl;
  final int painLevel;
  final List<String> symptoms;
  final String? notes;

  UrineReading({
    this.id,
    required this.timeStamp,
    required this.volumeMl,
    required this.painLevel,
    required this.symptoms,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timeStamp.toIso8601String(),
      'volume_ml': volumeMl,
      'pain_level': painLevel,
      // Store list of symptoms as a comma-separated string in SQLite
      'symptoms': symptoms.join(','),
      'notes': notes,
    };
  }
  factory UrineReading.fromMap(Map<String, dynamic> map) {
    String symptomsStr = map['symptoms'] as String? ?? '';
    return UrineReading(
      id: map['id'] as int?,
      timeStamp: DateTime.parse(map['timestamp'] as String),
      volumeMl: map['volume_ml'] as int,
      painLevel: map['pain_level'] as int,
      symptoms: symptomsStr.isEmpty ? [] : symptomsStr.split(','),
      notes: map['notes'] as String?,
    );
  }
}
