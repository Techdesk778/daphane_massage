import 'package:flutter/material.dart';
import '../component /app_colors.dart';
import 'face_concern_selection.dart';

class SkinTypeSelectionScreen extends StatefulWidget {
  const SkinTypeSelectionScreen({super.key});

  @override
  State<SkinTypeSelectionScreen> createState() => _SkinTypeSelectionScreenState();
}

class _SkinTypeSelectionScreenState extends State<SkinTypeSelectionScreen> {
  String? _selectedSkinType;

  final List<Map<String, String>> _skinTypes = [
    {"type": "Normal", "description": "Balanced, not too oily or dry.", "icon": "😊"},
    {"type": "Oily", "description": "Shiny appearance. Focus on drainage.", "icon": "✨"},
    {"type": "Dry", "description": "Flaky or tight. Needs rich oils.", "icon": "🌵"},
    {"type": "Combination", "description": "Oily T-zone, dry cheeks.", "icon": "🌗"},
    {"type": "Sensitive", "description": "Easily irritated. Gentle movements only.", "icon": "🌸"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("90% Complete", style: TextStyle(color: AppColors.textLight)),
              const SizedBox(height: 8),
              const LinearProgressIndicator(value: 0.9, color: AppColors.sharpPink, backgroundColor: AppColors.accentPink),
              const SizedBox(height: 32),
              const Text("Tell us about your skin.", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.navy)),
              const SizedBox(height: 32),
              ..._skinTypes.map((skin) => _buildSkinTypeCard(skin)),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedSkinType == null ? Colors.grey : AppColors.sharpPink,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _selectedSkinType == null
                      ? null
                      : () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FaceConcernSelectionScreen())),
                  child: const Text("Next", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkinTypeCard(Map<String, String> skin) {
    final bool isSelected = _selectedSkinType == skin['type'];
    return GestureDetector(
      onTap: () => setState(() => _selectedSkinType = skin['type']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentPink.withOpacity(0.3) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.sharpPink : Colors.grey.shade200, width: 2),
        ),
        child: Row(
          children: [
            Text(skin['icon']!, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(skin['type']!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? AppColors.sharpPink : AppColors.navy)),
                const SizedBox(height: 4),
                Text(skin['description']!, style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
              ]),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.sharpPink),
          ],
        ),
      ),
    );
  }
}