import 'package:flutter/material.dart';
import '../component /app_colors.dart'; // Verified project layout path

class RoutineTrackerScreen extends StatefulWidget {
  const RoutineTrackerScreen({super.key});

  @override
  State<RoutineTrackerScreen> createState() => _RoutineTrackerScreenState();
}

class _RoutineTrackerScreenState extends State<RoutineTrackerScreen> {
  // Sample production dataset for a user's daily self-care ritual routine
  final List<Map<String, dynamic>> _dailyRoutines = [
    {
      "id": "1",
      "title": "Morning Glow Hydration",
      "time": "08:00 AM",
      "status": "completed", // completed, missed, pending
    },
    {
      "id": "2",
      "title": "Aromatherapy Facial Massage",
      "time": "02:30 PM",
      "status": "missed",
    },
    {
      "id": "3",
      "title": "Collagen Serum Application",
      "time": "09:00 PM",
      "status": "pending",
    },
    {
      "id": "4",
      "title": "Night-time Muscle Release",
      "time": "10:30 PM",
      "status": "pending",
    },
  ];

  // Helper calculation metrics to derive progress dynamically
  double get _calculatedProgress {
    if (_dailyRoutines.isEmpty) return 0.0;
    int completedCount = _dailyRoutines.where((r) => r["status"] == "completed").length;
    return completedCount / _dailyRoutines.length;
  }

  int get _missedCount => _dailyRoutines.where((r) => r["status"] == "missed").length;

  // Toggle routine status when tapped to update progress live
  void _toggleRoutineStatus(int index) {
    setState(() {
      String currentStatus = _dailyRoutines[index]["status"];
      if (currentStatus == "pending" || currentStatus == "missed") {
        _dailyRoutines[index]["status"] = "completed";
      } else {
        _dailyRoutines[index]["status"] = "pending";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy, // Rich Navy
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("My Glow Routine", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- PROGRESS & OVERVIEW HEADER HERO ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Row(
                children: [
                  // Circular Progress Indicator Node
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: _calculatedProgress,
                          strokeWidth: 8,
                          backgroundColor: const Color(0xFFF0F0F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.sharpPink), // Sharp Pink
                        ),
                      ),
                      Text(
                        "${(_calculatedProgress * 100).toInt()}%",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  // Progress Text Metatags
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Today's Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        const SizedBox(height: 4),
                        Text(
                          "Keep up your routine cycle to maintain your glow.",
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        if (_missedCount > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "You missed $_missedCount $_missedCount == 1 ? 'routine' : 'routines' today",
                                style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- SECTION TITLE ---
            const Text(
              "Daily Routine Timeline",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            const SizedBox(height: 16),

            // --- TIMELINE LIST BUILDER ---
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _dailyRoutines.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final routine = _dailyRoutines[index];
                IconData leadingIcon;
                Color cardBorderColor;
                Color trailingBadgeColor;
                String statusLabel;

                // Handle conditional layouts based on status structures
                switch (routine["status"]) {
                  case "completed":
                    leadingIcon = Icons.check_circle;
                    cardBorderColor = AppColors.sharpPink.withOpacity(0.4);
                    trailingBadgeColor = AppColors.sharpPink;
                    statusLabel = "Done";
                    break;
                  case "missed":
                    leadingIcon = Icons.cancel;
                    cardBorderColor = Colors.redAccent.withOpacity(0.4);
                    trailingBadgeColor = Colors.redAccent;
                    statusLabel = "Missed";
                    break;
                  default:
                    leadingIcon = Icons.radio_button_unchecked;
                    cardBorderColor = Colors.transparent;
                    trailingBadgeColor = Colors.grey;
                    statusLabel = "Pending";
                }

                return GestureDetector(
                  onTap: () => _toggleRoutineStatus(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cardBorderColor, width: 1.5),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(leadingIcon, color: trailingBadgeColor, size: 26),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                routine["title"],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                  decoration: routine["status"] == "completed" ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 14, color: AppColors.textLight),
                                  const SizedBox(width: 4),
                                  Text(routine["time"], style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: trailingBadgeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: trailingBadgeColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}