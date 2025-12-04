class TimeSlot {
  final String id;
  final String professionalId;
  final DateTime startTime;
  final DateTime endTime;
  final bool available;

  TimeSlot({
    required this.id,
    required this.professionalId,
    required this.startTime,
    required this.endTime,
    required this.available,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'] ?? '',
      professionalId: json['professionalId'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      available: json['available'] ?? false,
    );
  }
}
