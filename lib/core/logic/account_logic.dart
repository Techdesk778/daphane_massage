import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountLogic {
  /// Logic 1: Tier Plan Logic
  /// Beginner = Free Tier, Intermediate/Advanced = Paid Plan
  static String getTierDisplay(String? subscriptionPackage) {
    if (subscriptionPackage == null) return "Free Tier";
    final package = subscriptionPackage.toLowerCase().trim();
    if (package == 'beginner') return "Free Tier";
    if (package == 'intermediate' || package == 'advanced') return "Paid Plan";
    return "Free Tier";
  }

  /// Logic 2: Store User Information during registration
  static Future<void> saveUserRegistration({
    required String uid,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String address,
  }) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'createdAt': FieldValue.serverTimestamp(),
      'subscriptionPackage': 'Beginner', // Default plan
    });
  }
}