import 'package:daphane_massage/screen/profile.dart';
import 'package:daphane_massage/screen/routine_tracker.dart';
import 'package:daphane_massage/screen/notification_screen.dart'; // Added relative reference hook
import 'package:flutter/material.dart';
import '../component /app_colors.dart'; // Verify space in this folder name path
import '../component /beginner.dart';
import '../component /face_assesment.dart';
import '../component /intermediate.dart';
import '../component /advance.dart'; // Keep an eye on advance vs advanced naming schemes
import '../component /tab_bar.dart';
import '../component /bottom_nav_bar.dart';
import 'equipment_list.dart';
import 'face_analysis.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _currentTabIndex = 0;
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: _buildPageContent(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _bottomNavIndex,
        onItemTapped: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_bottomNavIndex) {
      case 0:
        return _buildDashboardContentWrapper();
      case 1:
        return const RoutineTrackerScreen();
      case 2:
        return const ProfileScreen();
      default:
        return _buildDashboardContentWrapper();
    }
  }

  Widget _buildDashboardContentWrapper() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER GREETING & NOTIFICATION BAR OVERLAY ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome back,", style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 4),
                    Text(
                      "Daily Routine",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                // Modern Action Badge Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        // Unseen Indicator Dot
                        Positioned(
                          top: 1,
                          right: 2,
                          child: CircleAvatar(
                            radius: 4,
                            backgroundColor: AppColors.sharpPink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildActionCard(
                "Analyze Face Type",
                "Scan structural contours via AI to unlock target maps.",
                Icons.grid_view,
                const Color(0xFF4FC3F7),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FaceAnalysisScreen()),
                  );
                }),

            const SizedBox(height: 16),
            _buildStreakCard(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSmallCard(
                    "Face Assessment",
                    "Take Face Assessment Test",
                    Icons.face,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FaceAssessmentScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSmallCard(
                    "Face Yoga Equipment",
                    "Tools for Your Ritual",
                    Icons.spa_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EquipmentListScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ModernCategoryTabBar(
              onTabChanged: (index) {
                setState(() => _currentTabIndex = index);
              },
            ),
            const SizedBox(height: 24),
            _buildDashboardContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    if (_currentTabIndex == 0) {
      return const Beginner();
    } else if (_currentTabIndex == 1) {
      return const Intermediate();
    } else {
      return const Advanced();
    }
  }

  // --- Helper Layout Generation Methods ---

  Widget _buildActionCard(
      String title, String subtitle, IconData icon, Color color,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1))),
        child: Row(children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.navy)),
                    Text(subtitle,
                        style: const TextStyle(
                            color: AppColors.textLight, fontSize: 12)),
                  ])),
          const Icon(Icons.chevron_right, color: AppColors.textLight)
        ]),
      ),
    );
  }

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.sharpPink, borderRadius: BorderRadius.circular(16)),
      child: const Row(children: [
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("3 DAY STREAK",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("Keep up the ritual!",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text(
                      "Complete today's routine to secure your skin glow progress.",
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ])),
        Icon(Icons.flash_on, color: Color(0xFFFFD700), size: 32)
      ]),
    );
  }

  Widget _buildSmallCard(String title, String subtitle, IconData icon,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF26A69A)),
              const SizedBox(height: 12),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.navy)),
              Text(subtitle,
                  style:
                  const TextStyle(fontSize: 10, color: AppColors.textLight)),
            ]),
      ),
    );
  }
}