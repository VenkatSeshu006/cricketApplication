
abstract class MatchRepository {
  // Teams
  Future<Map<String, dynamic>> listTeams({int page = 1, int limit = 10});
  Future<Map<String, dynamic>> getTeamDetails(String teamId);
  Future<Map<String, dynamic>> createTeam({
    required String name,
    required String shortName,
    List<String>? colors,
    String? logoUrl,
    String? description,
    String? homeGround,
  });
  Future<Map<String, dynamic>> updateTeam({
    required String teamId,
    String? name,
    String? shortName,
    String? captainId,
  });

  // Players
  Future<Map<String, dynamic>> getTeamPlayers(String teamId);
  Future<Map<String, dynamic>> addPlayer({
    required String userId,
    required String teamId,
    required int jerseyNumber,
    required String role,
    required String batting,
    String? bowling,
  });
  Future<Map<String, dynamic>> updatePlayer({
    required String playerId,
    int? jerseyNumber,
    String? role,
    bool? isActive,
  });

  // Matches
  Future<Map<String, dynamic>> listMatches({
    int page = 1,
    int limit = 10,
    String? status,
    String? matchType,
  });
  Future<Map<String, dynamic>> getMatchDetails(String matchId);
  Future<Map<String, dynamic>> createMatch({
    required String title,
    required String matchType,
    required String matchFormat,
    required String teamAId,
    required String teamBId,
    required String matchDate,
    required String matchTime,
    required String venueName,
    required String venueCity,
    required int totalOvers,
    String ballType = 'white',
    String? groundId,
    String? description,
  });
  Future<Map<String, dynamic>> updateMatch({
    required String matchId,
    String? status,
    String? title,
  });

  // Squad
  Future<Map<String, dynamic>> getMatchSquad(String matchId);
  Future<Map<String, dynamic>> addPlayerToSquad({
    required String matchId,
    required String playerId,
    required String teamId,
    bool inPlaying11 = false,
    bool isCaptain = false,
    bool isViceCaptain = false,
    bool isWicketKeeper = false,
  });
}
