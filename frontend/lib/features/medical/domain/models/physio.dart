class Physio {
  final String id;
  final String name;
  final String qualification;
  final String specialization;
  final int experience; // years
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String location;
  final String clinic;
  final String about;
  final List<String> expertise;
  final List<String> languages;
  final double consultationFee;
  final bool isAvailable;
  final String nextAvailable;
  final List<String> workingDays;
  final String workingHours;
  final List<String> certifications;

  Physio({
    required this.id,
    required this.name,
    required this.qualification,
    required this.specialization,
    required this.experience,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.clinic,
    required this.about,
    required this.expertise,
    required this.languages,
    required this.consultationFee,
    required this.isAvailable,
    required this.nextAvailable,
    required this.workingDays,
    required this.workingHours,
    required this.certifications,
  });

  factory Physio.fromJson(Map<String, dynamic> json) {
    return Physio(
      id: json['id'] as String,
      name: json['name'] as String,
      qualification: json['qualification'] as String,
      specialization: json['specialization'] as String,
      experience: json['experience'] as int,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      location: json['location'] as String,
      clinic: json['clinic'] as String,
      about: json['about'] as String,
      expertise: (json['expertise'] as List<dynamic>).cast<String>(),
      languages: (json['languages'] as List<dynamic>).cast<String>(),
      consultationFee: (json['consultationFee'] as num).toDouble(),
      isAvailable: json['isAvailable'] as bool,
      nextAvailable: json['nextAvailable'] as String,
      workingDays: (json['workingDays'] as List<dynamic>).cast<String>(),
      workingHours: json['workingHours'] as String,
      certifications: (json['certifications'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'qualification': qualification,
      'specialization': specialization,
      'experience': experience,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'location': location,
      'clinic': clinic,
      'about': about,
      'expertise': expertise,
      'languages': languages,
      'consultationFee': consultationFee,
      'isAvailable': isAvailable,
      'nextAvailable': nextAvailable,
      'workingDays': workingDays,
      'workingHours': workingHours,
      'certifications': certifications,
    };
  }
}

class PhysioReview {
  final String id;
  final String patientName;
  final double rating;
  final String comment;
  final String date;
  final String treatmentType;

  PhysioReview({
    required this.id,
    required this.patientName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.treatmentType,
  });

  factory PhysioReview.fromJson(Map<String, dynamic> json) {
    return PhysioReview(
      id: json['id'] as String,
      patientName: json['patientName'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      date: json['date'] as String,
      treatmentType: json['treatmentType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientName': patientName,
      'rating': rating,
      'comment': comment,
      'date': date,
      'treatmentType': treatmentType,
    };
  }
}
