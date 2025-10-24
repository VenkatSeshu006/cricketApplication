import '../datasources/statistics_api_service.dart';
import '../../domain/repositories/statistics_repository.dart';

class RealStatisticsRepository implements StatisticsRepository {
  final StatisticsApiService _apiService;

  RealStatisticsRepository(this._apiService);

  @override
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
  }) async {
    try {
      final performance = await _apiService.recordPerformance(
        token: token,
        playerId: playerId,
        matchId: matchId,
        teamId: teamId,
        played: played,
        captain: captain,
        viceCaptain: viceCaptain,
        wicketKeeper: wicketKeeper,
        battingPosition: battingPosition,
        runsScored: runsScored,
        ballsFaced: ballsFaced,
        fours: fours,
        sixes: sixes,
        dismissalType: dismissalType,
        oversBowled: oversBowled,
        runsConceded: runsConceded,
        wicketsTaken: wicketsTaken,
        maidens: maidens,
        catches: catches,
        runOuts: runOuts,
        stumpings: stumpings,
        playerOfMatch: playerOfMatch,
      );

      return {
        'success': true,
        'data': performance,
        'message': 'Performance recorded successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to record performance',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getPlayerMatchPerformance(
    String playerId,
    String matchId,
  ) async {
    try {
      final performance = await _apiService.getPlayerMatchPerformance(
        playerId: playerId,
        matchId: matchId,
      );

      return {'success': true, 'data': performance};
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to fetch player match performance',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getMatchPerformances(String matchId) async {
    try {
      final performances = await _apiService.getMatchPerformances(matchId);

      return {'success': true, 'data': performances};
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to fetch match performances',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getPlayerPerformances(
    String playerId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await _apiService.getPlayerPerformances(
        playerId: playerId,
        page: page,
        limit: limit,
      );

      return {'success': true, 'data': result};
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to fetch player performances',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> updatePerformance(
    String performanceId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final performance = await _apiService.updatePerformance(
        performanceId,
        updates,
      );

      return {
        'success': true,
        'data': performance,
        'message': 'Performance updated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to update performance',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> deletePerformance(String performanceId) async {
    try {
      await _apiService.deletePerformance(performanceId);

      return {'success': true, 'message': 'Performance deleted successfully'};
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to delete performance',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getPlayerCareerStats(String playerId) async {
    try {
      final stats = await _apiService.getPlayerCareerStats(playerId);

      return {'success': true, 'data': stats};
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to fetch career stats',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> recalculateCareerStats(String playerId) async {
    try {
      final stats = await _apiService.recalculateCareerStats(playerId);

      return {
        'success': true,
        'data': stats,
        'message': 'Career stats recalculated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to recalculate career stats',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getBattingLeaderboard({
    int page = 1,
    int limit = 20,
    String sortBy = 'runs',
  }) async {
    try {
      final result = await _apiService.getBattingLeaderboard(
        page: page,
        limit: limit,
        sortBy: sortBy,
      );

      return {'success': true, 'data': result};
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to fetch batting leaderboard',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getBowlingLeaderboard({
    int page = 1,
    int limit = 20,
    String sortBy = 'wickets',
  }) async {
    try {
      final result = await _apiService.getBowlingLeaderboard(
        page: page,
        limit: limit,
        sortBy: sortBy,
      );

      return {'success': true, 'data': result};
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to fetch bowling leaderboard',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getFieldingLeaderboard({
    int page = 1,
    int limit = 20,
    String sortBy = 'catches',
  }) async {
    try {
      final result = await _apiService.getFieldingLeaderboard(
        page: page,
        limit: limit,
        sortBy: sortBy,
      );

      return {'success': true, 'data': result};
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to fetch fielding leaderboard',
      };
    }
  }
}
