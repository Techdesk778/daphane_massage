import 'package:daphane_massage/core/services/main_page.dart';
import 'package:daphane_massage/core/auth/auth_page.dart'; // Added this import
import 'package:daphane_massage/screen/onboarding.dart';
import 'package:daphane_massage/screen/user_dashboard.dart';
import 'package:daphane_massage/screen/admin_dashboard.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/services/user_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // For Web, provide options explicitly
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyB0OSlVI_kx8mQBXc-r8FD1dMIatIvxKHY",
        authDomain: "daphane-massage.firebaseapp.com",
        projectId: "daphane-massage",
        storageBucket: "daphane-massage.firebasestorage.app",
        messagingSenderId: "523806673732",
        appId: "1:523806673732:web:360d67500c12cf29506511",
        measurementId: "G-NSGPGFQH0M",
      ),
    );
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }
  UserSessionService.instance.initializeSessionTracker();
  runApp(const GlowStudioApp());
}

class GlowStudioApp extends StatelessWidget {
  const GlowStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glow Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
        useMaterial3: true,
      ),

      // Set MainPage as the home so it can handle Auth state (Login vs Dashboard)
      home: const MainPage(),

      // Route definitions
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        // FIXED: Use AuthPage for both routes to satisfy required parameters
        '/signIn': (context) => const AuthPage(),
        '/signUp': (context) => const AuthPage(),
        '/dashboard': (context) => const UserDashboard(),
        '/admin': (context) => const AdminDashboard(),
      },
    );
  }
}