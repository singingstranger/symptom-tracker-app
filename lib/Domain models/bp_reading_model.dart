class BPReading{
  final int? id;
  final DateTime timeStamp;
  final double systolic;
  final double diastolic;
  final int pulse;
  final int symptomSeverity;
  final String? notes;

  BPReading(
    {
      this.id,
      required this.timeStamp,
      required this.systolic,
      required this.diastolic,
      required this.pulse,
      required this.symptomSeverity,
      this.notes,
    }
  );

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "timestamp": timeStamp.toIso8601String(),
      "systolic": systolic,
      "diastolic": diastolic,
      "pulse": pulse,
      "symptom-severity": symptomSeverity,
      "notes": notes,
    };
  }
  
  factory BPReading.fromMap(Map<String,dynamic> map) {
    return BPReading(
      id: map["id"] as int?,
      timeStamp: DateTime.parse(map["timestamp"] as String), 
      systolic: (map["systolic"] as num).toDouble(), 
      diastolic: (map["diastolic"] as num).toDouble(), 
      pulse: map["pulse"] as int, 
      symptomSeverity: map["symptom-severity"] as int,
      notes: map["notes"] as String,
    );
  }
}