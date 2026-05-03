import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class SettingsProvider extends ChangeNotifier {
  String _language = 'English';
  User? _currentUser;
  bool _isInitialized = false;

  String get language => _language;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null && !_currentUser!.isAnonymous;

  SettingsProvider() {
    _init();
  }

  void _init() {
    if (_isInitialized) return;
    _isInitialized = true;
    
    // Listen to auth state
    FirebaseService.instance.authStateChanges.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
    
    // Try to get current user immediately
    _currentUser = FirebaseService.instance.currentUser;
  }

  void setLanguage(String newLang) {
    _language = newLang;
    FirebaseService.instance.saveUserPreference('language', newLang);
    notifyListeners();
  }
}
