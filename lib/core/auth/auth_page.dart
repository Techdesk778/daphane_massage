import 'package:daphane_massage/screen/sign_in.dart';
import 'package:daphane_massage/screen/sign_up.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showSignInScreen = true;

  void toggleScreen() {
    setState(() {
      showSignInScreen = !showSignInScreen;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    if (showSignInScreen) {
      return SigninScreen(showSignUpScreen: toggleScreen);
    } else {
      return SignupScreen(showSignInScreen: toggleScreen);
    }
  }
}