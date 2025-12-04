class Appointment {
  final String id;
  final String patientId;
  final String patientName;
  final String professionalId;
  final String professionalName;
  final String professionalSpeciality;
  final DateTime appointmentTime;
  final String status;
  final String? reason;
  final String? notes;
  final bool hasReview;

  Appointment({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.professionalId,
    required this.professionalName,
    required this.professionalSpeciality,
    required this.appointmentTime,
    required this.status,
    this.reason,
    this.notes,
    this.hasReview = false,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      patientName: json['patientName'] ?? '',
      professionalId: json['professionalId'] ?? '',
      professionalName: json['professionalName'] ?? '',
      professionalSpeciality: json['professionalSpeciality'] ?? '',
      appointmentTime: DateTime.parse(json['appointmentTime']),
      status: json['status']?.toString() ?? '',
      reason: json['reason'],
      notes: json['notes'],
      hasReview: json['hasReview'] ?? false,
    );
  }
}
