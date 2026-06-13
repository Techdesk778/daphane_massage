import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daphane_massage/screen/skin_type_selection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../component /app_colors.dart'; // Verify directory spacing inside your project files

class SignupScreen extends StatefulWidget {
  final VoidCallback showSignInScreen;

  // FIXED: Constructor parameterized structure synchronized perfectly
  const SignupScreen({
    super.key,
    required this.showSignInScreen,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  double _progress = 0.8; // Initial onboard step index tracking status (80%)
  bool _isLoading = false;

  // Input Controllers for registration fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(); // Added field tracking
  final TextEditingController _addressController = TextEditingController(); // Added field tracking

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // FIXED: Consolidated into a single secure async auth and database creation pipeline
  void _submitForm() async {
    // Basic structural validation check
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill out your Email and Password details.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _progress = 0.9; // Update progress bar layout context to 90%
    });

    try {
      // 1. Authenticate and register user credentials inside Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final String uid = userCredential.user!.uid;

      // 2. Map structural business profile information directly into your Cloud Firestore NoSQL collection
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'fullName': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'subscriptionPackage': 'Free Tier',
      });

      // 3. Navigate onwards along your onboarding pipeline sequence after a micro-delay frame
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SkinTypeSelectionScreen()),
          );
        }
      });

    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
        _progress = 0.8; // Revert progress step tracking bar on failure
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Registration authorization failed.")),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _progress = 0.8;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Database communication error: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    "${(_progress * 100).toInt()}% Complete",
                    style: const TextStyle(color: Colors.white70, fontSize: 12)
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.white24,
                color: AppColors.sharpPink,
              ),
              const SizedBox(height: 32),

              const Text(
                "Join Glow Maker",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text("Start your journey to better skin today",
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  children: [
                    _buildModernTextField("Full Name", Icons.person_outline, controller: _nameController),
                    const SizedBox(height: 16),
                    _buildModernTextField("Email Address", Icons.email_outlined, controller: _emailController),
                    const SizedBox(height: 16),
                    _buildModernTextField("Phone Number", Icons.phone_outlined, controller: _phoneController),
                    const SizedBox(height: 16),
                    _buildModernTextField("Physical Address", Icons.home_outlined, controller: _addressController),
                    const SizedBox(height: 16),
                    _buildModernTextField("Password", Icons.lock_outline, controller: _passwordController, obscure: true),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sharpPink,
                          disabledBackgroundColor: AppColors.sharpPink.withOpacity(0.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Create Account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),

                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: widget.showSignInScreen,
                      child: const Text(
                        "Already have an account? Sign In",
                        style: TextStyle(color: AppColors.sharpPink, fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernTextField(String hint, IconData icon, {required TextEditingController controller, bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textLight),
        prefixIcon: Icon(icon, color: AppColors.textLight),
        filled: true,
        fillColor: const Color(0xFFF0F0F0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.sharpPink, width: 2)),
      ),
    );
  }
}