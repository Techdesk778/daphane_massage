
import 'package:daphane_massage/screen/admin_dashboard.dart';
import 'package:daphane_massage/screen/onboarding.dart';
import 'package:daphane_massage/screen/sign_in.dart';
import 'package:daphane_massage/screen/sign_up.dart';
import 'package:daphane_massage/screen/user_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



void main() {
  runApp(const GlowStudioApp());
}

class GlowStudioApp extends StatelessWidget {
  const GlowStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glow Studio',
      debugShowCheckedModeBanner: false,

      // Applying Lato globally via theme
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(),
        useMaterial3: true,
      ),

      // Set directly to onboarding as requested
      home: const AdminDashboard(),

      // Route definitions for navigation
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/signIn': (context) => const SigninScreen(),
        '/signUp': (context) => const SignupScreen(),
        '/dashboard': (context) => const UserDashboard(),
      },
    );
  }
}