class PlayerPerformance {
  final String id;
  final String playerId;
  final String matchId;
  final String teamId;
  final bool played;
  final bool captain;
  final bool viceCaptain;
  final bool wicketKeeper;
  final int? battingPosition;
  final int runsScored;
  final int ballsFaced;
  final int fours;
  final int sixes;
  final double strikeRate;
  final String? dismissalType;
  final double oversBowled;
  final int runsConceded;
  final int wicketsTaken;
  final int maidens;
  final double economyRate;
  final int catches;
  final int runOuts;
  final int stumpings;
  final bool playerOfMatch;
  final String createdAt;

  PlayerPerformance({
    required this.id,
    required this.playerId,
    required this.matchId,
    required this.teamId,
    required this.played,
    required this.captain,
    required this.viceCaptain,
    required this.wicketKeeper,
    this.battingPosition,
    required this.runsScored,
    required this.ballsFaced,
    required this.fours,
    required this.sixes,
    required this.strikeRate,
    this.dismissalType,
    required this.oversBowled,
    required this.runsConceded,
    required this.wicketsTaken,
    required this.maidens,
    required this.economyRate,
    required this.catches,
    required this.runOuts,
    required this.stumpings,
    required this.playerOfMatch,
    required this.createdAt,
  });

  factory PlayerPerformance.fromJson(Map<String, dynamic> json) {
    return PlayerPerformance(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      matchId: json['matchId'] as String,
      teamId: json['teamId'] as String,
      played: json['played'] as bool? ?? true,
      captain: json['captain'] as bool? ?? false,
      viceCaptain: json['viceCaptain'] as bool? ?? false,
      wicketKeeper: json['wicketKeeper'] as bool? ?? false,
      battingPosition: json['battingPosition'] as int?,
      runsScored: json['runsScored'] as int? ?? 0,
      ballsFaced: json['ballsFaced'] as int? ?? 0,
      fours: json['fours'] as int? ?? 0,
      sixes: json['sixes'] as int? ?? 0,
      strikeRate: (json['strikeRate'] as num?)?.toDouble() ?? 0.0,
      dismissalType: json['dismissalType'] as String?,
      oversBowled: (json['oversBowled'] as num?)?.toDouble() ?? 0.0,
      runsConceded: json['runsConceded'] as int? ?? 0,
      wicketsTaken: json['wicketsTaken'] as int? ?? 0,
      maidens: json['maidens'] as int? ?? 0,
      economyRate: (json['economyRate'] as num?)?.toDouble() ?? 0.0,
      catches: json['catches'] as int? ?? 0,
      runOuts: json['runOuts'] as int? ?? 0,
      stumpings: json['stumpings'] as int? ?? 0,
      playerOfMatch: json['playerOfMatch'] as bool? ?? false,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'matchId': matchId,
      'teamId': teamId,
      'played': played,
      'captain': captain,
      'viceCaptain': viceCaptain,
      'wicketKeeper': wicketKeeper,
      'battingPosition': battingPosition,
      'runsScored': runsScored,
      'ballsFaced': ballsFaced,
      'fours': fours,
      'sixes': sixes,
      'strikeRate': strikeRate,
      'dismissalType': dismissalType,
      'oversBowled': oversBowled,
      'runsConceded': runsConceded,
      'wicketsTaken': wicketsTaken,
      'maidens': maidens,
      'economyRate': economyRate,
      'catches': catches,
      'runOuts': runOuts,
      'stumpings': stumpings,
      'playerOfMatch': playerOfMatch,
      'createdAt': createdAt,
    };
  }

  String get roleDisplay {
    if (captain) return 'Captain';
    if (viceCaptain) return 'Vice Captain';
    if (wicketKeeper) return 'Wicket Keeper';
    return 'Player';
  }
}
