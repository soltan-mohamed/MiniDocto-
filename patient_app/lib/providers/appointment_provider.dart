import 'package:flutter/foundation.dart';
import '../models/appointment.dart';
import '../services/api_service.dart';

class AppointmentProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Appointment> _appointments = [];
  bool _isLoading = false;
  String? _error;

  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAppointments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.getPatientAppointments();
      _appointments = data.map((json) => Appointment.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createAppointment(Map<String, dynamic> data) async {
    try {
      await _apiService.createAppointment(data);
      await loadAppointments();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await _apiService.cancelAppointment(appointmentId);
      await loadAppointments();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAppointment(String appointmentId, Map<String, dynamic> data) async {
    try {
      await _apiService.updateAppointment(appointmentId, data);
      await loadAppointments();
    } catch (e) {
      rethrow;
    }
  }
}
