class Player {
  final String id;
  final String userId;
  final String teamId;
  final int jerseyNumber;
  final String role; // batsman, bowler, all-rounder, wicket-keeper
  final String batting; // right-hand, left-hand
  final String? bowling; // right-arm-fast, left-arm-spin, etc.
  final bool isActive;
  final int matchesPlayed;
  final int runsScored;
  final int wicketsTaken;
  final int catches;
  final String joinedAt;

  Player({
    required this.id,
    required this.userId,
    required this.teamId,
    required this.jerseyNumber,
    required this.role,
    required this.batting,
    this.bowling,
    required this.isActive,
    required this.matchesPlayed,
    required this.runsScored,
    required this.wicketsTaken,
    required this.catches,
    required this.joinedAt,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      userId: json['userId'] as String,
      teamId: json['teamId'] as String,
      jerseyNumber: json['jerseyNumber'] as int,
      role: json['role'] as String,
      batting: json['batting'] as String,
      bowling: json['bowling'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      matchesPlayed: json['matchesPlayed'] as int? ?? 0,
      runsScored: json['runsScored'] as int? ?? 0,
      wicketsTaken: json['wicketsTaken'] as int? ?? 0,
      catches: json['catches'] as int? ?? 0,
      joinedAt: json['joinedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'teamId': teamId,
      'jerseyNumber': jerseyNumber,
      'role': role,
      'batting': batting,
      'bowling': bowling,
      'isActive': isActive,
      'matchesPlayed': matchesPlayed,
      'runsScored': runsScored,
      'wicketsTaken': wicketsTaken,
      'catches': catches,
      'joinedAt': joinedAt,
    };
  }

  double get battingAverage {
    if (matchesPlayed == 0) return 0.0;
    return runsScored / matchesPlayed;
  }

  double get bowlingAverage {
    if (wicketsTaken == 0) return 0.0;
    return runsScored / wicketsTaken; // Simplified
  }
}
