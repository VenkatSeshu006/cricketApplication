import 'package:equatable/equatable.dart';

class LeaderboardEntry extends Equatable {
  final int rank;
  final String userId;
  final String userName;
  final String? userImage;
  final String role;
  final LeaderboardStats stats;
  final int totalPoints;
  final String? team;

  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.role,
    required this.stats,
    required this.totalPoints,
    this.team,
  });

  @override
  List<Object?> get props => [
    rank,
    userId,
    userName,
    userImage,
    role,
    stats,
    totalPoints,
    team,
  ];
}

class LeaderboardStats extends Equatable {
  // Batting stats
  final int? runs;
  final int? innings;
  final double? average;
  final double? strikeRate;
  final int? centuries;
  final int? fifties;

  // Bowling stats
  final int? wickets;
  final int? overs;
  final double? bowlingAverage;
  final double? economy;
  final int? fiveWickets;

  // Fielding stats
  final int? catches;
  final int? runOuts;
  final int? stumpings;

  const LeaderboardStats({
    this.runs,
    this.innings,
    this.average,
    this.strikeRate,
    this.centuries,
    this.fifties,
    this.wickets,
    this.overs,
    this.bowlingAverage,
    this.economy,
    this.fiveWickets,
    this.catches,
    this.runOuts,
    this.stumpings,
  });

  @override
  List<Object?> get props => [
    runs,
    innings,
    average,
    strikeRate,
    centuries,
    fifties,
    wickets,
    overs,
    bowlingAverage,
    economy,
    fiveWickets,
    catches,
    runOuts,
    stumpings,
  ];
}

enum LeaderboardType { batting, bowling, fielding }

enum LeaderboardCategory { leatherBall, tennisBall, boxCricket, overall }
