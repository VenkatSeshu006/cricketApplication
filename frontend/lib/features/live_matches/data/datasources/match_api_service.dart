import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../domain/models/team.dart';
import '../../domain/models/player.dart';
import '../../domain/models/match.dart';
import '../../domain/models/match_squad.dart';

class MatchApiService {
  final http.Client _client = http.Client();

  // ===== TEAMS =====

  // List all teams
  Future<Map<String, dynamic>> listTeams({int page = 1, int limit = 10}) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/teams?page=$page&limit=$limit'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'data': (data['teams'] as List)
              .map((t) => _mapTeamFromBackend(t))
              .toList(),
          'pagination': data['pagination'],
        };
      } else {
        throw Exception('Failed to load teams');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get team details
  Future<Team> getTeamDetails(String teamId) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/teams/$teamId'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _mapTeamFromBackend(data['team']);
      } else {
        throw Exception('Failed to load team');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Create team
  Future<Team> createTeam({
    required String token,
    required String name,
    required String shortName,
    List<String>? colors,
    String? logoUrl,
    String? description,
    String? homeGround,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}/teams'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode({
          'name': name,
          'short_name': shortName,
          'colors': colors ?? ['#000000', '#FFFFFF'],
          'logo_url': logoUrl,
          'description': description,
          'home_ground': homeGround,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return _mapTeamFromBackend(data['team']);
      } else {
        throw Exception('Failed to create team');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update team
  Future<void> updateTeam({
    required String token,
    required String teamId,
    String? name,
    String? shortName,
    String? captainId,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (shortName != null) body['short_name'] = shortName;
      if (captainId != null) body['captain_id'] = captainId;

      final response = await _client.put(
        Uri.parse('${ApiConfig.baseUrl}/teams/$teamId'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode(body),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update team');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ===== PLAYERS =====

  // Get team players
  Future<List<Player>> getTeamPlayers(String teamId) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/teams/$teamId/players'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['players'] as List)
            .map((p) => _mapPlayerFromBackend(p))
            .toList();
      } else {
        throw Exception('Failed to load players');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Add player to team
  Future<Player> addPlayer({
    required String token,
    required String userId,
    required String teamId,
    required int jerseyNumber,
    required String role,
    required String batting,
    String? bowling,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}/players'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode({
          'user_id': userId,
          'team_id': teamId,
          'jersey_number': jerseyNumber,
          'role': role,
          'batting': batting,
          'bowling': bowling,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return _mapPlayerFromBackend(data['player']);
      } else {
        throw Exception('Failed to add player');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update player
  Future<void> updatePlayer({
    required String token,
    required String playerId,
    int? jerseyNumber,
    String? role,
    bool? isActive,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (jerseyNumber != null) body['jersey_number'] = jerseyNumber;
      if (role != null) body['role'] = role;
      if (isActive != null) body['is_active'] = isActive;

      final response = await _client.put(
        Uri.parse('${ApiConfig.baseUrl}/players/$playerId'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode(body),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update player');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ===== MATCHES =====

  // List matches
  Future<Map<String, dynamic>> listMatches({
    int page = 1,
    int limit = 10,
    String? status,
    String? matchType,
  }) async {
    try {
      var uri = Uri.parse(
        '${ApiConfig.baseUrl}/matches?page=$page&limit=$limit',
      );

      if (status != null) {
        uri = uri.replace(
          queryParameters: {...uri.queryParameters, 'status': status},
        );
      }
      if (matchType != null) {
        uri = uri.replace(
          queryParameters: {...uri.queryParameters, 'match_type': matchType},
        );
      }

      final response = await _client.get(uri, headers: ApiConfig.headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'data': (data['matches'] as List)
              .map((m) => _mapMatchFromBackend(m))
              .toList(),
          'pagination': data['pagination'],
        };
      } else {
        throw Exception('Failed to load matches');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get match details
  Future<MatchModel> getMatchDetails(String matchId) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/matches/$matchId'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _mapMatchFromBackend(data['match']);
      } else {
        throw Exception('Failed to load match');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Create match
  Future<MatchModel> createMatch({
    required String token,
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
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}/matches'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode({
          'title': title,
          'match_type': matchType,
          'match_format': matchFormat,
          'team_a_id': teamAId,
          'team_b_id': teamBId,
          'match_date': matchDate,
          'match_time': matchTime,
          'venue_name': venueName,
          'venue_city': venueCity,
          'total_overs': totalOvers,
          'ball_type': ballType,
          'ground_id': groundId,
          'description': description,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return _mapMatchFromBackend(data['match']);
      } else {
        throw Exception('Failed to create match');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update match
  Future<void> updateMatch({
    required String token,
    required String matchId,
    String? status,
    String? title,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (status != null) body['status'] = status;
      if (title != null) body['title'] = title;

      final response = await _client.put(
        Uri.parse('${ApiConfig.baseUrl}/matches/$matchId'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode(body),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update match');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ===== SQUADS =====

  // Get match squad
  Future<List<MatchSquad>> getMatchSquad(String matchId) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/matches/$matchId/squad'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['squad'] as List)
            .map((s) => _mapSquadFromBackend(s))
            .toList();
      } else {
        throw Exception('Failed to load squad');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Add player to squad
  Future<void> addPlayerToSquad({
    required String token,
    required String matchId,
    required String playerId,
    required String teamId,
    bool inPlaying11 = false,
    bool isCaptain = false,
    bool isViceCaptain = false,
    bool isWicketKeeper = false,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}/matches/$matchId/squad'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode({
          'player_id': playerId,
          'team_id': teamId,
          'in_playing_11': inPlaying11,
          'is_captain': isCaptain,
          'is_vice_captain': isViceCaptain,
          'is_wicket_keeper': isWicketKeeper,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add player to squad');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Private mappers

  Team _mapTeamFromBackend(Map<String, dynamic> backend) {
    return Team(
      id: backend['id'] as String,
      name: backend['name'] as String,
      shortName: backend['short_name'] as String,
      logoUrl: backend['logo_url'] as String?,
      colors: List<String>.from(backend['colors'] ?? ['#000000', '#FFFFFF']),
      captainId: backend['captain_id'] as String?,
      isActive: backend['is_active'] as bool? ?? true,
      description: backend['description'] as String?,
      homeGround: backend['home_ground'] as String?,
      totalMatches: backend['total_matches'] as int? ?? 0,
      wins: backend['wins'] as int? ?? 0,
      losses: backend['losses'] as int? ?? 0,
      draws: backend['draws'] as int? ?? 0,
      createdAt: backend['created_at'] as String,
    );
  }

  Player _mapPlayerFromBackend(Map<String, dynamic> backend) {
    return Player(
      id: backend['id'] as String,
      userId: backend['user_id'] as String,
      teamId: backend['team_id'] as String,
      jerseyNumber: backend['jersey_number'] as int,
      role: backend['role'] as String,
      batting: backend['batting'] as String,
      bowling: backend['bowling'] as String?,
      isActive: backend['is_active'] as bool? ?? true,
      matchesPlayed: backend['matches_played'] as int? ?? 0,
      runsScored: backend['runs_scored'] as int? ?? 0,
      wicketsTaken: backend['wickets_taken'] as int? ?? 0,
      catches: backend['catches'] as int? ?? 0,
      joinedAt: backend['joined_at'] as String,
    );
  }

  MatchModel _mapMatchFromBackend(Map<String, dynamic> backend) {
    return MatchModel(
      id: backend['id'] as String,
      title: backend['title'] as String,
      matchType: backend['match_type'] as String,
      matchFormat: backend['match_format'] as String,
      teamAId: backend['team_a_id'] as String,
      teamBId: backend['team_b_id'] as String,
      matchDate: backend['match_date'] as String,
      matchTime: backend['match_time'] as String,
      groundId: backend['ground_id'] as String?,
      venueName: backend['venue_name'] as String,
      venueCity: backend['venue_city'] as String,
      totalOvers: backend['total_overs'] as int,
      ballType: backend['ball_type'] as String,
      status: backend['status'] as String,
      winnerTeamId: backend['winner_team_id'] as String?,
      winMargin: backend['win_margin'] as String?,
      resultType: backend['result_type'] as String?,
      description: backend['description'] as String?,
      createdAt: backend['created_at'] as String,
    );
  }

  MatchSquad _mapSquadFromBackend(Map<String, dynamic> backend) {
    return MatchSquad(
      id: backend['id'] as String,
      matchId: backend['match_id'] as String,
      playerId: backend['player_id'] as String,
      teamId: backend['team_id'] as String,
      inPlaying11: backend['in_playing_11'] as bool? ?? false,
      isCaptain: backend['is_captain'] as bool? ?? false,
      isViceCaptain: backend['is_vice_captain'] as bool? ?? false,
      isWicketKeeper: backend['is_wicket_keeper'] as bool? ?? false,
      addedAt: backend['added_at'] as String,
    );
  }
}
