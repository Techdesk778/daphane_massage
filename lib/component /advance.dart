import 'package:flutter/material.dart';
import 'routine_plan_view.dart';

class Advanced extends StatelessWidget {
  const Advanced({super.key});

  @override
  Widget build(BuildContext context) {
    return const RoutinePlanView(
      planTitle: "Advanced Mastery Track",
      sectionTitle: "Advanced Mastery",
      isSubscribed: false, // Mastery track is locked
      headerImageUrl: "https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=1170&auto=format&fit=crop",
      lockMessage: "Become a Pro member to access professional buccal massage and deep tissue sculpting techniques.",
      exercises: [
        {"title": "Intra-Oral (Buccal) Basics", "duration": "4 min", "link": "https://www.youtube.com/shorts/gRcYMmtPHb8", "icon": "🧤"},
        {"title": "Deep Tissue Sculpting", "duration": "4 min", "link": "https://www.youtube.com/shorts/gRcYMmtPHb8", "icon": "💆"},
        {"title": "Structural Lifting", "duration": "4 min", "link": "https://www.youtube.com/shorts/gRcYMmtPHb8", "icon": "🔥"},
        {"title": "Asymmetry Correction", "duration": "4 min", "link": "https://www.youtube.com/shorts/gRcYMmtPHb8", "icon": "⚖️"},
      ],
    );
  }
}