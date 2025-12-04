class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String roleValue = 'PATIENT';
    
    try {
      if (json['role'] != null) {
        if (json['role'] is String) {
          roleValue = json['role'];
        } else if (json['role'] is Map) {
          roleValue = json['role']['name']?.toString() ?? 'PATIENT';
        } else {
          roleValue = json['role'].toString();
        }
      }
    } catch (e) {
      print('Erreur lors de la conversion du role: $e');
      roleValue = 'PATIENT';
    }
    
    return User(
      id: json['userId']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      role: roleValue,
    );
  }
}
