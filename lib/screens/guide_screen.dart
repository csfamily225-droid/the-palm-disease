// guide_screen.dart
// Practical field guide for farmers & examiners on taking accurate palm frond photos

import 'package:flutter/material.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photography & Diagnosis Guide'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTipCard(
            context,
            icon: Icons.center_focus_strong,
            title: '1. Frame the Palm Leaflet Clearly',
            description:
                'Focus directly on the affected leaflets or midrib showing discoloration, spots, or honeydew. Keep the palm leaf in the center 80% of the frame.',
            color: Colors.green.shade700,
          ),
          const SizedBox(height: 12),
          _buildTipCard(
            context,
            icon: Icons.straighten,
            title: '2. Maintain Proper Distance (20 - 40 cm)',
            description:
                'Avoid standing too far (where leaflets become thin lines) or too close (which triggers macro camera blur). 20 to 40 cm gives the ideal balance.',
            color: Colors.teal.shade700,
          ),
          const SizedBox(height: 12),
          _buildTipCard(
            context,
            icon: Icons.wb_sunny_outlined,
            title: '3. Natural Daylight (Avoid Harsh Glare)',
            description:
                'Photograph under diffuse natural morning or late afternoon daylight. Avoid direct desert noon glare or pitch darkness with phone flash.',
            color: Colors.orange.shade800,
          ),
          const SizedBox(height: 12),
          _buildTipCard(
            context,
            icon: Icons.block,
            title: '4. Palm Trees Only',
            description:
                'This offline model is specialized specifically for Date Palm trees (Phoenix dactylifera). Images of other plants, animals, or objects will be automatically rejected.',
            color: Colors.red.shade700,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.wifi_off_rounded, size: 36, color: Colors.green.shade800),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'All diagnoses run 100% on your device using TensorFlow Lite. No internet connection or cellular data is ever required.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263238),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
