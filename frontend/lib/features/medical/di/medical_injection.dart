import '../data/datasources/medical_api_service.dart';
import '../data/repositories/real_medical_repository.dart';
import '../domain/repositories/medical_repository.dart';

class MedicalDependencyInjection {
  static MedicalApiService? _medicalApiService;
  static MedicalRepository? _medicalRepository;

  static MedicalApiService get medicalApiService {
    _medicalApiService ??= MedicalApiService();
    return _medicalApiService!;
  }

  static Future<MedicalRepository> get medicalRepository async {
    _medicalRepository ??= RealMedicalRepository(medicalApiService);
    return _medicalRepository!;
  }

  static void reset() {
    _medicalApiService = null;
    _medicalRepository = null;
  }
}
