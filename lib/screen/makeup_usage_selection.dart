import 'package:flutter/material.dart';
import '../component /app_colors.dart';
import 'user_dashboard.dart';

class MakeupUsageSelectionScreen extends StatefulWidget {
  const MakeupUsageSelectionScreen({super.key});

  @override
  State<MakeupUsageSelectionScreen> createState() => _MakeupUsageSelectionScreenState();
}

class _MakeupUsageSelectionScreenState extends State<MakeupUsageSelectionScreen> {
  String? _selectedUsage;

  final List<Map<String, String>> _usageOptions = [
    {
      "title": "Not at all",
      "description": "I prefer a natural look every day.",
      "icon": "🌿"
    },
    {
      "title": "Once in a while",
      "description": "Only for special events or moods.",
      "icon": "🎭"
    },
    {
      "title": "Occasionally",
      "description": "A few times a month when I feel like it.",
      "icon": "✨"
    },
    {
      "title": "Every week",
      "description": "Part of my regular routine several days a week.",
      "icon": "💄"
    },
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
              const Text("98% Complete", style: TextStyle(color: AppColors.textLight)),
              const SizedBox(height: 8),
              const LinearProgressIndicator(
                value: 0.98,
                color: AppColors.sharpPink,
                backgroundColor: AppColors.accentPink,
              ),
              const SizedBox(height: 32),
              const Text(
                "How often do you\nwear makeup?",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.navy),
              ),
              const SizedBox(height: 12),
              const Text(
                "This helps us understand your skin's daily exposure and cleansing needs.",
                style: TextStyle(color: AppColors.textLight, fontSize: 16),
              ),
              const SizedBox(height: 32),

              ..._usageOptions.map((option) => _buildUsageCard(option)),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedUsage == null ? Colors.grey : AppColors.sharpPink,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _selectedUsage == null
                      ? null
                      : () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const UserDashboard())),
                  child: const Text("Finish", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsageCard(Map<String, String> option) {
    final bool isSelected = _selectedUsage == option['title'];
    return GestureDetector(
      onTap: () => setState(() => _selectedUsage = option['title']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentPink.withOpacity(0.3) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.sharpPink : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(option['icon']!, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option['title']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.sharpPink : AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option['description']!,
                    style: const TextStyle(color: AppColors.textLight, fontSize: 13),
                  ),
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