import 'package:flutter/material.dart';
import '../component /app_colors.dart';
import '../core/logic/security_logic.dart';

// TODO: Ensure this logic utility file import path is added if required by your project architecture:
// import '../core/utils/security_logic.dart';

class SecurityPrivacyScreen extends StatefulWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  State<SecurityPrivacyScreen> createState() => _SecurityPrivacyScreenState();
}

class _SecurityPrivacyScreenState extends State<SecurityPrivacyScreen> {
  // Local state tracking indicators for security configurations
  bool _isTwoFactorEnabled = false;
  bool _isBiometricEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        title: const Text(
            "Security & Privacy",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: ENCRYPTION BANNER CARD ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.03)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.sharpPink.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield_outlined, color: AppColors.sharpPink, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Data Encryption Active",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Your personal spa details and biometric records are securely encrypted end-to-end.",
                          style: TextStyle(color: Colors.white60, fontSize: 12, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- SECTION 2: ACCESS SECURITY CONFIGURATIONS ---
            _buildSectionHeader("ACCOUNT SECURITY"),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
              ),
              child: Column(
                children: [
                  _buildSwitchTile(
                    title: "Two-Factor Auth",
                    sub: "Add an extra layer of protection on logs",
                    icon: Icons.verified_user_outlined,
                    value: _isTwoFactorEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _isTwoFactorEnabled = value;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    title: "Biometric Access",
                    sub: "Use fingerprint or facial ID locks",
                    icon: Icons.fingerprint_outlined,
                    value: _isBiometricEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _isBiometricEnabled = value;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildActionTile(
                    title: "Change Password",
                    sub: "Update account sign-in code regularly",
                    icon: Icons.lock_reset_outlined,
                    // UPDATED: Integrates dynamic asynchronous call matching request routine exactly
                    onTap: () async {
                      await SecurityLogic.requestPasswordReset(); // Call separated logic
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email Sent")));
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- SECTION 3: PRIVACY & LEGAL POLICIES ---
            _buildSectionHeader("DATA MANAGEMENT"),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
              ),
              child: Column(
                children: [
                  _buildActionTile(
                    title: "Privacy Policy",
                    sub: "Learn how we protect your unique facial data",
                    icon: Icons.description_outlined,
                    onTap: () {
                      // TODO: Launch Privacy web view frame
                    },
                  ),
                  _buildDivider(),
                  _buildActionTile(
                    title: "Terms of Service",
                    sub: "Review spa service agreements and use limits",
                    icon: Icons.gavel_outlined,
                    onTap: () {
                      // TODO: Launch Terms document asset
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper title constructor for category sections
  Widget _buildSectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.sharpPink,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  // Custom inner separation line decoration
  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      endIndent: 16,
      color: Colors.white.withOpacity(0.06),
    );
  }

  // Component Builder for Interactive Toggle Switches
  Widget _buildSwitchTile({
    required String title,
    required String sub,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white70, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
        subtitle: Text(sub, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.sharpPink,
          activeTrackColor: AppColors.sharpPink.withOpacity(0.3),
          inactiveThumbColor: Colors.white30,
          inactiveTrackColor: Colors.white10,
        ),
      ),
    );
  }

  // Component Builder for Navigation Action Selections
  Widget _buildActionTile({
    required String title,
    required String sub,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white70, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
        subtitle: Text(sub, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
        trailing: Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3), size: 20),
      ),
    );
  }
}