class MatchModel {
  final String id;
  final String title;
  final String matchType; // practice, friendly, league, tournament
  final String matchFormat; // T20, ODI, Test, T10
  final String teamAId;
  final String teamBId;
  final String matchDate;
  final String matchTime;
  final String? groundId;
  final String venueName;
  final String venueCity;
  final int totalOvers;
  final String ballType; // red, white, pink
  final String status; // upcoming, live, completed, cancelled
  final String? winnerTeamId;
  final String? winMargin; // "5 wickets", "50 runs"
  final String? resultType; // normal, tie, no-result, abandoned
  final String? description;
  final String createdAt;

  MatchModel({
    required this.id,
    required this.title,
    required this.matchType,
    required this.matchFormat,
    required this.teamAId,
    required this.teamBId,
    required this.matchDate,
    required this.matchTime,
    this.groundId,
    required this.venueName,
    required this.venueCity,
    required this.totalOvers,
    required this.ballType,
    required this.status,
    this.winnerTeamId,
    this.winMargin,
    this.resultType,
    this.description,
    required this.createdAt,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'] as String,
      title: json['title'] as String,
      matchType: json['matchType'] as String,
      matchFormat: json['matchFormat'] as String,
      teamAId: json['teamAId'] as String,
      teamBId: json['teamBId'] as String,
      matchDate: json['matchDate'] as String,
      matchTime: json['matchTime'] as String,
      groundId: json['groundId'] as String?,
      venueName: json['venueName'] as String,
      venueCity: json['venueCity'] as String,
      totalOvers: json['totalOvers'] as int,
      ballType: json['ballType'] as String,
      status: json['status'] as String,
      winnerTeamId: json['winnerTeamId'] as String?,
      winMargin: json['winMargin'] as String?,
      resultType: json['resultType'] as String?,
      description: json['description'] as String?,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'matchType': matchType,
      'matchFormat': matchFormat,
      'teamAId': teamAId,
      'teamBId': teamBId,
      'matchDate': matchDate,
      'matchTime': matchTime,
      'groundId': groundId,
      'venueName': venueName,
      'venueCity': venueCity,
      'totalOvers': totalOvers,
      'ballType': ballType,
      'status': status,
      'winnerTeamId': winnerTeamId,
      'winMargin': winMargin,
      'resultType': resultType,
      'description': description,
      'createdAt': createdAt,
    };
  }

  String get statusDisplay {
    switch (status) {
      case 'upcoming':
        return 'Upcoming';
      case 'live':
        return 'Live';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  bool get isLive => status == 'live';
  bool get isUpcoming => status == 'upcoming';
  bool get isCompleted => status == 'completed';
}
