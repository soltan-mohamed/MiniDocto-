class Review {
  final String? id;
  final String professionalId;
  final String patientId;
  final String appointmentId;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  Review({
    this.id,
    required this.professionalId,
    required this.patientId,
    required this.appointmentId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      professionalId: json['professionalId'],
      patientId: json['patientId'],
      appointmentId: json['appointmentId'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'rating': rating,
      'comment': comment,
    };
  }
}
