import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../domain/models/player_performance.dart';
import '../../domain/models/player_career_stats.dart';

class StatisticsApiService {
  final http.Client _client = http.Client();

  // ===== MATCH PERFORMANCE =====

  // Record player performance in a match
  Future<PlayerPerformance> recordPerformance({
    required String token,
    required String playerId,
    required String matchId,
    required String teamId,
    bool played = true,
    bool captain = false,
    bool viceCaptain = false,
    bool wicketKeeper = false,
    int? battingPosition,
    int runsScored = 0,
    int ballsFaced = 0,
    int fours = 0,
    int sixes = 0,
    String? dismissalType,
    String? dismissedByPlayerId,
    double oversBowled = 0.0,
    int runsConceded = 0,
    int wicketsTaken = 0,
    int maidens = 0,
    int catches = 0,
    int runOuts = 0,
    int stumpings = 0,
    bool playerOfMatch = false,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}/performances'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode({
          'player_id': playerId,
          'match_id': matchId,
          'team_id': teamId,
          'played': played,
          'captain': captain,
          'vice_captain': viceCaptain,
          'wicket_keeper': wicketKeeper,
          'batting_position': battingPosition,
          'runs_scored': runsScored,
          'balls_faced': ballsFaced,
          'fours': fours,
          'sixes': sixes,
          'dismissal_type': dismissalType,
          'dismissed_by_player_id': dismissedByPlayerId,
          'overs_bowled': oversBowled,
          'runs_conceded': runsConceded,
          'wickets_taken': wicketsTaken,
          'maidens': maidens,
          'catches': catches,
          'run_outs': runOuts,
          'stumpings': stumpings,
          'player_of_match': playerOfMatch,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return _mapPerformanceFromBackend(data['performance']);
      } else {
        throw Exception('Failed to record performance');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get player's performance in a specific match
  Future<PlayerPerformance?> getPlayerMatchPerformance({
    required String playerId,
    required String matchId,
  }) async {
    try {
      // Use ListPerformances with filters
      final response = await _client.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/performances?player_id=$playerId&match_id=$matchId&limit=1',
        ),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final performances = data['performances'] as List;
        if (performances.isNotEmpty) {
          return _mapPerformanceFromBackend(performances.first);
        }
        return null;
      } else {
        throw Exception('Failed to load performance');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get single performance by ID
  Future<PlayerPerformance> getPerformance(String performanceId) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/performances/$performanceId'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _mapPerformanceFromBackend(data);
      } else {
        throw Exception('Failed to load performance');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get all performances for a match
  Future<List<PlayerPerformance>> getMatchPerformances(String matchId) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/performances?match_id=$matchId'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['performances'] as List)
            .map((p) => _mapPerformanceFromBackend(p))
            .toList();
      } else {
        throw Exception('Failed to load performances');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get player's performance history
  Future<Map<String, dynamic>> getPlayerPerformances({
    required String playerId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/performances?player_id=$playerId&page=$page&limit=$limit',
        ),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'data': (data['performances'] as List)
              .map((p) => _mapPerformanceFromBackend(p))
              .toList(),
          'total': data['total'],
          'page': data['page'],
          'limit': data['limit'],
        };
      } else {
        throw Exception('Failed to load performances');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update performance
  Future<PlayerPerformance> updatePerformance(
    String performanceId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('${ApiConfig.baseUrl}/performances/$performanceId'),
        headers: ApiConfig.authHeaders(
          '',
        ), // Token should come from updates or context
        body: json.encode(updates),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _mapPerformanceFromBackend(data);
      } else {
        throw Exception('Failed to update performance');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Delete performance
  Future<void> deletePerformance(String performanceId) async {
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConfig.baseUrl}/performances/$performanceId'),
        headers: ApiConfig.authHeaders(''), // Token should come from context
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete performance');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ===== CAREER STATS =====

  // Get player's career statistics
  Future<PlayerCareerStats> getPlayerCareerStats(String playerId) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/players/$playerId/stats'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _mapCareerStatsFromBackend(data);
      } else {
        throw Exception('Failed to load career stats');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Recalculate career statistics
  Future<PlayerCareerStats> recalculateCareerStats(String playerId) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}/players/$playerId/refresh-stats'),
        headers: ApiConfig.authHeaders(''), // Token should come from context
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _mapCareerStatsFromBackend(data);
      } else {
        throw Exception('Failed to recalculate stats');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ===== LEADERBOARDS =====

  // Get batting leaderboard
  Future<Map<String, dynamic>> getBattingLeaderboard({
    int page = 1,
    int limit = 20,
    String sortBy = 'average',
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/leaderboards/batting?limit=$limit'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'entries': data['entries'] ?? [],
          'category': data['category'] ?? 'batting',
          'season': data['season'] ?? 'all_time',
        };
      } else {
        throw Exception('Failed to load leaderboard');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get bowling leaderboard
  Future<Map<String, dynamic>> getBowlingLeaderboard({
    int page = 1,
    int limit = 20,
    String sortBy = 'wickets',
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/leaderboards/bowling?limit=$limit'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'entries': data['entries'] ?? [],
          'category': data['category'] ?? 'bowling',
          'season': data['season'] ?? 'all_time',
        };
      } else {
        throw Exception('Failed to load leaderboard');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get fielding leaderboard (most catches)
  Future<Map<String, dynamic>> getFieldingLeaderboard({
    int page = 1,
    int limit = 20,
    String sortBy = 'catches',
  }) async {
    try {
      // Backend doesn't have dedicated fielding leaderboard, use performances filter
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/performances?limit=$limit'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'entries': data['performances'] ?? [],
          'category': 'fielding',
          'season': 'all_time',
        };
      } else {
        throw Exception('Failed to load leaderboard');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Private mappers

  PlayerPerformance _mapPerformanceFromBackend(Map<String, dynamic> backend) {
    // Calculate strike rate
    double strikeRate = 0.0;
    if (backend['balls_faced'] != null && (backend['balls_faced'] as int) > 0) {
      strikeRate =
          ((backend['runs_scored'] as int) / (backend['balls_faced'] as int)) *
          100;
    }

    // Calculate economy rate
    double economyRate = 0.0;
    if (backend['overs_bowled'] != null &&
        (backend['overs_bowled'] as num) > 0) {
      economyRate =
          (backend['runs_conceded'] as int) / (backend['overs_bowled'] as num);
    }

    return PlayerPerformance(
      id: backend['id'] as String,
      playerId: backend['player_id'] as String,
      matchId: backend['match_id'] as String,
      teamId: backend['team_id'] as String,
      played: backend['played'] as bool? ?? true,
      captain: backend['captain'] as bool? ?? false,
      viceCaptain: backend['vice_captain'] as bool? ?? false,
      wicketKeeper: backend['wicket_keeper'] as bool? ?? false,
      battingPosition: backend['batting_position'] as int?,
      runsScored: backend['runs_scored'] as int? ?? 0,
      ballsFaced: backend['balls_faced'] as int? ?? 0,
      fours: backend['fours'] as int? ?? 0,
      sixes: backend['sixes'] as int? ?? 0,
      strikeRate: strikeRate,
      dismissalType: backend['dismissal_type'] as String?,
      oversBowled: (backend['overs_bowled'] as num?)?.toDouble() ?? 0.0,
      runsConceded: backend['runs_conceded'] as int? ?? 0,
      wicketsTaken: backend['wickets_taken'] as int? ?? 0,
      maidens: backend['maidens'] as int? ?? 0,
      economyRate: economyRate,
      catches: backend['catches'] as int? ?? 0,
      runOuts: backend['run_outs'] as int? ?? 0,
      stumpings: backend['stumpings'] as int? ?? 0,
      playerOfMatch: backend['player_of_match'] as bool? ?? false,
      createdAt: backend['created_at'] as String,
    );
  }

  PlayerCareerStats _mapCareerStatsFromBackend(Map<String, dynamic> backend) {
    return PlayerCareerStats(
      id: backend['id'] as String,
      playerId: backend['player_id'] as String,
      totalMatches: backend['total_matches'] as int? ?? 0,
      totalInnings: backend['total_innings'] as int? ?? 0,
      matchesWon: backend['matches_won'] as int? ?? 0,
      matchesLost: backend['matches_lost'] as int? ?? 0,
      totalRuns: backend['total_runs'] as int? ?? 0,
      totalBallsFaced: backend['total_balls_faced'] as int? ?? 0,
      totalFours: backend['total_fours'] as int? ?? 0,
      totalSixes: backend['total_sixes'] as int? ?? 0,
      highestScore: backend['highest_score'] as int? ?? 0,
      battingAverage: (backend['batting_average'] as num?)?.toDouble() ?? 0.0,
      battingStrikeRate:
          (backend['batting_strike_rate'] as num?)?.toDouble() ?? 0.0,
      fifties: backend['fifties'] as int? ?? 0,
      hundreds: backend['hundreds'] as int? ?? 0,
      ducks: backend['ducks'] as int? ?? 0,
      notOuts: backend['not_outs'] as int? ?? 0,
      totalOversBowled:
          (backend['total_overs_bowled'] as num?)?.toDouble() ?? 0.0,
      totalRunsConceded: backend['total_runs_conceded'] as int? ?? 0,
      totalWickets: backend['total_wickets'] as int? ?? 0,
      totalMaidens: backend['total_maidens'] as int? ?? 0,
      bestBowlingFigures: backend['best_bowling_figures'] as String?,
      bowlingAverage: (backend['bowling_average'] as num?)?.toDouble() ?? 0.0,
      bowlingEconomy: (backend['bowling_economy'] as num?)?.toDouble() ?? 0.0,
      bowlingStrikeRate:
          (backend['bowling_strike_rate'] as num?)?.toDouble() ?? 0.0,
      fiveWickets: backend['five_wickets'] as int? ?? 0,
      totalCatches: backend['total_catches'] as int? ?? 0,
      totalRunOuts: backend['total_run_outs'] as int? ?? 0,
      totalStumpings: backend['total_stumpings'] as int? ?? 0,
      playerOfMatchAwards: backend['player_of_match_awards'] as int? ?? 0,
      updatedAt: backend['updated_at'] as String,
    );
  }
}
