import 'package:daphane_massage/core/services/main_page.dart';
import 'package:daphane_massage/core/auth/auth_page.dart';
import 'package:daphane_massage/screen/onboarding.dart';
import 'package:daphane_massage/screen/user_dashboard.dart';
import 'package:daphane_massage/screen/admin_dashboard.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/services/user_session.dart';
import 'firebase_options.dart'; // 1. Import your newly generated options file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 2. This single line dynamically reads configurations for web, android, or ios automatically
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
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
      home: const MainPage(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/signIn': (context) => const AuthPage(),
        '/signUp': (context) => const AuthPage(),
        '/dashboard': (context) => const UserDashboard(),
        '/admin': (context) => const AdminDashboard(),
      },
    );
  }
}