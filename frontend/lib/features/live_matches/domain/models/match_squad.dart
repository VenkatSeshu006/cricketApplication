class MatchSquad {
  final String id;
  final String matchId;
  final String playerId;
  final String teamId;
  final bool inPlaying11;
  final bool isCaptain;
  final bool isViceCaptain;
  final bool isWicketKeeper;
  final String addedAt;

  MatchSquad({
    required this.id,
    required this.matchId,
    required this.playerId,
    required this.teamId,
    required this.inPlaying11,
    required this.isCaptain,
    required this.isViceCaptain,
    required this.isWicketKeeper,
    required this.addedAt,
  });

  factory MatchSquad.fromJson(Map<String, dynamic> json) {
    return MatchSquad(
      id: json['id'] as String,
      matchId: json['matchId'] as String,
      playerId: json['playerId'] as String,
      teamId: json['teamId'] as String,
      inPlaying11: json['inPlaying11'] as bool? ?? false,
      isCaptain: json['isCaptain'] as bool? ?? false,
      isViceCaptain: json['isViceCaptain'] as bool? ?? false,
      isWicketKeeper: json['isWicketKeeper'] as bool? ?? false,
      addedAt: json['addedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matchId': matchId,
      'playerId': playerId,
      'teamId': teamId,
      'inPlaying11': inPlaying11,
      'isCaptain': isCaptain,
      'isViceCaptain': isViceCaptain,
      'isWicketKeeper': isWicketKeeper,
      'addedAt': addedAt,
    };
  }

  String get role {
    if (isCaptain) return 'Captain';
    if (isViceCaptain) return 'Vice Captain';
    if (isWicketKeeper) return 'Wicket Keeper';
    return 'Player';
  }
}
