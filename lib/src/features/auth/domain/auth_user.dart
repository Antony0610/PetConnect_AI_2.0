class AuthUser {
  final String uid;
  final String email;
  final String displayName;
  final String role; // 'pet_owner', 'vet', 'volunteer', 'admin'
  final bool isBiometricEnabled;
  final DateTime createdAt;

  const AuthUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.isBiometricEnabled = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'role': role,
        'isBiometricEnabled': isBiometricEnabled,
        'createdAt': createdAt.toIso8601String(),
      };

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        uid: json['uid'],
        email: json['email'],
        displayName: json['displayName'],
        role: json['role'],
        isBiometricEnabled: json['isBiometricEnabled'] ?? false,
        createdAt: DateTime.parse(json['createdAt']),
      );
}
