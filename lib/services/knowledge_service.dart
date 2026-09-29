// knowledge_service.dart
// Offline JSON Knowledge Base Service for Palm Diseases with Normalized Lookup

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/disease_data.dart';

class KnowledgeService {
  static final KnowledgeService _instance = KnowledgeService._internal();
  factory KnowledgeService() => _instance;
  KnowledgeService._internal();

  final Map<String, DiseaseData> _knowledgeMap = {};
  final Map<String, DiseaseData> _normalizedMap = {};
  bool _isLoaded = false;

  String _normalize(String key) {
    return key.toLowerCase().replaceAll(' ', '').replaceAll('_', '').replaceAll('-', '');
  }

  Future<void> loadKnowledgeBase() async {
    if (_isLoaded) return;
    try {
      final jsonString = await rootBundle.loadString('assets/data/disease_info.json');
      final Map<String, dynamic> decoded = jsonDecode(jsonString);

      decoded.forEach((key, value) {
        final data = DiseaseData.fromJson(key, value as Map<String, dynamic>);
        _knowledgeMap[key] = data;
        _normalizedMap[_normalize(key)] = data;
      });
      _isLoaded = true;
    } catch (e) {
      print('Error loading disease_info.json: $e');
    }
  }

  DiseaseData getDiseaseInfo(String key) {
    if (_knowledgeMap.containsKey(key)) {
      return _knowledgeMap[key]!;
    }
    
    // Check normalized key (handles "brown spots", "white scale", "healthy", etc.)
    final normKey = _normalize(key);
    if (_normalizedMap.containsKey(normKey)) {
      return _normalizedMap[normKey]!;
    }

    // Return unrecognized fallback
    if (_knowledgeMap.containsKey('Unrecognized')) {
      return _knowledgeMap['Unrecognized']!;
    }

    return DiseaseData(
      key: key,
      displayName: key,
      scientificName: 'Phoenix dactylifera',
      category: 'Assessment',
      severity: 'Unknown',
      colorHex: '#757575',
      description: 'Detailed information for $key is pending update.',
      symptoms: [],
      causes: [],
      culturalControl: [],
      chemicalControl: [],
    );
  }

  DiseaseData getUnrecognizedInfo() {
    return getDiseaseInfo('Unrecognized');
  }
}
