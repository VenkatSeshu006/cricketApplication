import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../domain/models/tournament.dart';
import '../../domain/models/tournament_registration.dart';
import '../../domain/models/tournament_standing.dart';

class TournamentApiService {
  final http.Client _client = http.Client();

  // ===== TOURNAMENTS =====

  // List all tournaments
  Future<Map<String, dynamic>> listTournaments({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      var uri = Uri.parse(
        '${ApiConfig.baseUrl}/tournaments?page=$page&limit=$limit',
      );

      if (status != null) {
        uri = uri.replace(
          queryParameters: {...uri.queryParameters, 'status': status},
        );
      }

      final response = await _client.get(uri, headers: ApiConfig.headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'data': (data['tournaments'] as List)
              .map((t) => _mapTournamentFromBackend(t))
              .toList(),
          'pagination': data['pagination'],
        };
      } else {
        throw Exception('Failed to load tournaments');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get tournament details
  Future<Tournament> getTournamentDetails(String tournamentId) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/tournaments/$tournamentId'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _mapTournamentFromBackend(data['tournament']);
      } else {
        throw Exception('Failed to load tournament');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Create tournament
  Future<Tournament> createTournament({
    required String token,
    required String name,
    required String tournamentType,
    required String matchFormat,
    required String startDate,
    required String endDate,
    required String registrationDeadline,
    required int maxTeams,
    required int minTeams,
    double entryFee = 0.0,
    double prizePool = 0.0,
    String? shortName,
    String? description,
    String? venueName,
    String? venueCity,
    String? logoUrl,
    String? bannerUrl,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}/tournaments'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode({
          'name': name,
          'short_name': shortName,
          'description': description,
          'tournament_type': tournamentType,
          'match_format': matchFormat,
          'start_date': startDate,
          'end_date': endDate,
          'registration_deadline': registrationDeadline,
          'max_teams': maxTeams,
          'min_teams': minTeams,
          'entry_fee': entryFee,
          'prize_pool': prizePool,
          'venue_name': venueName,
          'venue_city': venueCity,
          'logo_url': logoUrl,
          'banner_url': bannerUrl,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return _mapTournamentFromBackend(data['tournament']);
      } else {
        throw Exception('Failed to create tournament');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update tournament
  Future<void> updateTournament({
    required String token,
    required String tournamentId,
    String? status,
    String? name,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (status != null) body['status'] = status;
      if (name != null) body['name'] = name;

      final response = await _client.put(
        Uri.parse('${ApiConfig.baseUrl}/tournaments/$tournamentId'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode(body),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update tournament');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Delete tournament
  Future<void> deleteTournament({
    required String token,
    required String tournamentId,
  }) async {
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConfig.baseUrl}/tournaments/$tournamentId'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete tournament');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ===== REGISTRATIONS =====

  // Get tournament registrations
  Future<List<TournamentRegistration>> getTournamentRegistrations({
    required String tournamentId,
    String? status,
  }) async {
    try {
      var uri = Uri.parse(
        '${ApiConfig.baseUrl}/tournaments/$tournamentId/registrations',
      );

      if (status != null) {
        uri = uri.replace(queryParameters: {'status': status});
      }

      final response = await _client.get(uri, headers: ApiConfig.headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['registrations'] as List)
            .map((r) => _mapRegistrationFromBackend(r))
            .toList();
      } else {
        throw Exception('Failed to load registrations');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Register team for tournament
  Future<TournamentRegistration> registerTeam({
    required String token,
    required String tournamentId,
    required String teamId,
    required int squadSize,
    String? captainId,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}/tournaments/$tournamentId/register'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode({
          'team_id': teamId,
          'squad_size': squadSize,
          'captain_id': captainId,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return _mapRegistrationFromBackend(data['registration']);
      } else {
        throw Exception('Failed to register team');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Approve registration
  Future<void> approveRegistration({
    required String token,
    required String registrationId,
  }) async {
    try {
      final response = await _client.put(
        Uri.parse('${ApiConfig.baseUrl}/registrations/$registrationId/approve'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to approve registration');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Reject registration
  Future<void> rejectRegistration({
    required String token,
    required String registrationId,
    String? reason,
  }) async {
    try {
      final response = await _client.put(
        Uri.parse('${ApiConfig.baseUrl}/registrations/$registrationId/reject'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode({'rejection_reason': reason ?? 'Not specified'}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to reject registration');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ===== STANDINGS =====

  // Get tournament standings
  Future<List<TournamentStanding>> getTournamentStandings(
    String tournamentId,
  ) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/tournaments/$tournamentId/standings'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['standings'] as List)
            .map((s) => _mapStandingFromBackend(s))
            .toList();
      } else {
        throw Exception('Failed to load standings');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update standings
  Future<void> updateStandings({
    required String token,
    required String tournamentId,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(
          '${ApiConfig.baseUrl}/tournaments/$tournamentId/standings/update',
        ),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update standings');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // ===== MATCHES =====

  // Get tournament matches
  Future<List<Map<String, dynamic>>> getTournamentMatches(
    String tournamentId,
  ) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/tournaments/$tournamentId/matches'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['matches'] ?? []);
      } else {
        throw Exception('Failed to load matches');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Add match to tournament
  Future<void> addMatchToTournament({
    required String token,
    required String tournamentId,
    required String matchId,
    required int roundNumber,
    int? matchNumber,
    String? roundName,
    String? groupName,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}/tournaments/$tournamentId/matches'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode({
          'match_id': matchId,
          'round_number': roundNumber,
          'match_number': matchNumber,
          'round_name': roundName,
          'group_name': groupName,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add match to tournament');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get my tournaments (as organizer)
  Future<List<Tournament>> getMyTournaments(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/tournaments/my'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['tournaments'] as List)
            .map((t) => _mapTournamentFromBackend(t))
            .toList();
      } else {
        throw Exception('Failed to load my tournaments');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Private mappers

  Tournament _mapTournamentFromBackend(Map<String, dynamic> backend) {
    return Tournament(
      id: backend['id'] as String,
      name: backend['name'] as String,
      shortName: backend['short_name'] as String?,
      description: backend['description'] as String?,
      tournamentType: backend['tournament_type'] as String,
      matchFormat: backend['match_format'] as String,
      startDate: backend['start_date'] as String,
      endDate: backend['end_date'] as String,
      registrationDeadline: backend['registration_deadline'] as String,
      maxTeams: backend['max_teams'] as int,
      minTeams: backend['min_teams'] as int,
      entryFee: (backend['entry_fee'] as num?)?.toDouble() ?? 0.0,
      prizePool: (backend['prize_pool'] as num?)?.toDouble() ?? 0.0,
      status: backend['status'] as String,
      venueName: backend['venue_name'] as String?,
      venueCity: backend['venue_city'] as String?,
      organizerId: backend['organizer_id'] as String,
      logoUrl: backend['logo_url'] as String?,
      bannerUrl: backend['banner_url'] as String?,
      createdAt: backend['created_at'] as String,
    );
  }

  TournamentRegistration _mapRegistrationFromBackend(
    Map<String, dynamic> backend,
  ) {
    return TournamentRegistration(
      id: backend['id'] as String,
      tournamentId: backend['tournament_id'] as String,
      teamId: backend['team_id'] as String,
      registrationDate: backend['registration_date'] as String,
      status: backend['status'] as String,
      paymentStatus: backend['payment_status'] as String,
      captainId: backend['captain_id'] as String?,
      squadSize: backend['squad_size'] as int,
      approvedBy: backend['approved_by'] as String?,
      approvedAt: backend['approved_at'] as String?,
      rejectionReason: backend['rejection_reason'] as String?,
      createdAt: backend['created_at'] as String,
    );
  }

  TournamentStanding _mapStandingFromBackend(Map<String, dynamic> backend) {
    return TournamentStanding(
      id: backend['id'] as String,
      tournamentId: backend['tournament_id'] as String,
      teamId: backend['team_id'] as String,
      position: backend['position'] as int,
      matchesPlayed: backend['matches_played'] as int,
      matchesWon: backend['matches_won'] as int,
      matchesLost: backend['matches_lost'] as int,
      matchesDrawn: backend['matches_drawn'] as int? ?? 0,
      matchesAbandoned: backend['matches_abandoned'] as int? ?? 0,
      points: backend['points'] as int,
      netRunRate: (backend['net_run_rate'] as num?)?.toDouble() ?? 0.0,
      runsScored: backend['runs_scored'] as int? ?? 0,
      runsConceded: backend['runs_conceded'] as int? ?? 0,
      wicketsTaken: backend['wickets_taken'] as int? ?? 0,
      wicketsLost: backend['wickets_lost'] as int? ?? 0,
      updatedAt: backend['updated_at'] as String,
    );
  }
}
