import '../data/datasources/hiring_api_service.dart';
import '../data/repositories/real_hiring_repository.dart';
import '../domain/repositories/hiring_repository.dart';

class HiringDependencyInjection {
  static HiringApiService? _hiringApiService;
  static HiringRepository? _hiringRepository;

  static HiringApiService get hiringApiService {
    _hiringApiService ??= HiringApiService();
    return _hiringApiService!;
  }

  static Future<HiringRepository> get hiringRepository async {
    _hiringRepository ??= RealHiringRepository(hiringApiService);
    return _hiringRepository!;
  }

  static void reset() {
    _hiringApiService = null;
    _hiringRepository = null;
  }
}
