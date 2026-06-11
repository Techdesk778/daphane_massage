import 'package:flutter/material.dart';
import '../component /app_colors.dart';

class ModernCategoryTabBar extends StatefulWidget {
  final Function(int) onTabChanged;
  const ModernCategoryTabBar({super.key, required this.onTabChanged});

  @override
  State<ModernCategoryTabBar> createState() => _ModernCategoryTabBarState();
}

class _ModernCategoryTabBarState extends State<ModernCategoryTabBar> {
  int _selectedIndex = 0;
  final List<String> _tabs = ["Beginner", "Intermediate", "Advanced"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedIndex = index);
                widget.onTabChanged(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedIndex == index ? AppColors.sharpPink : Colors.transparent, // Updated to Sharp Pink
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _selectedIndex == index ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}