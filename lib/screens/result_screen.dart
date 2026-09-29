// result_screen.dart
// Detailed diagnosis report screen with offline symptoms, causes, and treatments

import 'dart:io';
import 'package:flutter/material.dart';
import '../models/recognition_result.dart';
import 'guide_screen.dart';

class ResultScreen extends StatelessWidget {
  final File imageFile;
  final RecognitionResult result;

  const ResultScreen({
    super.key,
    required this.imageFile,
    required this.result,
  });

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF2E7D32);
    }
  }

  @override
  Widget build(BuildContext context) {
    final disease = result.diseaseData;
    final themeColor = _parseColor(disease.colorHex);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosis Report'),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Guide',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GuideScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Image Preview Section
            Stack(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(imageFile),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: result.isPalm ? Colors.black87 : Colors.red.shade900,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              result.isPalm ? Icons.check_circle : Icons.warning_amber_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              result.isPalm ? 'Verified Palm Frond' : 'Non-Palm / Unrecognized',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      if (result.isPalm)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Certainty: ${result.confidencePercentage}',
                            style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // 2. Primary Assessment Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!result.isPalm) ...[
                    // REJECTION BANNER (When non-palm object or other plant is uploaded)
                    _buildRejectionCard(context),
                  ] else ...[
                    // VALID PALM TREE DIAGNOSIS
                    Text(
                      disease.displayName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      disease.scientificName,
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildBadge('Severity: ${disease.severity}', themeColor),
                        const SizedBox(width: 8),
                        _buildBadge(disease.category, Colors.blueGrey),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                  ],

                  // 3. Overview Description
                  _buildSectionHeader(Icons.info_outline, 'Overview & Pathological Profile'),
                  const SizedBox(height: 6),
                  Text(
                    disease.description,
                    style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey.shade900),
                  ),

                  const SizedBox(height: 20),

                  // 4. Observable Symptoms
                  if (disease.symptoms.isNotEmpty) ...[
                    _buildSectionHeader(Icons.checklist_rounded, 'Diagnostic Symptoms'),
                    const SizedBox(height: 8),
                    ...disease.symptoms.map((symptom) => _buildCheckItem(symptom, Icons.arrow_right)),
                    const SizedBox(height: 20),
                  ],

                  // 5. Causes & Favorable Conditions
                  if (disease.causes.isNotEmpty) ...[
                    _buildSectionHeader(Icons.wb_sunny, 'Predisposing Conditions'),
                    const SizedBox(height: 8),
                    ...disease.causes.map((cause) => _buildCheckItem(cause, Icons.fiber_manual_record, iconSize: 10)),
                    const SizedBox(height: 20),
                  ],

                  // 6. Cultural & Organic Controls
                  if (disease.culturalControl.isNotEmpty) ...[
                    _buildSectionHeader(Icons.eco, 'Cultural & Organic Control Measures'),
                    const SizedBox(height: 8),
                    ...disease.culturalControl.map((ctl) => _buildCheckItem(ctl, Icons.eco_outlined, color: Colors.green.shade800)),
                    const SizedBox(height: 20),
                  ],

                  // 7. Chemical Treatment (if diseased)
                  if (disease.chemicalControl.isNotEmpty && result.isPalm && disease.severity != 'None') ...[
                    _buildSectionHeader(Icons.medication, 'Recommended Chemical Treatments'),
                    const SizedBox(height: 8),
                    ...disease.chemicalControl.map((chem) => _buildCheckItem(chem, Icons.science_outlined, color: Colors.purple.shade700)),
                    const SizedBox(height: 20),
                  ],

                  // Back / Retake Button
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.replay_rounded),
                    label: const Text('Diagnose Another Palm Frond', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRejectionCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFB74D), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.report_problem_rounded, color: Color(0xFFE65100), size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Non-Palm Tree or Unrecognized Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFBF360C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'This offline neural network is trained specifically for Date Palm tree fronds (Phoenix dactylifera). '
            'The uploaded image could not be matched with palm tree characteristics. '
            'If this is another plant species or a non-agricultural object, the model does not support it.',
            style: TextStyle(fontSize: 13, height: 1.45, color: Color(0xFF4E342E)),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFE65100),
              side: const BorderSide(color: Color(0xFFE65100)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GuideScreen()),
              );
            },
            icon: const Icon(Icons.camera_alt_outlined, size: 18),
            label: const Text('View How to Take Palm Photos'),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF1B5E20)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF263238),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckItem(String text, IconData icon, {Color? color, double iconSize = 18}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Icon(icon, size: iconSize, color: color ?? const Color(0xFF2E7D32)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13.5, height: 1.4, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }
}
