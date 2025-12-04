class Professional {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String speciality;
  final String description;
  final int score;
  final String address;

  Professional({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.speciality,
    required this.description,
    required this.score,
    required this.address,
  });

  String get fullName => '$firstName $lastName';

  factory Professional.fromJson(Map<String, dynamic> json) {
    return Professional(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      speciality: json['speciality'] ?? '',
      description: json['description'] ?? '',
      score: json['score'] ?? 0,
      address: json['address'] ?? '',
    );
  }
}
