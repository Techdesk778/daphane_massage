import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSessionService {
  UserSessionService._privateConstructor();
  static final UserSessionService instance = UserSessionService._privateConstructor();

  final ValueNotifier<Map<String, dynamic>?> currentUserData = ValueNotifier<Map<String, dynamic>?>(null);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription<DocumentSnapshot>? _userSubscription;

  void initializeSessionTracker() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        _userSubscription?.cancel();
        currentUserData.value = null;
      } else {
        _listenToUserData(user.uid);
      }
    });
  }

  // Listen to real-time updates so the UI populates as soon as the doc exists
  void _listenToUserData(String uid) {
    _userSubscription?.cancel();
    _userSubscription = _firestore.collection('users').doc(uid).snapshots().listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        currentUserData.value = snapshot.data() as Map<String, dynamic>?;
      }
    }, onError: (e) {
      debugPrint("Error listening to user session: $e");
    });
  }

  Future<void> fetchAndBindUserData(String uid) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        currentUserData.value = snapshot.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      debugPrint("Error fetching user session from Firestore: $e");
    }
  }
}