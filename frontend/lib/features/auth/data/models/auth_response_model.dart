class AuthResponseModel {
  final UserData user;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  AuthResponseModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AuthResponseModel(
      user: UserData.fromJson(data['user'] as Map<String, dynamic>),
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
      expiresIn: data['expires_in'] as int,
    );
  }
}

class UserData {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String role;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserData({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    required this.role,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      isVerified: json['is_verified'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
