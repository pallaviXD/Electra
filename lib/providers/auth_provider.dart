import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUser {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String dob;
  final int age;

  AuthUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.dob,
    required this.age,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'dob': dob,
        'age': age,
      };

  factory AuthUser.fromJson(Map<String, dynamic> j) => AuthUser(
        id: j['id'],
        fullName: j['fullName'],
        email: j['email'],
        phone: j['phone'],
        dob: j['dob'],
        age: j['age'],
      );
}

class AuthProvider extends ChangeNotifier {
  static const _usersKey = 'electra_users';
  static const _sessionKey = 'electra_session';

  AuthUser? _currentUser;
  bool _isLoading = true;

  AuthUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString(_sessionKey);
    if (sessionJson != null) {
      _currentUser = AuthUser.fromJson(jsonDecode(sessionJson));
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw == null) return {};
    return Map<String, dynamic>.from(jsonDecode(raw));
  }

  Future<void> _saveUsers(Map<String, dynamic> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  /// Returns null on success, error message on failure
  Future<String?> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required DateTime dob,
  }) async {
    final users = await _getUsers();
    if (users.containsKey(email.toLowerCase())) {
      return 'An account with this email already exists.';
    }

    final age = _calcAge(dob);
    if (age < 18) return 'You must be at least 18 years old.';

    final user = AuthUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName,
      email: email.toLowerCase(),
      phone: phone,
      dob: dob.toIso8601String(),
      age: age,
    );

    users[email.toLowerCase()] = {
      ...user.toJson(),
      'password': password, // in production use hashing
    };
    await _saveUsers(users);
    await _startSession(user);
    return null;
  }

  /// Returns null on success, error message on failure
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    final users = await _getUsers();
    final data = users[email.toLowerCase()];
    if (data == null) return 'No account found with this email.';
    if (data['password'] != password) return 'Incorrect password.';

    final user = AuthUser.fromJson(Map<String, dynamic>.from(data));
    await _startSession(user);
    return null;
  }

  Future<void> _startSession(AuthUser user) async {
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode(user.toJson()));
    notifyListeners();
  }

  Future<void> signOut() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    notifyListeners();
  }

  int _calcAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) age--;
    return age;
  }
}
