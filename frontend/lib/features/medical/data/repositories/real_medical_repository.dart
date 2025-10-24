import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/medical_repository.dart';
import '../datasources/medical_api_service.dart';

class RealMedicalRepository implements MedicalRepository {
  final MedicalApiService _apiService;
  static const _keyToken = 'auth_token';

  RealMedicalRepository(this._apiService);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  @override
  Future<Map<String, dynamic>> listPhysiotherapists({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final result = await _apiService.listPhysiotherapists(
        page: page,
        limit: limit,
      );

      return {
        'success': true,
        'data': result['data'],
        'pagination': result['pagination'],
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load physiotherapists: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getPhysiotherapistDetails(
    String physioId,
  ) async {
    try {
      final physio = await _apiService.getPhysiotherapistDetails(physioId);

      return {'success': true, 'data': physio};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load physiotherapist details: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> createAppointment({
    required String physioId,
    required String date,
    required String time,
    required String complaint,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      final appointment = await _apiService.createAppointment(
        token: token,
        physioId: physioId,
        appointmentDate: date,
        appointmentTime: time,
        complaint: complaint,
      );

      return {
        'success': true,
        'data': appointment,
        'message': 'Appointment booked successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create appointment: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getMyAppointments() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      final appointments = await _apiService.getMyAppointments(token);

      return {'success': true, 'data': appointments};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load appointments: ${e.toString()}',
      };
    }
  }
}
