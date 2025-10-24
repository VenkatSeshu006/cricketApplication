class Staff {
  final String id;
  final String name;
  final String role; // Coach, Umpire, Groundskeeper
  final String? qualification;
  final String? specialization;
  final int experience; // in years
  final double rating;
  final int reviewCount;
  final String location;
  final String? organization;
  final String about;
  final List<String> expertise;
  final List<String> languages;
  final List<String> certifications;
  final double hourlyRate;
  final bool isAvailable;
  final String? nextAvailable;
  final List<String> availability; // Days of week
  final String? profileImage;
  final int matchesHandled;
  final List<String> tournaments;

  Staff({
    required this.id,
    required this.name,
    required this.role,
    this.qualification,
    this.specialization,
    required this.experience,
    required this.rating,
    required this.reviewCount,
    required this.location,
    this.organization,
    required this.about,
    required this.expertise,
    required this.languages,
    required this.certifications,
    required this.hourlyRate,
    required this.isAvailable,
    this.nextAvailable,
    required this.availability,
    this.profileImage,
    required this.matchesHandled,
    required this.tournaments,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      qualification: json['qualification'],
      specialization: json['specialization'],
      experience: json['experience'],
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      location: json['location'],
      organization: json['organization'],
      about: json['about'],
      expertise: List<String>.from(json['expertise']),
      languages: List<String>.from(json['languages']),
      certifications: List<String>.from(json['certifications']),
      hourlyRate: json['hourlyRate'].toDouble(),
      isAvailable: json['isAvailable'],
      nextAvailable: json['nextAvailable'],
      availability: List<String>.from(json['availability']),
      profileImage: json['profileImage'],
      matchesHandled: json['matchesHandled'],
      tournaments: List<String>.from(json['tournaments']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'qualification': qualification,
      'specialization': specialization,
      'experience': experience,
      'rating': rating,
      'reviewCount': reviewCount,
      'location': location,
      'organization': organization,
      'about': about,
      'expertise': expertise,
      'languages': languages,
      'certifications': certifications,
      'hourlyRate': hourlyRate,
      'isAvailable': isAvailable,
      'nextAvailable': nextAvailable,
      'availability': availability,
      'profileImage': profileImage,
      'matchesHandled': matchesHandled,
      'tournaments': tournaments,
    };
  }
}

class StaffReview {
  final String id;
  final String clientName;
  final double rating;
  final String comment;
  final DateTime date;
  final String? eventType;

  StaffReview({
    required this.id,
    required this.clientName,
    required this.rating,
    required this.comment,
    required this.date,
    this.eventType,
  });

  factory StaffReview.fromJson(Map<String, dynamic> json) {
    return StaffReview(
      id: json['id'],
      clientName: json['clientName'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      date: DateTime.parse(json['date']),
      eventType: json['eventType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'eventType': eventType,
    };
  }
}
