import 'package:flutter/material.dart';
import '../component /app_colors.dart';
import '../core/logic/account_logic.dart';
import '../core/services/user_session.dart';

// TODO: Ensure this matches your local project utility structure if not already imported globally:
// import '../core/utils/account_logic.dart';

class AccountDetailsScreen extends StatelessWidget {
  const AccountDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text(
            "Account Details",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Map<String, dynamic>?>(
        valueListenable: UserSessionService.instance.currentUserData,
        builder: (context, userData, child) {
          // Fallbacks handle incomplete optional profiles safely
          final String fullName = userData?['fullName'] ?? "Not Provided";
          final String email = userData?['email'] ?? "Not Provided";
          final String phone = userData?['phoneNumber'] ?? "Not Provided";
          final String address = userData?['address'] ?? "Not Provided";

          // UPDATED: Dynamically parsing matching registration logic through AccountLogic wrapper
          final String rawPlan = userData?['subscriptionPackage'] ?? "Beginner";
          final String plan = AccountLogic.getTierDisplay(rawPlan);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                // --- TOP PROFILE HEADER CARD ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  margin: const EdgeInsets.only(bottom: 28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.02)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withOpacity(0.06), width: 1),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.sharpPink.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.badge_outlined, color: AppColors.sharpPink, size: 36),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        fullName,
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plan.toUpperCase(),
                        style: const TextStyle(color: AppColors.sharpPink, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                    ],
                  ),
                ),

                // --- DATA FIELDS GRID SECTION ---
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
                  ),
                  child: Column(
                    children: [
                      _buildModernDetailItem(
                        label: "Full Name",
                        value: fullName,
                        icon: Icons.person_outline,
                      ),
                      _buildInnerDivider(),
                      _buildModernDetailItem(
                        label: "Email Address",
                        value: email,
                        icon: Icons.mail_outline,
                      ),
                      _buildInnerDivider(),
                      _buildModernDetailItem(
                        label: "Phone Number",
                        value: phone,
                        icon: Icons.phone_android_outlined,
                      ),
                      _buildInnerDivider(),
                      _buildModernDetailItem(
                        label: "Physical Address",
                        value: address,
                        icon: Icons.location_on_outlined,
                      ),
                      _buildInnerDivider(),
                      _buildModernDetailItem(
                        label: "Subscription Plan",
                        value: plan,
                        icon: Icons.card_membership_outlined,
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

  // Modern, highly scannable List Tile variation for clean field parsing
  Widget _buildModernDetailItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.white60, size: 20),
        ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: Text(
              label,
              style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // Subtle clean delimiter separator line
  Widget _buildInnerDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 68,
      endIndent: 20,
      color: Colors.white.withOpacity(0.05),
    );
  }
}