import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/match_repository.dart';
import '../datasources/match_api_service.dart';

class RealMatchRepository implements MatchRepository {
  final MatchApiService _apiService;
  static const _keyToken = 'auth_token';

  RealMatchRepository(this._apiService);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // ===== TEAMS =====

  @override
  Future<Map<String, dynamic>> listTeams({int page = 1, int limit = 10}) async {
    try {
      final result = await _apiService.listTeams(page: page, limit: limit);
      return {
        'success': true,
        'data': result['data'],
        'pagination': result['pagination'],
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load teams: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getTeamDetails(String teamId) async {
    try {
      final team = await _apiService.getTeamDetails(teamId);
      return {'success': true, 'data': team};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load team details: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> createTeam({
    required String name,
    required String shortName,
    List<String>? colors,
    String? logoUrl,
    String? description,
    String? homeGround,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      final team = await _apiService.createTeam(
        token: token,
        name: name,
        shortName: shortName,
        colors: colors,
        logoUrl: logoUrl,
        description: description,
        homeGround: homeGround,
      );

      return {
        'success': true,
        'data': team,
        'message': 'Team created successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create team: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> updateTeam({
    required String teamId,
    String? name,
    String? shortName,
    String? captainId,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.updateTeam(
        token: token,
        teamId: teamId,
        name: name,
        shortName: shortName,
        captainId: captainId,
      );

      return {'success': true, 'message': 'Team updated successfully'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update team: ${e.toString()}',
      };
    }
  }

  // ===== PLAYERS =====

  @override
  Future<Map<String, dynamic>> getTeamPlayers(String teamId) async {
    try {
      final players = await _apiService.getTeamPlayers(teamId);
      return {'success': true, 'data': players};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load players: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> addPlayer({
    required String userId,
    required String teamId,
    required int jerseyNumber,
    required String role,
    required String batting,
    String? bowling,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      final player = await _apiService.addPlayer(
        token: token,
        userId: userId,
        teamId: teamId,
        jerseyNumber: jerseyNumber,
        role: role,
        batting: batting,
        bowling: bowling,
      );

      return {
        'success': true,
        'data': player,
        'message': 'Player added successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to add player: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> updatePlayer({
    required String playerId,
    int? jerseyNumber,
    String? role,
    bool? isActive,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.updatePlayer(
        token: token,
        playerId: playerId,
        jerseyNumber: jerseyNumber,
        role: role,
        isActive: isActive,
      );

      return {'success': true, 'message': 'Player updated successfully'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update player: ${e.toString()}',
      };
    }
  }

  // ===== MATCHES =====

  @override
  Future<Map<String, dynamic>> listMatches({
    int page = 1,
    int limit = 10,
    String? status,
    String? matchType,
  }) async {
    try {
      final result = await _apiService.listMatches(
        page: page,
        limit: limit,
        status: status,
        matchType: matchType,
      );
      return {
        'success': true,
        'data': result['data'],
        'pagination': result['pagination'],
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load matches: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getMatchDetails(String matchId) async {
    try {
      final match = await _apiService.getMatchDetails(matchId);
      return {'success': true, 'data': match};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load match details: ${e.toString()}',
      };
    }
  }

  @override
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
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      final match = await _apiService.createMatch(
        token: token,
        title: title,
        matchType: matchType,
        matchFormat: matchFormat,
        teamAId: teamAId,
        teamBId: teamBId,
        matchDate: matchDate,
        matchTime: matchTime,
        venueName: venueName,
        venueCity: venueCity,
        totalOvers: totalOvers,
        ballType: ballType,
        groundId: groundId,
        description: description,
      );

      return {
        'success': true,
        'data': match,
        'message': 'Match created successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create match: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> updateMatch({
    required String matchId,
    String? status,
    String? title,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.updateMatch(
        token: token,
        matchId: matchId,
        status: status,
        title: title,
      );

      return {'success': true, 'message': 'Match updated successfully'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update match: ${e.toString()}',
      };
    }
  }

  // ===== SQUAD =====

  @override
  Future<Map<String, dynamic>> getMatchSquad(String matchId) async {
    try {
      final squad = await _apiService.getMatchSquad(matchId);
      return {'success': true, 'data': squad};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load squad: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> addPlayerToSquad({
    required String matchId,
    required String playerId,
    required String teamId,
    bool inPlaying11 = false,
    bool isCaptain = false,
    bool isViceCaptain = false,
    bool isWicketKeeper = false,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.addPlayerToSquad(
        token: token,
        matchId: matchId,
        playerId: playerId,
        teamId: teamId,
        inPlaying11: inPlaying11,
        isCaptain: isCaptain,
        isViceCaptain: isViceCaptain,
        isWicketKeeper: isWicketKeeper,
      );

      return {'success': true, 'message': 'Player added to squad successfully'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to add player to squad: ${e.toString()}',
      };
    }
  }
}
