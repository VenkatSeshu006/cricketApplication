import '../data/datasources/tournament_api_service.dart';
import '../data/repositories/real_tournament_repository.dart';
import '../domain/repositories/tournament_repository.dart';

class TournamentDependencyInjection {
  static TournamentApiService? _tournamentApiService;
  static TournamentRepository? _tournamentRepository;

  static TournamentApiService get tournamentApiService {
    _tournamentApiService ??= TournamentApiService();
    return _tournamentApiService!;
  }

  static Future<TournamentRepository> get tournamentRepository async {
    _tournamentRepository ??= RealTournamentRepository(tournamentApiService);
    return _tournamentRepository!;
  }

  static void reset() {
    _tournamentApiService = null;
    _tournamentRepository = null;
  }
}
