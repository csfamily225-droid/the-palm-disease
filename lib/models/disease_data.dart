// disease_data.dart
// Represents encyclopedic disease knowledge loaded from disease_info.json

class DiseaseData {
  final String key;
  final String displayName;
  final String scientificName;
  final String category;
  final String severity;
  final String colorHex;
  final String description;
  final List<String> symptoms;
  final List<String> causes;
  final List<String> culturalControl;
  final List<String> chemicalControl;

  DiseaseData({
    required this.key,
    required this.displayName,
    required this.scientificName,
    required this.category,
    required this.severity,
    required this.colorHex,
    required this.description,
    required this.symptoms,
    required this.causes,
    required this.culturalControl,
    required this.chemicalControl,
  });

  factory DiseaseData.fromJson(String key, Map<String, dynamic> json) {
    return DiseaseData(
      key: key,
      displayName: json['displayName'] ?? key,
      scientificName: json['scientificName'] ?? 'Phoenix dactylifera',
      category: json['category'] ?? 'Agricultural Assessment',
      severity: json['severity'] ?? 'Moderate',
      colorHex: json['colorHex'] ?? '#2E7D32',
      description: json['description'] ?? 'No description available.',
      symptoms: List<String>.from(json['symptoms'] ?? []),
      causes: List<String>.from(json['causes'] ?? []),
      culturalControl: List<String>.from(json['culturalControl'] ?? []),
      chemicalControl: List<String>.from(json['chemicalControl'] ?? []),
    );
  }
}
