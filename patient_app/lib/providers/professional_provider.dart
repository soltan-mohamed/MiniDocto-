import 'package:flutter/foundation.dart';
import '../models/professional.dart';
import '../services/api_service.dart';

class ProfessionalProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Professional> _professionals = [];
  bool _isLoading = false;
  String? _error;

  List<Professional> get professionals => _professionals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProfessionals() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.getProfessionals();
      _professionals = data.map((json) => Professional.fromJson(json)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
