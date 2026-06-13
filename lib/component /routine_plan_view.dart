import 'package:flutter/material.dart';
import '../component /app_colors.dart';
import 'video_player_screen.dart';

class RoutinePlanView extends StatefulWidget {
  final String planTitle;
  final String sectionTitle;
  final List<Map<String, String>> exercises;
  final bool isSubscribed;
  final String headerImageUrl;
  final String lockMessage;

  const RoutinePlanView({
    super.key,
    required this.planTitle,
    required this.sectionTitle,
    required this.exercises,
    required this.isSubscribed,
    required this.headerImageUrl,
    this.lockMessage = "Upgrade to Premium to access this routine.",
  });

  @override
  State<RoutinePlanView> createState() => _RoutinePlanViewState();
}

class _RoutinePlanViewState extends State<RoutinePlanView> {
  int _selectedDay = 0;
  final List<String> _days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Calendar Section
        Text(widget.planTitle, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildCalendar(),

        const SizedBox(height: 24),

        // 2. Video Preview Section
        _buildVideoPreview(),

        const SizedBox(height: 24),

        // 3. Exercise List Section
        Text(widget.sectionTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 16),
        ...widget.exercises.map((e) => _buildExerciseCard(e)),
      ],
    );
  }

  Widget _buildCalendar() {
    return SizedBox(
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
    );
  }

  Widget _buildVideoPreview() {
    return GestureDetector(
      onTap: () => widget.isSubscribed ? _playVideo(widget.exercises[0]['link']!) : _showSubscriptionDialog(),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(widget.headerImageUrl),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: Center(
          child: Icon(widget.isSubscribed ? Icons.play_circle_fill : Icons.lock, color: Colors.white, size: 64),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Map<String, String> e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.accentPink.withOpacity(0.5), shape: BoxShape.circle),
            child: Text(e['icon']!, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e['title']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.navy)),
                Text("Duration: ${e['duration']}", style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(widget.isSubscribed ? Icons.play_circle_outline : Icons.lock_outline, color: AppColors.sharpPink, size: 30),
            onPressed: () => widget.isSubscribed ? _playVideo(e['link']!) : _showSubscriptionDialog(),
          ),
        ],
      ),
    );
  }

  void _playVideo(String url) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => VideoPlayerScreen(videoUrl: url)));
  }

  void _showSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Plan Locked"),
        content: Text(widget.lockMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.sharpPink),
            onPressed: () => Navigator.pop(context),
            child: const Text("Unlock Plan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}