import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Screen views
  static Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  // Login events
  static Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  // Sign up events
  static Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  // Appointment events
  static Future<void> logAppointmentBooked({
    required String professionalId,
    required String professionalName,
    required String date,
  }) async {
    await _analytics.logEvent(
      name: 'appointment_booked',
      parameters: {
        'professional_id': professionalId,
        'professional_name': professionalName,
        'appointment_date': date,
      },
    );
  }

  static Future<void> logAppointmentCancelled(String appointmentId) async {
    await _analytics.logEvent(
      name: 'appointment_cancelled',
      parameters: {'appointment_id': appointmentId},
    );
  }

  // Review events
  static Future<void> logReviewSubmitted({
    required String appointmentId,
    required int rating,
  }) async {
    await _analytics.logEvent(
      name: 'review_submitted',
      parameters: {
        'appointment_id': appointmentId,
        'rating': rating,
      },
    );
  }

  // Search events
  static Future<void> logSearch(String searchTerm) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  // Professional view
  static Future<void> logProfessionalView({
    required String professionalId,
    required String professionalName,
    required String specialty,
  }) async {
    await _analytics.logEvent(
      name: 'view_professional',
      parameters: {
        'professional_id': professionalId,
        'professional_name': professionalName,
        'specialty': specialty,
      },
    );
  }

  // User properties
  static Future<void> setUserRole(String role) async {
    await _analytics.setUserProperty(name: 'user_role', value: role);
  }

  static Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
  }
}
