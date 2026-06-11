import 'package:flutter/material.dart';
import '../component /app_colors.dart';
import 'video_player_screen.dart';

class Beginner extends StatefulWidget {
  const Beginner({super.key});

  @override
  State<Beginner> createState() => _BeginnerState();
}

class _BeginnerState extends State<Beginner> {
  int _selectedDay = 0; // 0 for Monday, etc.
  final List<String> _days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  final List<Map<String, String>> _exercises = const [
    {
      "title": "Reshape Nose",
      "duration": "4 min",
      "link": "https://www.youtube.com/shorts/gRcYMmtPHb8",
      "icon": "👃"
    },
    {
      "title": "Nose Contour Boost",
      "duration": "4 min",
      "link": "https://www.youtube.com/shorts/gRcYMmtPHb8",
      "icon": "✨"
    },
    {
      "title": "Bedtime Routine",
      "duration": "4 min",
      "link": "https://www.youtube.com/shorts/gRcYMmtPHb8",
      "icon": "🌙"
    },
    {
      "title": "Neck Lift",
      "duration": "4 min",
      "link": "https://www.youtube.com/shorts/gRcYMmtPHb8",
      "icon": "🦒"
    },
    {
      "title": "Reduce Forehead",
      "duration": "4 min",
      "link": "https://www.youtube.com/shorts/gRcYMmtPHb8",
      "icon": "🧘"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Horizontal Calendar ---
        const Text(
          "May 2024",
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
                    border: Border.all(
                      color: isSelected ? AppColors.sharpPink : Colors.white24,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _days[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${index + 13}", // Dummy dates
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VideoPlayerScreen(
                  videoUrl: "https://www.youtube.com/shorts/gRcYMmtPHb8",
                ),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: NetworkImage("https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=1240&auto=format&fit=crop"),
                fit: BoxFit.cover,
                opacity: 0.6,
              ),
            ),
            child: const Center(
              child: Icon(Icons.play_circle_fill, color: Colors.white, size: 64),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // --- Topics Section ---
        const Text(
          "Face Sculpt Yoga",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
                    decoration: BoxDecoration(
                      color: AppColors.accentPink.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Text(exercise['icon']!, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise['title']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        Text(
                          "Duration: ${exercise['duration']}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.play_circle_outline, color: AppColors.sharpPink, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(videoUrl: exercise['link']!),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}