import 'package:flutter/material.dart';
import '../component /app_colors.dart';
import 'goal_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Stack(
        children: [
          // 1. Static Global Background Image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const NetworkImage("https://plus.unsplash.com/premium_photo-1661490806998-eeb4f757cce2?q=80&w=1165&auto=format&fit=crop"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      AppColors.navy.withOpacity(0.5), BlendMode.darken),
                ),
              ),
            ),
          ),

          // 2. Main content area - Wrapped in LayoutBuilder and ScrollView
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 100),

                        // 3. Static Header Text
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            children: [
                              Text(
                                "your face deserves the best",
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "get a professional face massage plan based on your unique face",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white70, fontSize: 18, height: 1.5),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 48),

                        // 4. Static Middle Content
                        Expanded(
                          child: Center(
                            child: _buildStaticContent(
                              title: "Guided Facial Care",
                              description: "Professional massage techniques at your fingertips.",
                              color: AppColors.sharpPink,
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // 5. Bottom Navigation Button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => GoalSelectionScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.sharpPink,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Text("Get Started",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStaticContent({required String title, required String description, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(Icons.spa, size: 80, color: color),
          ),
          const SizedBox(height: 48),
          Text(title,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 16),
          Text(description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 18, height: 1.5)),
        ],
      ),
    );
  }
}