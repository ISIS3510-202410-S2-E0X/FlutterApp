import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class SettingsManager {
  late final String _prefixKey;
  SharedPreferences? _prefs;

  SettingsManager() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      String sanitizedEmail = sanitizeEmail(user.email!);
      _prefixKey = '$sanitizedEmail';
    } else {
      throw Exception('User is not logged in or email is null.');
    }
  }

  String sanitizeEmail(String email) {
    // More robust sanitization can be added here as needed
    return email.replaceAll('.', '_').replaceAll('@', '_');
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> getBool(String key, bool defaultValue) async {
    return _prefs?.getBool(_prefixKey + key) ?? defaultValue;
  }

  Future<int> getInt(String key, int defaultValue) async {
    return _prefs?.getInt(_prefixKey + key) ?? defaultValue;
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(_prefixKey + key, value);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(_prefixKey + key, value);
  }
}
