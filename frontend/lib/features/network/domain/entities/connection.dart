import 'package:equatable/equatable.dart';

class Connection extends Equatable {
  final String id;
  final String name;
  final String role;
  final String designation;
  final String location;
  final int mutualConnections;
  final String? profileImage;
  final String? bio;
  final bool isConnected;

  const Connection({
    required this.id,
    required this.name,
    required this.role,
    required this.designation,
    required this.location,
    required this.mutualConnections,
    this.profileImage,
    this.bio,
    this.isConnected = false,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    role,
    designation,
    location,
    mutualConnections,
    profileImage,
    bio,
    isConnected,
  ];

  Connection copyWith({
    String? id,
    String? name,
    String? role,
    String? designation,
    String? location,
    int? mutualConnections,
    String? profileImage,
    String? bio,
    bool? isConnected,
  }) {
    return Connection(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      designation: designation ?? this.designation,
      location: location ?? this.location,
      mutualConnections: mutualConnections ?? this.mutualConnections,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
