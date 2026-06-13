import 'package:flutter/material.dart';
import 'routine_plan_view.dart';

class Intermediate extends StatelessWidget {
  const Intermediate({super.key});

  @override
  Widget build(BuildContext context) {
    return const RoutinePlanView(
      planTitle: "Intermediate Training Plan",
      sectionTitle: "Intermediate Sculpting",
      isSubscribed: false, // Control lock state here
      headerImageUrl: "https://images.unsplash.com/photo-1512290923902-8a9f81dc206e?q=80&w=1170",
      lockMessage: "Upgrade to Premium to access Gua Sha and advanced face sculpting.",
      exercises: [
        {"title": "Gua Sha Basics", "duration": "4 min", "link": "https://...", "icon": "💎"},
        {"title": "Cheekbone Sculpting", "duration": "4 min", "link": "https://...", "icon": "✨"},
      ],
    );
  }
}