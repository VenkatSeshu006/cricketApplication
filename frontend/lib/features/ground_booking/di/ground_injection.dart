import 'package:shared_preferences/shared_preferences.dart';
import '../data/datasources/ground_api_service.dart';
import '../data/repositories/real_ground_repository.dart';
import '../domain/repositories/ground_repository.dart';

class GroundDependencyInjection {
  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static GroundApiService get groundApiService => GroundApiService();

  static GroundRepository get groundRepository => RealGroundRepository(
    apiService: groundApiService,
    sharedPreferences: _sharedPreferences,
  );
}
