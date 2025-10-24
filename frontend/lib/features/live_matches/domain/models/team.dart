class Team {
  final String id;
  final String name;
  final String shortName;
  final String? logoUrl;
  final List<String> colors;
  final String? captainId;
  final bool isActive;
  final String? description;
  final String? homeGround;
  final int totalMatches;
  final int wins;
  final int losses;
  final int draws;
  final String createdAt;

  Team({
    required this.id,
    required this.name,
    required this.shortName,
    this.logoUrl,
    required this.colors,
    this.captainId,
    required this.isActive,
    this.description,
    this.homeGround,
    required this.totalMatches,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.createdAt,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      logoUrl: json['logoUrl'] as String?,
      colors: List<String>.from(json['colors'] ?? []),
      captainId: json['captainId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      description: json['description'] as String?,
      homeGround: json['homeGround'] as String?,
      totalMatches: json['totalMatches'] as int? ?? 0,
      wins: json['wins'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
      draws: json['draws'] as int? ?? 0,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'logoUrl': logoUrl,
      'colors': colors,
      'captainId': captainId,
      'isActive': isActive,
      'description': description,
      'homeGround': homeGround,
      'totalMatches': totalMatches,
      'wins': wins,
      'losses': losses,
      'draws': draws,
      'createdAt': createdAt,
    };
  }

  double get winPercentage {
    if (totalMatches == 0) return 0.0;
    return (wins / totalMatches) * 100;
  }
}
