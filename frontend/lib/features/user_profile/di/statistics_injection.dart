import '../data/datasources/statistics_api_service.dart';
import '../data/repositories/real_statistics_repository.dart';
import '../domain/repositories/statistics_repository.dart';

class StatisticsDependencyInjection {
  static StatisticsApiService? _statisticsApiService;
  static StatisticsRepository? _statisticsRepository;

  static StatisticsApiService get statisticsApiService {
    _statisticsApiService ??= StatisticsApiService();
    return _statisticsApiService!;
  }

  static Future<StatisticsRepository> get statisticsRepository async {
    _statisticsRepository ??= RealStatisticsRepository(statisticsApiService);
    return _statisticsRepository!;
  }

  static void reset() {
    _statisticsApiService = null;
    _statisticsRepository = null;
  }
}
