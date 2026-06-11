import 'package:flutter/material.dart';
import '../component /app_colors.dart';
import 'video_player_screen.dart';

class Intermediate extends StatefulWidget {
  const Intermediate({super.key});

  @override
  State<Intermediate> createState() => _IntermediateState();
}

class _IntermediateState extends State<Intermediate> {
  int _selectedDay = 0;
  final List<String> _days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  // Set this to true if the user has paid. Currently false to show the lock.
  final bool isSubscribed = false;

  final List<Map<String, String>> _exercises = const [
    {
      "title": "Gua Sha Fundamentals",
      "duration": "4 min",
      "link": "https://www.youtube.com/shorts/gRcYMmtPHb8",
      "icon": "💎"
    },
    {
      "title": "Cheekbone Sculpting",
      "duration": "4 min",
      "link": "https://www.youtube.com/shorts/gRcYMmtPHb8",
      "icon": "✨"
    },
    {
      "title": "Double Chin Reduction",
      "duration": "4 min",
      "link": "https://www.youtube.com/shorts/gRcYMmtPHb8",
      "icon": "🙌"
    },
    {
      "title": "Acupressure Toning",
      "duration": "4 min",
      "link": "https://www.youtube.com/shorts/gRcYMmtPHb8",
      "icon": "📍"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Horizontal Calendar ---
        const Text(
          "Intermediate Training Plan",
          style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _days.length,
            itemBuilder: (context, index) {
              bool isSelected = _selectedDay == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedDay = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 55,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.sharpPink : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? AppColors.sharpPink : Colors.white24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_days[index], style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text("${index + 1}", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        // --- Video Display Screen ---
        GestureDetector(
          onTap: () => isSubscribed ? _playVideo(_exercises[0]['link']!) : _showSubscriptionDialog(),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: NetworkImage("https://images.unsplash.com/photo-1512290923902-8a9f81dc206e?q=80&w=1170&auto=format&fit=crop"),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
            ),
            child: Center(
              child: Icon(
                  isSubscribed ? Icons.play_circle_fill : Icons.lock,
                  color: Colors.white,
                  size: 64
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // --- Exercise List ---
        const Text(
          "Intermediate Sculpting",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 16),

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _exercises.length,
          itemBuilder: (context, index) {
            final exercise = _exercises[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.accentPink.withOpacity(0.5), shape: BoxShape.circle),
                    child: Text(exercise['icon']!, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exercise['title']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.navy)),
                        Text("Duration: ${exercise['duration']}", style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                        isSubscribed ? Icons.play_circle_outline : Icons.lock_outline,
                        color: AppColors.sharpPink,
                        size: 30
                    ),
                    onPressed: () => isSubscribed ? _playVideo(exercise['link']!) : _showSubscriptionDialog(),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _playVideo(String url) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => VideoPlayerScreen(videoUrl: url)));
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Unlock Intermediate Plan"),
        content: const Text("Upgrade to Premium to access Gua Sha and advanced face sculpting rituals."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Maybe Later")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.sharpPink),
            onPressed: () => Navigator.pop(context),
            child: const Text("Subscribe Now", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}