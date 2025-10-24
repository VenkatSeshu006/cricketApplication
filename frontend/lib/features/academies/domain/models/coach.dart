class Coach {
  final String id;
  final String name;
  final String imageUrl;
  final String specialization; // Batting, Bowling, Fielding, etc.
  final int experience; // Years
  final String certification;
  final List<String> achievements;
  final double rating;
  final int studentsTrained;
  final String description;
  final bool isHeadCoach;

  Coach({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.specialization,
    required this.experience,
    required this.certification,
    required this.achievements,
    required this.rating,
    required this.studentsTrained,
    required this.description,
    required this.isHeadCoach,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      specialization: json['specialization'] as String,
      experience: json['experience'] as int,
      certification: json['certification'] as String,
      achievements: (json['achievements'] as List<dynamic>).cast<String>(),
      rating: (json['rating'] as num).toDouble(),
      studentsTrained: json['studentsTrained'] as int,
      description: json['description'] as String,
      isHeadCoach: json['isHeadCoach'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'specialization': specialization,
      'experience': experience,
      'certification': certification,
      'achievements': achievements,
      'rating': rating,
      'studentsTrained': studentsTrained,
      'description': description,
      'isHeadCoach': isHeadCoach,
    };
  }
}
