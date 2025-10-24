import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/tournament_repository.dart';
import '../datasources/tournament_api_service.dart';

class RealTournamentRepository implements TournamentRepository {
  final TournamentApiService _apiService;
  static const _keyToken = 'auth_token';

  RealTournamentRepository(this._apiService);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  @override
  Future<Map<String, dynamic>> listTournaments({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final result = await _apiService.listTournaments(
        page: page,
        limit: limit,
        status: status,
      );
      return {
        'success': true,
        'data': result['data'],
        'pagination': result['pagination'],
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load tournaments: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getTournamentDetails(String tournamentId) async {
    try {
      final tournament = await _apiService.getTournamentDetails(tournamentId);
      return {'success': true, 'data': tournament};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load tournament details: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> createTournament({
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
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      final tournament = await _apiService.createTournament(
        token: token,
        name: name,
        tournamentType: tournamentType,
        matchFormat: matchFormat,
        startDate: startDate,
        endDate: endDate,
        registrationDeadline: registrationDeadline,
        maxTeams: maxTeams,
        minTeams: minTeams,
        entryFee: entryFee,
        prizePool: prizePool,
        shortName: shortName,
        description: description,
        venueName: venueName,
        venueCity: venueCity,
        logoUrl: logoUrl,
        bannerUrl: bannerUrl,
      );

      return {
        'success': true,
        'data': tournament,
        'message': 'Tournament created successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create tournament: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> updateTournament({
    required String tournamentId,
    String? status,
    String? name,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.updateTournament(
        token: token,
        tournamentId: tournamentId,
        status: status,
        name: name,
      );

      return {'success': true, 'message': 'Tournament updated successfully'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update tournament: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> deleteTournament(String tournamentId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.deleteTournament(
        token: token,
        tournamentId: tournamentId,
      );

      return {'success': true, 'message': 'Tournament deleted successfully'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete tournament: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getMyTournaments() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      final tournaments = await _apiService.getMyTournaments(token);

      return {'success': true, 'data': tournaments};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load my tournaments: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getTournamentRegistrations({
    required String tournamentId,
    String? status,
  }) async {
    try {
      final registrations = await _apiService.getTournamentRegistrations(
        tournamentId: tournamentId,
        status: status,
      );

      return {'success': true, 'data': registrations};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load registrations: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> registerTeam({
    required String tournamentId,
    required String teamId,
    required int squadSize,
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

      final registration = await _apiService.registerTeam(
        token: token,
        tournamentId: tournamentId,
        teamId: teamId,
        squadSize: squadSize,
        captainId: captainId,
      );

      return {
        'success': true,
        'data': registration,
        'message': 'Team registered successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to register team: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> approveRegistration(
    String registrationId,
  ) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.approveRegistration(
        token: token,
        registrationId: registrationId,
      );

      return {'success': true, 'message': 'Registration approved successfully'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to approve registration: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> rejectRegistration(
    String registrationId,
    String? reason,
  ) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.rejectRegistration(
        token: token,
        registrationId: registrationId,
        reason: reason,
      );

      return {'success': true, 'message': 'Registration rejected'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to reject registration: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getTournamentStandings(
    String tournamentId,
  ) async {
    try {
      final standings = await _apiService.getTournamentStandings(tournamentId);

      return {'success': true, 'data': standings};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load standings: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> updateStandings(String tournamentId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.updateStandings(
        token: token,
        tournamentId: tournamentId,
      );

      return {'success': true, 'message': 'Standings updated successfully'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update standings: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getTournamentMatches(String tournamentId) async {
    try {
      final matches = await _apiService.getTournamentMatches(tournamentId);

      return {'success': true, 'data': matches};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load matches: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> addMatchToTournament({
    required String tournamentId,
    required String matchId,
    required int roundNumber,
    int? matchNumber,
    String? roundName,
    String? groupName,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.addMatchToTournament(
        token: token,
        tournamentId: tournamentId,
        matchId: matchId,
        roundNumber: roundNumber,
        matchNumber: matchNumber,
        roundName: roundName,
        groupName: groupName,
      );

      return {
        'success': true,
        'message': 'Match added to tournament successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to add match to tournament: ${e.toString()}',
      };
    }
  }
}
