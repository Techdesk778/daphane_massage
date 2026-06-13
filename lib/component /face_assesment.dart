import 'package:flutter/material.dart';
import '../component /app_colors.dart'; // Verified project path alignment

class FaceAssessmentScreen extends StatefulWidget {
  const FaceAssessmentScreen({super.key});

  @override
  State<FaceAssessmentScreen> createState() => _FaceAssessmentScreenState();
}

class _FaceAssessmentScreenState extends State<FaceAssessmentScreen> {
  int _currentQuestionIndex = 0;

  // Track user selections per question index
  final Map<int, int> _userAnswers = {};

  // Production-grade dataset for the custom Glow Ritual consultation
  final List<Map<String, dynamic>> _assessmentQuestions = [
    {
      "question": "What is your primary facial structural goal?",
      "options": [
        {"text": "Sculpt and define cheekbones/jawline", "score": 10},
        {"text": "Reduce morning puffiness and drain fluid", "score": 20},
        {"text": "Relieve deep muscle tension & jaw clenching", "score": 30},
        {"text": "Smooth fine lines and boost blood circulation", "score": 40}
      ]
    },
    {
      "question": "Where do you experience the most tightness or stress?",
      "options": [
        {"text": "Around the jawline and masseter muscles", "score": 30},
        {"text": "Across the forehead and between the brows", "score": 40},
        {"text": "Under the eyes and around the sinus area", "score": 20},
        {"text": "Entire face feels fatigued, no specific spot", "score": 10}
      ]
    },
    {
      "question": "How would you describe your face shape profile?",
      "options": [
        {"text": "Round / Soft structural contours", "score": 10},
        {"text": "Heart / Prominent upper frame, tapering chin", "score": 20},
        {"text": "Triangle / Defined, strong lower jaw alignment", "score": 30},
        {"text": "Oval / Balanced, symmetrical framework", "score": 40}
      ]
    },
    {
      "question": "What is your preferred massage tool configuration?",
      "options": [
        {"text": "Traditional manual hand manipulation", "score": 10},
        {"text": "Contoured Jade or Quartz Gua Sha stone", "score": 20},
        {"text": "Microcurrent lifting device hardware", "score": 40},
        {"text": "Cooling ice rollers or globes", "score": 30}
      ]
    }
  ];

  // Logic to dynamically generate recommendations based on structural response metrics
  Map<String, String> _calculateRitualOutcome() {
    int totalScore = 0;
    _userAnswers.forEach((key, value) {
      totalScore += value;
    });

    if (totalScore <= 60) {
      return {
        "title": "The Contour Sculpt Ritual",
        "description": "Perfect for your profile! Focus on upward lifting strokes using deep finger kneading along the jawline and cheek paths to naturally stimulate lymphatic drainage and highlight structural symmetry."
      };
    } else if (totalScore <= 90) {
      return {
        "title": "The Lymphatic Detox Flow",
        "description": "Recommended to combat puffiness. Use light, sweeping, sweeping outward motions starting from the bridge of the nose out to the ears, then down the neck line to flush fluid buildup efficiently."
      };
    } else if (totalScore <= 120) {
      return {
        "title": "Deep Masseter Tension Release",
        "description": "A customized therapeutic cycle to ease clenching. Focus heavily on circular knuckles friction directly over the jaw joints and brow arches to melt deep-set muscular stress chains."
      };
    } else {
      return {
        "title": "The Advanced Accupressure Lift",
        "description": "Designed for maximum structural restoration. Apply firm, static pressure points for 5 seconds at a time on key meridian intersections—corners of the mouth, cheek hollows, and temple apex points."
      };
    }
  }

  void _handleOptionSelected(int score) {
    setState(() {
      _userAnswers[_currentQuestionIndex] = score;
      if (_currentQuestionIndex < _assessmentQuestions.length) {
        _currentQuestionIndex++;
      }
    });
  }

  void _restartAssessment() {
    setState(() {
      _currentQuestionIndex = 0;
      _userAnswers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isAssessmentComplete = _currentQuestionIndex >= _assessmentQuestions.length;
    double progressPercent = _currentQuestionIndex / _assessmentQuestions.length;

    return Scaffold(
      backgroundColor: AppColors.navy, // Rich Navy backdrop
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Glow Assessment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: _currentQuestionIndex > 0 && !isAssessmentComplete
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => setState(() => _currentQuestionIndex--),
        )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- PROGRESS BAR SUBSECTION ---
              if (!isAssessmentComplete) ...[
                LinearProgressIndicator(
                  value: progressPercent,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.sharpPink), // Sharp Pink highlight
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 12),
                Text(
                  "Question ${_currentQuestionIndex + 1} of ${_assessmentQuestions.length}",
                  style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 32),
              ],

              // --- MAIN INTERACTIVE WIDGET SWITCHER ---
              Expanded(
                child: isAssessmentComplete
                    ? _buildResultsView()
                    : _buildQuestionCard(_assessmentQuestions[_currentQuestionIndex]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Card view container parsing active diagnostic question strings
  Widget _buildQuestionCard(Map<String, dynamic> questionData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          questionData["question"],
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white, height: 1.4),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: ListView.separated(
            itemCount: (questionData["options"] as List).length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final option = questionData["options"][index];
              return InkWell(
                onTap: () => _handleOptionSelected(option["score"]),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option["text"],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                      ),
                      const Icon(Icons.spa_outlined, color: AppColors.sharpPink, size: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Summary viewport display triggered on evaluation completion
  Widget _buildResultsView() {
    final result = _calculateRitualOutcome();
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decorative Icon Stack
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.sharpPink.withOpacity(0.4), width: 2),
              ),
              child: const Icon(Icons.analytics_outlined, size: 64, color: AppColors.sharpPink),
            ),
            const SizedBox(height: 32),
            const Text(
              "Your Prescribed Solution",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 2),
            ),
            const SizedBox(height: 8),
            Text(
              result["title"]!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Clean Content Card displaying computed text recommendation maps
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Text(
                result["description"]!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: AppColors.textDark, height: 1.6, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 48),

            // Action Button to let the user re-trigger the script loops
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _restartAssessment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sharpPink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  "Retake Assessment",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}