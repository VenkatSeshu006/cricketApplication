
abstract class TournamentRepository {
  // Tournaments
  Future<Map<String, dynamic>> listTournaments({
    int page = 1,
    int limit = 10,
    String? status,
  });
  Future<Map<String, dynamic>> getTournamentDetails(String tournamentId);
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
  });
  Future<Map<String, dynamic>> updateTournament({
    required String tournamentId,
    String? status,
    String? name,
  });
  Future<Map<String, dynamic>> deleteTournament(String tournamentId);
  Future<Map<String, dynamic>> getMyTournaments();

  // Registrations
  Future<Map<String, dynamic>> getTournamentRegistrations({
    required String tournamentId,
    String? status,
  });
  Future<Map<String, dynamic>> registerTeam({
    required String tournamentId,
    required String teamId,
    required int squadSize,
    String? captainId,
  });
  Future<Map<String, dynamic>> approveRegistration(String registrationId);
  Future<Map<String, dynamic>> rejectRegistration(
    String registrationId,
    String? reason,
  );

  // Standings
  Future<Map<String, dynamic>> getTournamentStandings(String tournamentId);
  Future<Map<String, dynamic>> updateStandings(String tournamentId);

  // Matches
  Future<Map<String, dynamic>> getTournamentMatches(String tournamentId);
  Future<Map<String, dynamic>> addMatchToTournament({
    required String tournamentId,
    required String matchId,
    required int roundNumber,
    int? matchNumber,
    String? roundName,
    String? groupName,
  });
}
