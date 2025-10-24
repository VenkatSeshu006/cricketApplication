abstract class StatisticsRepository {
  // Match Performance
  Future<Map<String, dynamic>> recordPerformance({
    required String token,
    required String playerId,
    required String matchId,
    required String teamId,
    required bool played,
    required bool captain,
    required bool viceCaptain,
    required bool wicketKeeper,
    int? battingPosition,
    required int runsScored,
    required int ballsFaced,
    required int fours,
    required int sixes,
    String? dismissalType,
    required double oversBowled,
    required int runsConceded,
    required int wicketsTaken,
    required int maidens,
    required int catches,
    required int runOuts,
    required int stumpings,
    required bool playerOfMatch,
  });

  Future<Map<String, dynamic>> getPlayerMatchPerformance(
    String playerId,
    String matchId,
  );

  Future<Map<String, dynamic>> getMatchPerformances(String matchId);

  Future<Map<String, dynamic>> getPlayerPerformances(
    String playerId, {
    int page = 1,
    int limit = 20,
  });

  Future<Map<String, dynamic>> updatePerformance(
    String performanceId,
    Map<String, dynamic> updates,
  );

  Future<Map<String, dynamic>> deletePerformance(String performanceId);

  // Career Stats
  Future<Map<String, dynamic>> getPlayerCareerStats(String playerId);

  Future<Map<String, dynamic>> recalculateCareerStats(String playerId);

  // Leaderboards
  Future<Map<String, dynamic>> getBattingLeaderboard({
    int page = 1,
    int limit = 20,
    String sortBy = 'runs',
  });

  Future<Map<String, dynamic>> getBowlingLeaderboard({
    int page = 1,
    int limit = 20,
    String sortBy = 'wickets',
  });

  Future<Map<String, dynamic>> getFieldingLeaderboard({
    int page = 1,
    int limit = 20,
    String sortBy = 'catches',
  });
}
