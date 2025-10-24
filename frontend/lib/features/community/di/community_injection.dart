import '../data/datasources/community_api_service.dart';
import '../data/repositories/real_community_repository.dart';
import '../domain/repositories/community_repository.dart';

class CommunityDependencyInjection {
  static CommunityApiService? _communityApiService;
  static CommunityRepository? _communityRepository;

  static CommunityApiService get communityApiService {
    _communityApiService ??= CommunityApiService();
    return _communityApiService!;
  }

  static Future<CommunityRepository> get communityRepository async {
    _communityRepository ??= RealCommunityRepository(communityApiService);
    return _communityRepository!;
  }

  static void reset() {
    _communityApiService = null;
    _communityRepository = null;
  }
}
