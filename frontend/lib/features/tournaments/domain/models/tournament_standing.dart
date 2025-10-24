class TournamentStanding {
  final String id;
  final String tournamentId;
  final String teamId;
  final int position;
  final int matchesPlayed;
  final int matchesWon;
  final int matchesLost;
  final int matchesDrawn;
  final int matchesAbandoned;
  final int points;
  final double netRunRate;
  final int runsScored;
  final int runsConceded;
  final int wicketsTaken;
  final int wicketsLost;
  final String updatedAt;

  TournamentStanding({
    required this.id,
    required this.tournamentId,
    required this.teamId,
    required this.position,
    required this.matchesPlayed,
    required this.matchesWon,
    required this.matchesLost,
    required this.matchesDrawn,
    required this.matchesAbandoned,
    required this.points,
    required this.netRunRate,
    required this.runsScored,
    required this.runsConceded,
    required this.wicketsTaken,
    required this.wicketsLost,
    required this.updatedAt,
  });

  factory TournamentStanding.fromJson(Map<String, dynamic> json) {
    return TournamentStanding(
      id: json['id'] as String,
      tournamentId: json['tournamentId'] as String,
      teamId: json['teamId'] as String,
      position: json['position'] as int,
      matchesPlayed: json['matchesPlayed'] as int,
      matchesWon: json['matchesWon'] as int,
      matchesLost: json['matchesLost'] as int,
      matchesDrawn: json['matchesDrawn'] as int? ?? 0,
      matchesAbandoned: json['matchesAbandoned'] as int? ?? 0,
      points: json['points'] as int,
      netRunRate: (json['netRunRate'] as num?)?.toDouble() ?? 0.0,
      runsScored: json['runsScored'] as int? ?? 0,
      runsConceded: json['runsConceded'] as int? ?? 0,
      wicketsTaken: json['wicketsTaken'] as int? ?? 0,
      wicketsLost: json['wicketsLost'] as int? ?? 0,
      updatedAt: json['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournamentId': tournamentId,
      'teamId': teamId,
      'position': position,
      'matchesPlayed': matchesPlayed,
      'matchesWon': matchesWon,
      'matchesLost': matchesLost,
      'matchesDrawn': matchesDrawn,
      'matchesAbandoned': matchesAbandoned,
      'points': points,
      'netRunRate': netRunRate,
      'runsScored': runsScored,
      'runsConceded': runsConceded,
      'wicketsTaken': wicketsTaken,
      'wicketsLost': wicketsLost,
      'updatedAt': updatedAt,
    };
  }

  double get winPercentage {
    if (matchesPlayed == 0) return 0.0;
    return (matchesWon / matchesPlayed) * 100;
  }
}
