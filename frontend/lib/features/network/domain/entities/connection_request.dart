import 'package:equatable/equatable.dart';

class ConnectionRequest extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String role;
  final String designation;
  final String location;
  final int mutualConnections;
  final String? profileImage;
  final String? message;
  final DateTime requestedAt;
  final ConnectionRequestStatus status;

  const ConnectionRequest({
    required this.id,
    required this.userId,
    required this.name,
    required this.role,
    required this.designation,
    required this.location,
    required this.mutualConnections,
    this.profileImage,
    this.message,
    required this.requestedAt,
    this.status = ConnectionRequestStatus.pending,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    role,
    designation,
    location,
    mutualConnections,
    profileImage,
    message,
    requestedAt,
    status,
  ];

  ConnectionRequest copyWith({
    String? id,
    String? userId,
    String? name,
    String? role,
    String? designation,
    String? location,
    int? mutualConnections,
    String? profileImage,
    String? message,
    DateTime? requestedAt,
    ConnectionRequestStatus? status,
  }) {
    return ConnectionRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      role: role ?? this.role,
      designation: designation ?? this.designation,
      location: location ?? this.location,
      mutualConnections: mutualConnections ?? this.mutualConnections,
      profileImage: profileImage ?? this.profileImage,
      message: message ?? this.message,
      requestedAt: requestedAt ?? this.requestedAt,
      status: status ?? this.status,
    );
  }
}

enum ConnectionRequestStatus { pending, accepted, rejected }
