import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      _isAuthenticated = true;
      final userData = prefs.getString('user');
      if (userData != null) {
      }
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['token']);
      
      _user = User.fromJson(response);
      _isAuthenticated = true;
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.register(data);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response['token']);
      
      _user = User.fromJson(response);
      _isAuthenticated = true;
      
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    
    _user = null;
    _isAuthenticated = false;
    
    notifyListeners();
  }
}
