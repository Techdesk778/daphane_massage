import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../component /app_colors.dart';
import '../core/logic/account_logic.dart';
import '../core/services/user_session.dart';
import 'account_details.dart';
import 'notification_screen.dart';
import 'security_privacy.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _tempImageFile;
  Uint8List? _tempWebImage;

  Future<void> _pickProfileImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _tempWebImage = bytes;
          _tempImageFile = pickedFile;
        });

        // TODO: In production, upload 'bytes' to Firebase Storage
        // and save the URL to Firestore.
        // UserSessionService.instance.updateUserData({'profileImageUrl': downloadUrl});
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to end your ritual session?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
            },
            child: const Text("Logout", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Your Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Map<String, dynamic>?>(
        valueListenable: UserSessionService.instance.currentUserData,
        builder: (context, userData, child) {
          // These now pull directly from the real-time Firestore listener
          final String displayName = userData?['fullName'] ?? "Glow Ritualist";
          final String displayEmail = userData?['email'] ?? FirebaseAuth.instance.currentUser?.email ?? "";
          final String rawPlan = userData?['subscriptionPackage'] ?? "Beginner";
          final String tierLabel = AccountLogic.getTierDisplay(rawPlan);
          final String? firestoreImageUrl = userData?['profileImageUrl'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        backgroundImage: _tempWebImage != null
                            ? MemoryImage(_tempWebImage!)
                            : (firestoreImageUrl != null
                            ? NetworkImage(firestoreImageUrl) as ImageProvider
                            : (_tempImageFile != null && !kIsWeb ? FileImage(File(_tempImageFile!.path)) : null)),
                        child: (_tempWebImage == null && _tempImageFile == null && firestoreImageUrl == null)
                            ? const Icon(Icons.person, size: 60, color: Colors.white70)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickProfileImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(color: AppColors.sharpPink, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(displayName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                Text(displayEmail, style: const TextStyle(fontSize: 14, color: Colors.white70)),
                const SizedBox(height: 32),

                // --- PLAN CARD ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.sharpPink, Color(0xFFD43F8D)]),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.card_membership, size: 40, color: Colors.white),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("CURRENT PLAN", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white70)),
                            const SizedBox(height: 4),
                            Text(tierLabel, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // --- SETTINGS LIST ---
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                  child: Column(
                    children: [
                      _buildSettingTile(
                        icon: Icons.person_outline,
                        title: "Account Details",
                        subtitle: "View your registration info",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountDetailsScreen())),
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildSettingTile(
                        icon: Icons.notifications_none,
                        title: "Notifications",
                        subtitle: "Glow ritual alerts",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen())),
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildSettingTile(
                        icon: Icons.security,
                        title: "Security & Privacy",
                        subtitle: "Manage account safety",
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityPrivacyScreen())),
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildSettingTile(
                        icon: Icons.logout,
                        title: "Log Out",
                        subtitle: "Safely exit active session",
                        iconColor: Colors.redAccent,
                        textColor: Colors.redAccent,
                        onTap: _logout,
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

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = AppColors.sharpPink,
    Color textColor = AppColors.textDark,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textLight, size: 20),
    );
  }
}