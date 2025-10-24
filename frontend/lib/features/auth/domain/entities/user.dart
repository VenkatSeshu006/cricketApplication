import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String role;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    required this.role,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor for JSON deserialization
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String?,
      role: json['role'] as String,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'role': role,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    phone,
    role,
    isVerified,
    createdAt,
    updatedAt,
  ];
}
