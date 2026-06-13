import 'package:flutter/material.dart';
import '../component /app_colors.dart';

class FaceGoalSelectionScreen extends StatefulWidget {
  const FaceGoalSelectionScreen({super.key});

  @override
  State<FaceGoalSelectionScreen> createState() => _FaceGoalSelectionScreenState();
}

class _FaceGoalSelectionScreenState extends State<FaceGoalSelectionScreen> {
  String? _selectedShape;

  // Updated with human face emojis that represent the shapes better
  final List<Map<String, String>> faceShapes = [
    {"name": "Heart", "icon": "👩‍❤️"},
    {"name": "Oval", "icon": "👩‍🦲"},
    {"name": "Triangle", "icon": "👸"},
    {"name": "Round", "icon": "🧒"},
    {"name": "Square", "icon": "🧔"},
    {"name": "Diamond", "icon": "👩‍🎨"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
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

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
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
                            Navigator.pushNamed(context, '/signUp');
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.accentPink : AppColors.surface,
                          border: Border.all(
                            color: isSelected ? AppColors.sharpPink : Colors.grey.shade200,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: AppColors.sharpPink.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ] : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(shape['icon']!, style: const TextStyle(fontSize: 48)),
                            const SizedBox(height: 12),
                            Text(
                              shape['name']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppColors.sharpPink : AppColors.textDark,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedShape == null ? Colors.grey.shade300 : AppColors.sharpPink,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: _selectedShape == null ? 0 : 4,
                    ),
                    onPressed: _selectedShape == null
                        ? null
                        : () {
                      Navigator.pushNamed(context, '/signUp');
                    },
                    child: const Text("Continue to Analysis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signUp');
                  },
                  child: const Center(
                    child: Text(
                        "not sure yet",
                        style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}