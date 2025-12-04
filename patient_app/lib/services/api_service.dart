import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';
  
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, String>> _getHeaders({bool requiresAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (requiresAuth) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: await _getHeaders(),
      body: jsonEncode(data),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur d\'inscription: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: await _getHeaders(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Email ou mot de passe incorrect');
    }
  }

  Future<List<dynamic>> getProfessionals() async {
    final response = await http.get(
      Uri.parse('$baseUrl/professionals'),
      headers: await _getHeaders(requiresAuth: true),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur de chargement des professionnels');
    }
  }

  Future<List<dynamic>> getAvailableSlots(String professionalId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/timeslots/professional/$professionalId/available'),
      headers: await _getHeaders(requiresAuth: true),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur de chargement des créneaux');
    }
  }

  Future<List<dynamic>> getPatientAppointments() async {
    final response = await http.get(
      Uri.parse('$baseUrl/appointments/patient'),
      headers: await _getHeaders(requiresAuth: true),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur de chargement des rendez-vous');
    }
  }

  Future<void> createAppointment(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/appointments'),
      headers: await _getHeaders(requiresAuth: true),
      body: jsonEncode(data),
    );
    
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erreur de création du rendez-vous: ${response.body}');
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/appointments/$appointmentId/cancel'),
      headers: await _getHeaders(requiresAuth: true),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Erreur d\'annulation du rendez-vous');
    }
  }

  Future<void> updateAppointment(String appointmentId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/appointments/$appointmentId'),
      headers: await _getHeaders(requiresAuth: true),
      body: jsonEncode(data),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Erreur de mise à jour du rendez-vous');
    }
  }

  Future<void> addReview(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reviews'),
      headers: await _getHeaders(requiresAuth: true),
      body: jsonEncode(data),
    );
    
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Erreur d\'ajout de l\'avis');
    }
  }
}
