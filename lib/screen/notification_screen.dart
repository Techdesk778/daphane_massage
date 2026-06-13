import 'package:flutter/material.dart';
import '../component /app_colors.dart';

// 1. Notification Model to manage local state mutations
class RitualNotification {
  final String id;
  final String title;
  final String body;
  final String timestamp;
  bool isRead;

  RitualNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Mock data representing incoming application alerts
  final List<RitualNotification> _notifications = [
    RitualNotification(
      id: "1",
      title: "Glow Ritual Scheduled Successfully",
      body: "Your Lavender Aromatherapy Session has been locked in for tomorrow at 2:30 PM with Therapist Sarah.",
      timestamp: "2 mins ago",
      isRead: false,
    ),
    RitualNotification(
      id: "2",
      title: "Exclusive Pro-Tier Spa Perk Unlocked!",
      body: "Tap here to claim your complimentary Deep Tissue hydration enhancer token before your next check-in.",
      timestamp: "1 hour ago",
      isRead: false,
    ),
    RitualNotification(
      id: "3",
      title: "Subscription Renewal Confirmed",
      body: "Thank you for maintaining your Glow Elite Pass membership package. Your billing period has refreshed cleanly.",
      timestamp: "Yesterday",
      isRead: true,
    ),
  ];

  // Helper calculation to clear all unseen markers cleanly
  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text(
            "Ritual Alerts",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                "Mark all read",
                style: TextStyle(color: AppColors.sharpPink, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  // Modern Card Component with state-driven typography configurations
  Widget _buildNotificationCard(RitualNotification item) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        // Dynamic Card Color: Unread items pop cleanly, read items recede subtly into the background
        color: item.isRead ? Colors.white.withOpacity(0.04) : Colors.white.withOpacity(0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: item.isRead ? Colors.transparent : AppColors.sharpPink.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          onTap: () {
            setState(() {
              item.isRead = true; // Flips state flag to mutate styles dynamically
            });
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.isRead ? Colors.white10 : AppColors.sharpPink.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.isRead ? Icons.notifications_none : Icons.notifications_active_outlined,
                  color: item.isRead ? Colors.white38 : AppColors.sharpPink,
                  size: 24,
                ),
              ),
              if (!item.isRead)
                const Positioned(
                  top: 2,
                  right: 2,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: AppColors.sharpPink,
                  ),
                ),
            ],
          ),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    // FIXED TEXT COLOR MUTATION: Vibrant White for Unread vs Faded White70 for Read
                    style: TextStyle(
                      color: item.isRead ? Colors.white60 : Colors.white,
                      fontWeight: item.isRead ? FontWeight.w500 : FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item.timestamp,
                  style: TextStyle(
                    color: item.isRead ? Colors.white30 : Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          subtitle: Text(
            item.body,
            // FIXED TEXT COLOR MUTATION: Faded details display context shift on selection
            style: TextStyle(
              color: item.isRead ? Colors.white38 : Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  // Minimalist Fallback Component Layout UI
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_none, size: 64, color: Colors.white.withOpacity(0.15)),
          ),
          const SizedBox(height: 20),
          const Text(
              "No new ritual alerts",
              style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600)
          ),
          const SizedBox(height: 4),
          const Text(
              "We will let you know when updates arrive.",
              style: TextStyle(color: Colors.white30, fontSize: 13)
          ),
        ],
      ),
    );
  }
}