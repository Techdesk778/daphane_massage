import 'package:flutter/material.dart';
import '../component /app_colors.dart';
import 'user_dashboard.dart'; // Ensure this is imported

class FaceConcernSelectionScreen extends StatefulWidget {
  const FaceConcernSelectionScreen({super.key});

  @override
  State<FaceConcernSelectionScreen> createState() => _FaceConcernSelectionScreenState();
}

class _FaceConcernSelectionScreenState extends State<FaceConcernSelectionScreen> {
  String? _selectedConcern;

  final List<Map<String, String>> _concerns = [
    {"title": "Smooth Skin", "description": "Maintenance focused.", "icon": "✨"},
    {"title": "Only a Few Lines", "description": "Prevention focused.", "icon": "📝"},
    {"title": "Frowning Lines", "description": "Tension release.", "icon": "😠"},
    {"title": "Nasolabial Folds", "description": "Smile line targeting.", "icon": "👄"},
    {"title": "Crow's Feet", "description": "Eye area care.", "icon": "👁️"},
    {"title": "Forehead Wrinkles", "description": "Smoothing lines.", "icon": "💆"},
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
              const Text("100% Complete", style: TextStyle(color: AppColors.textLight)),
              const SizedBox(height: 8),
              const LinearProgressIndicator(
                value: 1.0,
                color: AppColors.sharpPink,
                backgroundColor: AppColors.accentPink,
              ),
              const SizedBox(height: 32),
              const Text(
                "Tell us how you feel about your face.",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.navy),
              ),
              const SizedBox(height: 32),

              ..._concerns.map((concern) => _buildConcernCard(concern)),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedConcern == null ? Colors.grey : AppColors.sharpPink,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _selectedConcern == null
                      ? null
                      : () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const UserDashboard()),
                  ),
                  child: const Text("Finish", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConcernCard(Map<String, String> concern) {
    final bool isSelected = _selectedConcern == concern['title'];
    return GestureDetector(
      onTap: () => setState(() => _selectedConcern = concern['title']),
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
            Text(concern['icon']!, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(concern['title']!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? AppColors.sharpPink : AppColors.navy)),
                  const SizedBox(height: 4),
                  Text(concern['description']!, style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.sharpPink),
          ],
        ),
      ),
    );
  }
}