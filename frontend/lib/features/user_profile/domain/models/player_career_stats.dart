class PlayerCareerStats {
  final String id;
  final String playerId;
  final int totalMatches;
  final int totalInnings;
  final int matchesWon;
  final int matchesLost;
  final int totalRuns;
  final int totalBallsFaced;
  final int totalFours;
  final int totalSixes;
  final int highestScore;
  final double battingAverage;
  final double battingStrikeRate;
  final int fifties;
  final int hundreds;
  final int ducks;
  final int notOuts;
  final double totalOversBowled;
  final int totalRunsConceded;
  final int totalWickets;
  final int totalMaidens;
  final String? bestBowlingFigures;
  final double bowlingAverage;
  final double bowlingEconomy;
  final double bowlingStrikeRate;
  final int fiveWickets;
  final int totalCatches;
  final int totalRunOuts;
  final int totalStumpings;
  final int playerOfMatchAwards;
  final String updatedAt;

  PlayerCareerStats({
    required this.id,
    required this.playerId,
    required this.totalMatches,
    required this.totalInnings,
    required this.matchesWon,
    required this.matchesLost,
    required this.totalRuns,
    required this.totalBallsFaced,
    required this.totalFours,
    required this.totalSixes,
    required this.highestScore,
    required this.battingAverage,
    required this.battingStrikeRate,
    required this.fifties,
    required this.hundreds,
    required this.ducks,
    required this.notOuts,
    required this.totalOversBowled,
    required this.totalRunsConceded,
    required this.totalWickets,
    required this.totalMaidens,
    this.bestBowlingFigures,
    required this.bowlingAverage,
    required this.bowlingEconomy,
    required this.bowlingStrikeRate,
    required this.fiveWickets,
    required this.totalCatches,
    required this.totalRunOuts,
    required this.totalStumpings,
    required this.playerOfMatchAwards,
    required this.updatedAt,
  });

  factory PlayerCareerStats.fromJson(Map<String, dynamic> json) {
    return PlayerCareerStats(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      totalMatches: json['totalMatches'] as int? ?? 0,
      totalInnings: json['totalInnings'] as int? ?? 0,
      matchesWon: json['matchesWon'] as int? ?? 0,
      matchesLost: json['matchesLost'] as int? ?? 0,
      totalRuns: json['totalRuns'] as int? ?? 0,
      totalBallsFaced: json['totalBallsFaced'] as int? ?? 0,
      totalFours: json['totalFours'] as int? ?? 0,
      totalSixes: json['totalSixes'] as int? ?? 0,
      highestScore: json['highestScore'] as int? ?? 0,
      battingAverage: (json['battingAverage'] as num?)?.toDouble() ?? 0.0,
      battingStrikeRate: (json['battingStrikeRate'] as num?)?.toDouble() ?? 0.0,
      fifties: json['fifties'] as int? ?? 0,
      hundreds: json['hundreds'] as int? ?? 0,
      ducks: json['ducks'] as int? ?? 0,
      notOuts: json['notOuts'] as int? ?? 0,
      totalOversBowled: (json['totalOversBowled'] as num?)?.toDouble() ?? 0.0,
      totalRunsConceded: json['totalRunsConceded'] as int? ?? 0,
      totalWickets: json['totalWickets'] as int? ?? 0,
      totalMaidens: json['totalMaidens'] as int? ?? 0,
      bestBowlingFigures: json['bestBowlingFigures'] as String?,
      bowlingAverage: (json['bowlingAverage'] as num?)?.toDouble() ?? 0.0,
      bowlingEconomy: (json['bowlingEconomy'] as num?)?.toDouble() ?? 0.0,
      bowlingStrikeRate: (json['bowlingStrikeRate'] as num?)?.toDouble() ?? 0.0,
      fiveWickets: json['fiveWickets'] as int? ?? 0,
      totalCatches: json['totalCatches'] as int? ?? 0,
      totalRunOuts: json['totalRunOuts'] as int? ?? 0,
      totalStumpings: json['totalStumpings'] as int? ?? 0,
      playerOfMatchAwards: json['playerOfMatchAwards'] as int? ?? 0,
      updatedAt: json['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'totalMatches': totalMatches,
      'totalInnings': totalInnings,
      'matchesWon': matchesWon,
      'matchesLost': matchesLost,
      'totalRuns': totalRuns,
      'totalBallsFaced': totalBallsFaced,
      'totalFours': totalFours,
      'totalSixes': totalSixes,
      'highestScore': highestScore,
      'battingAverage': battingAverage,
      'battingStrikeRate': battingStrikeRate,
      'fifties': fifties,
      'hundreds': hundreds,
      'ducks': ducks,
      'notOuts': notOuts,
      'totalOversBowled': totalOversBowled,
      'totalRunsConceded': totalRunsConceded,
      'totalWickets': totalWickets,
      'totalMaidens': totalMaidens,
      'bestBowlingFigures': bestBowlingFigures,
      'bowlingAverage': bowlingAverage,
      'bowlingEconomy': bowlingEconomy,
      'bowlingStrikeRate': bowlingStrikeRate,
      'fiveWickets': fiveWickets,
      'totalCatches': totalCatches,
      'totalRunOuts': totalRunOuts,
      'totalStumpings': totalStumpings,
      'playerOfMatchAwards': playerOfMatchAwards,
      'updatedAt': updatedAt,
    };
  }

  double get winPercentage {
    if (totalMatches == 0) return 0.0;
    return (matchesWon / totalMatches) * 100;
  }

  int get totalBoundaries => totalFours + totalSixes;
}
