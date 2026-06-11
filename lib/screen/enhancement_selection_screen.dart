import 'package:flutter/material.dart';
import '../component /app_colors.dart';
import 'face_goal_selection_screen.dart';

class EnhancementSelectionScreen extends StatefulWidget {
  const EnhancementSelectionScreen({super.key});

  @override
  State<EnhancementSelectionScreen> createState() => _EnhancementSelectionScreenState();
}

class _EnhancementSelectionScreenState extends State<EnhancementSelectionScreen> {
  final Set<String> _selectedAreas = {};
  final List<String> _areas = ['Forehead', 'Eyes', 'Cheeks', 'Mouth'];

  void _toggleSelection(String area) {
    setState(() {
      if (_selectedAreas.contains(area)) {
        _selectedAreas.remove(area);
      } else {
        _selectedAreas.add(area);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("30% Complete", style: TextStyle(color: AppColors.textLight)),
              const SizedBox(height: 8),
             const  LinearProgressIndicator(
                  value: 0.3,
                  color: AppColors.sharpPink,
                  backgroundColor: AppColors.accentPink
              ),

              const SizedBox(height: 32),
              const Text(
                "Where to enhance\nyour natural beauty.",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.navy),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: Row(
                  children: [
                    // Face Image with Programmatic Overlays
                    Expanded(
                      flex: 3,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // RESTORED IMAGE: This uses your local asset file
                          Image.asset(
                            'lib/images/face.png',
                            fit: BoxFit.contain,
                          ),

                          // HIGHLIGHTS - These boxes mark the section on the image
                          if (_selectedAreas.contains('Forehead')) _buildAreaHighlight('Forehead'),
                          if (_selectedAreas.contains('Eyes')) _buildAreaHighlight('Eyes'),
                          if (_selectedAreas.contains('Cheeks')) _buildAreaHighlight('Cheeks'),
                          if (_selectedAreas.contains('Mouth')) _buildAreaHighlight('Mouth'),
                        ],
                      ),
                    ),

                    // Checkbox Selection List
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _areas.map((area) => CheckboxListTile(
                          title: Text(area, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          value: _selectedAreas.contains(area),
                          onChanged: (_) => _toggleSelection(area),
                          activeColor: AppColors.sharpPink,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Navigation Buttons
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.sharpPink,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FaceGoalSelectionScreen()),
                    );
                  },
                  child: const Text("Continue", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const FaceGoalSelectionScreen()));
                    },
                    child: const Text("Not sure yet", style: TextStyle(color: AppColors.primaryBlue))
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Helper to build visual markers for selected areas
  Widget _buildAreaHighlight(String area) {
    switch (area) {
      case 'Forehead':
        return Positioned(top: 80, child: _glowBox(100, 30));
      case 'Eyes':
        return Positioned(
          top: 130,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _glowBox(35, 20, isRound: true),
              const SizedBox(width: 30),
              _glowBox(35, 20, isRound: true),
            ],
          ),
        );
      case 'Cheeks':
        return Positioned(
          top: 170,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _glowBox(45, 45, isRound: true),
              const SizedBox(width: 50),
              _glowBox(45, 45, isRound: true),
            ],
          ),
        );
      case 'Mouth':
        return Positioned(top: 240, child: _glowBox(70, 30));
      default:
        return const SizedBox.shrink();
    }
  }

  // Programmatic Glow Effect
  Widget _glowBox(double width, double height, {bool isRound = false}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.sharpPink.withOpacity(0.3),
        borderRadius: BorderRadius.circular(isRound ? height / 2 : 8),
        boxShadow: [
          BoxShadow(
            color: AppColors.sharpPink.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}