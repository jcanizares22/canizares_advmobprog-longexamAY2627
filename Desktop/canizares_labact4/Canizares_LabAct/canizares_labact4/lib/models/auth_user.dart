class AuthUser {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String? token;

  const AuthUser({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.token,
  });

  String get displayName => '$firstName $lastName'.trim().isEmpty
      ? username
      : '$firstName $lastName'.trim();

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      token: json['accessToken'] as String? ?? json['token'] as String?,
    );
  }
}
