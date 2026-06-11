import 'package:flutter/material.dart';
import '../component /app_colors.dart';
import 'enhancement_selection_screen.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  String? _selectedGoal;

  final List<Map<String, String>> goals = [
    {"title": "Learn face yoga", "icon": "🧘"},
    {"title": "Looking good and healthy", "icon": "✨"},
    {"title": "Face sculpting", "icon": "🗿"},
    {"title": "Facial relaxation", "icon": "💆"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        // Wrap with SingleChildScrollView to prevent overflow
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("10% Complete", style: TextStyle(color: AppColors.textLight)),
                const SizedBox(height: 8),
                const LinearProgressIndicator(
                  value: 0.1,
                  backgroundColor: AppColors.accentPink,
                  color: AppColors.sharpPink,
                ),
                const SizedBox(height: 32),

                const Text(
                  "What type of impact\nare you hoping for?",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.navy),
                ),
                const SizedBox(height: 12),
                const Text("Let us know your goals so we build an outstanding plan for you.",
                    style: TextStyle(fontSize: 16, color: AppColors.textLight)),
                const SizedBox(height: 32),

                // Goal Options
                ...goals.map((goal) => _buildGoalOption(goal['title']!, goal['icon']!)),

                // Use SizedBox instead of Spacer inside a ScrollView
                const SizedBox(height: 40),

                // Next Button (Visible only when a selection is made)
                if (_selectedGoal != null)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sharpPink,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EnhancementSelectionScreen())),
                      child: const Text("Next", style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),

                const SizedBox(height: 16),
                _buildNotSureButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalOption(String title, String icon) {
    final isSelected = _selectedGoal == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedGoal = title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
            color: isSelected ? AppColors.accentPink.withOpacity(0.3) : AppColors.surface,
            border: Border.all(color: isSelected ? AppColors.sharpPink : AppColors.primaryPink),
            borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isSelected ? AppColors.sharpPink : AppColors.textDark)),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.sharpPink),
          ],
        ),
      ),
    );
  }

  Widget _buildNotSureButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EnhancementSelectionScreen())),
        child: const Text("Not sure yet",
            style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
      ),
    );
  }
}