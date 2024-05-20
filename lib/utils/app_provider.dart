import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userEmail;

  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;

  AppProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userEmail = prefs.getString('userEmail');
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', _isLoggedIn);
    prefs.setString('userEmail', _userEmail ?? '');
  }

  Future<void> login(String email) async {
    _isLoggedIn = true;
    _userEmail = email;
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userEmail = null;
    await _saveToPrefs();
    notifyListeners();
  }
}
