import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ParsedBPResult {
  final int? systolic;
  final int? diastolic;
  final int? pulse;

  ParsedBPResult({this.systolic, this.diastolic, this.pulse});
}

class OCRService {
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<ParsedBPResult> processImageForBP(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

    List<int> foundNumbers = [];

    // Regular expression to find isolated 2 or 3 digit numbers typical of medical devices
    final RegExp numberRegex = RegExp(r'\b\d{2,3}\b');

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        final matches = numberRegex.allMatches(line.text);
        for (final match in matches) {
          final val = int.tryParse(match.group(0)!);
          if (val != null) {
            foundNumbers.add(val);
          }
        }
      }
    }

    // Intelligent sorting / heuristic filtering for BP readings
    // Typically: Systolic (e.g., 90-180), Diastolic (e.g., 50-110), Pulse (e.g., 50-150)
    int? systolic, diastolic, pulse;

    // Filter reasonable ranges
    final validNumbers = foundNumbers.where((n) => n >= 40 && n <= 250).toList();

    if (validNumbers.isNotEmpty) {
      // Usually, systolic is the highest value found on a standard BP monitor screen
      validNumbers.sort((a, b) => b.compareTo(a));
      
      systolic = validNumbers.first;
      
      // Look for a realistic diastolic value next (usually lower than systolic)
      final remaining = validNumbers.where((n) => n < systolic!).toList();
      if (remaining.isNotEmpty) {
        diastolic = remaining.first;
      }
      
      // Look for a pulse value (often labeled or distinct, let's take another remaining value or default)
      final pulseCandidates = remaining.where((n) => n != diastolic).toList();
      if (pulseCandidates.isNotEmpty) {
        pulse = pulseCandidates.first;
      }
    }

    return ParsedBPResult(systolic: systolic, diastolic: diastolic, pulse: pulse);
  }

  Future<void> dispose() async {
    await _textRecognizer.close();
  }
}