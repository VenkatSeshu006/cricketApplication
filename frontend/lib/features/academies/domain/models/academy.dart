class Academy {
  final String id;
  final String name;
  final String location;
  final String address;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> programs; // Batting, Bowling, Fielding, All-Round, etc.
  final List<String> facilities;
  final List<String> coaches;
  final String established;
  final int totalStudents;
  final List<String> ageGroups; // U-12, U-15, U-19, Adult, etc.
  final Map<String, double> fees; // Program -> Monthly fee
  final String contactNumber;
  final String email;
  final String timing;
  final bool hasAccommodation;
  final bool hasPlayground;
  final bool hasCertification;
  final double latitude;
  final double longitude;
  final List<String> achievements;
  final String ownerName;

  Academy({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.programs,
    required this.facilities,
    required this.coaches,
    required this.established,
    required this.totalStudents,
    required this.ageGroups,
    required this.fees,
    required this.contactNumber,
    required this.email,
    required this.timing,
    required this.hasAccommodation,
    required this.hasPlayground,
    required this.hasCertification,
    required this.latitude,
    required this.longitude,
    required this.achievements,
    required this.ownerName,
  });

  factory Academy.fromJson(Map<String, dynamic> json) {
    return Academy(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      address: json['address'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      description: json['description'] as String,
      programs: (json['programs'] as List<dynamic>).cast<String>(),
      facilities: (json['facilities'] as List<dynamic>).cast<String>(),
      coaches: (json['coaches'] as List<dynamic>).cast<String>(),
      established: json['established'] as String,
      totalStudents: json['totalStudents'] as int,
      ageGroups: (json['ageGroups'] as List<dynamic>).cast<String>(),
      fees: Map<String, double>.from(json['fees'] as Map),
      contactNumber: json['contactNumber'] as String,
      email: json['email'] as String,
      timing: json['timing'] as String,
      hasAccommodation: json['hasAccommodation'] as bool,
      hasPlayground: json['hasPlayground'] as bool,
      hasCertification: json['hasCertification'] as bool,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      achievements: (json['achievements'] as List<dynamic>).cast<String>(),
      ownerName: json['ownerName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'address': address,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'description': description,
      'programs': programs,
      'facilities': facilities,
      'coaches': coaches,
      'established': established,
      'totalStudents': totalStudents,
      'ageGroups': ageGroups,
      'fees': fees,
      'contactNumber': contactNumber,
      'email': email,
      'timing': timing,
      'hasAccommodation': hasAccommodation,
      'hasPlayground': hasPlayground,
      'hasCertification': hasCertification,
      'latitude': latitude,
      'longitude': longitude,
      'achievements': achievements,
      'ownerName': ownerName,
    };
  }
}
