import 'package:daphane_massage/core/auth/auth_page.dart';

import 'package:daphane_massage/screen/user_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show a loader while Firebase is initializing/checking auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF2E63)),
            );
          }

          // If a user is found, go to Dashboard
          if (snapshot.hasData) {
            return const UserDashboard();
          }

          // Otherwise, go to Sign In
          return const AuthPage();
        },
      ),
    );
  }
}