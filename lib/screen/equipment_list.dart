import 'package:flutter/material.dart';
import '../component /app_colors.dart';

class EquipmentListScreen extends StatelessWidget {
  const EquipmentListScreen({super.key});

  final List<Map<String, String>> _equipment = const [
    {
      "name": "Ice Cubes",
      "description": "Used to depuff and tighten skin before or after massage. The cold helps stimulate blood flow and reduces inflammation.",
      "icon": "🧊"
    },
    {
      "name": "Mirrors",
      "description": "Essential to ensure you are performing techniques correctly and not creating new wrinkles by pulling the skin in the wrong direction.",
      "icon": "🪞"
    },
    {
      "name": "Facial Creams",
      "description": "Provides the necessary 'slip' to prevent skin dragging. Using a cream or oil ensures smooth movements and prevents irritation.",
      "icon": "🧴"
    },
    {
      "name": "Clean Hands",
      "description": "Fundamental hygiene. Always wash your hands before touching your face to prevent transferring bacteria and causing breakouts.",
      "icon": "🧼"
    },
    {
      "name": "Towel",
      "description": "Used to clean excess oil or cream after your session and to keep your face yoga space clean and tidy.",
      "icon": "🧖"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text("Face Yoga Equipment", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _equipment.length,
        itemBuilder: (context, index) {
          final item = _equipment[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['icon']!, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['description']!,
                        style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}