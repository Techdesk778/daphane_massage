import 'package:daphane_massage/screen/sign_up.dart';
import 'package:flutter/material.dart';
import '../component /app_colors.dart';

class FaceGoalSelectionScreen extends StatefulWidget {
  const FaceGoalSelectionScreen({super.key});

  @override
  State<FaceGoalSelectionScreen> createState() => _FaceGoalSelectionScreenState();
}

class _FaceGoalSelectionScreenState extends State<FaceGoalSelectionScreen> {
  String? _selectedShape;

  final List<Map<String, String>> faceShapes = [
    {"name": "Heart", "icon": "❤️"},
    {"name": "Oval", "icon": "🥚"},
    {"name": "Triangle", "icon": "🔺"},
    {"name": "Round", "icon": "⭕"},
    {"name": "Square", "icon": "⬜"},
    {"name": "Diamond", "icon": "💎"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView( // Added scroll view to prevent overflows
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Progress Bar
                const Text("40% Complete", style: TextStyle(color: AppColors.textLight)),
                const SizedBox(height: 8),
                const LinearProgressIndicator(
                    value: 0.4,
                    color: AppColors.sharpPink,
                    backgroundColor: AppColors.accentPink),

                const SizedBox(height: 32),
                const Text("Your Target Face\nGoal shape",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.navy)),

                const SizedBox(height: 30),

                // Selection Grid
                GridView.builder(
                  shrinkWrap: true, // Allows GridView to work inside a SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(), // Disables internal scrolling
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: faceShapes.length,
                  itemBuilder: (context, index) {
                    final shape = faceShapes[index];
                    final isSelected = _selectedShape == shape['name'];

                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedShape = shape['name']);

                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (context.mounted) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.accentPink : AppColors.surface,
                          border: Border.all(color: isSelected ? AppColors.sharpPink : Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(shape['icon']!, style: const TextStyle(fontSize: 40)),
                            const SizedBox(height: 8),
                            Text(shape['name']!, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40), // Spacing for the buttons

                // Optional Manual Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedShape == null ? Colors.grey : AppColors.sharpPink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _selectedShape == null
                        ? null
                        : () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen()));
                    },
                    child: const Text("Continue to Analysis", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        )
                    );
                  },
                  child: const Center(child: Text("not sure yet", style: TextStyle(color: AppColors.primaryBlue))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}