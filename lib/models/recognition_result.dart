// recognition_result.dart
// Output result of the on-device TFLite inference and OOD verification

import 'disease_data.dart';

class RecognitionResult {
  final String label;
  final double confidence;
  final bool isPalm;
  final Map<String, double> allScores;
  final DiseaseData diseaseData;

  RecognitionResult({
    required this.label,
    required this.confidence,
    required this.isPalm,
    required this.allScores,
    required this.diseaseData,
  });

  String get confidencePercentage => '${(confidence * 100).toStringAsFixed(1)}%';
}
