import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static final FirebaseService instance = FirebaseService._();
  
  FirebaseService._();
  
  bool _isInitialized = false;
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await Firebase.initializeApp();
      _isInitialized = true;
      if (kDebugMode) print('Firebase initialized successfully');
    } catch (e) {
      // Firebase not configured — app runs in offline/guest mode
      // Run `flutterfire configure` to enable full Firebase features
      if (kDebugMode) print('Firebase not configured, running in guest mode: $e');
      _isInitialized = false;
    }
  }

  Future<UserCredential?> signInAnonymously() async {
    if (!_isInitialized) return null;
    try {
      return await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      if (kDebugMode) print('Auth error: $e');
      return null;
    }
  }

  Future<UserCredential?> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required DateTime dob,
  }) async {
    if (!_isInitialized) return null;
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Update display name
      await cred.user?.updateDisplayName(fullName);
      // Save profile to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'dob': dob.toIso8601String(),
        'age': _calculateAge(dob),
        'registeredAt': DateTime.now().toIso8601String(),
      });
      return cred;
    } catch (e) {
      if (kDebugMode) print('Registration error: $e');
      rethrow;
    }
  }

  int _calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  Future<UserCredential?> loginWithEmail(String email, String password) async {
    if (!_isInitialized) return null;
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (kDebugMode) print('Login error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    if (!_isInitialized) return;
    await FirebaseAuth.instance.signOut();
  }

  User? get currentUser => _isInitialized ? FirebaseAuth.instance.currentUser : null;

  Stream<User?> get authStateChanges => _isInitialized 
      ? FirebaseAuth.instance.authStateChanges() 
      : const Stream.empty();

  Future<void> saveUserPreference(String key, dynamic value) async {
    if (!_isInitialized) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({key: value}, SetOptions(merge: true));
    }
  }
}
