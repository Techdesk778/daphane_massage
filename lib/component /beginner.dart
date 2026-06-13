import 'package:flutter/material.dart';
import 'routine_plan_view.dart';

class Beginner extends StatelessWidget {
  const Beginner({super.key});

  @override
  Widget build(BuildContext context) {
    return const RoutinePlanView(
      planTitle: "Beginner Daily Routine",
      sectionTitle: "Face Sculpt Yoga",
      isSubscribed: true, // Beginner is free and unlocked
      headerImageUrl: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=1240&auto=format&fit=crop",
      exercises: [
        {"title": "Reshape Nose", "duration": "4 min", "link": "https://www.youtube.com/shorts/gRcYMmtPHb8", "icon": "👃"},
        {"title": "Nose Contour Boost", "duration": "4 min", "link": "https://www.youtube.com/shorts/gRcYMmtPHb8", "icon": "✨"},
        {"title": "Bedtime Routine", "duration": "4 min", "link": "https://www.youtube.com/shorts/gRcYMmtPHb8", "icon": "🌙"},
        {"title": "Neck Lift", "duration": "4 min", "link": "https://www.youtube.com/shorts/gRcYMmtPHb8", "icon": "🦒"},
        {"title": "Reduce Forehead", "duration": "4 min", "link": "https://www.youtube.com/shorts/gRcYMmtPHb8", "icon": "🧘"},
      ],
    );
  }
}