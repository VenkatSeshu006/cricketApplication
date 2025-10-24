import '../data/datasources/match_api_service.dart';
import '../data/repositories/real_match_repository.dart';
import '../domain/repositories/match_repository.dart';

class MatchDependencyInjection {
  static MatchApiService? _matchApiService;
  static MatchRepository? _matchRepository;

  static MatchApiService get matchApiService {
    _matchApiService ??= MatchApiService();
    return _matchApiService!;
  }

  static Future<MatchRepository> get matchRepository async {
    _matchRepository ??= RealMatchRepository(matchApiService);
    return _matchRepository!;
  }

  static void reset() {
    _matchApiService = null;
    _matchRepository = null;
  }
}
