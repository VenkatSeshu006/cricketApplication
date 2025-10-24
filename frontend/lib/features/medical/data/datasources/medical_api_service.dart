import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';

class MedicalApiService {
  final http.Client client;

  MedicalApiService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> listPhysiotherapists({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await client.get(
        Uri.parse(
          '${ApiConfig.baseUrl}/physiotherapists?page=$page&limit=$limit',
        ),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'physiotherapists': (data['data']['physiotherapists'] as List)
              .map((p) => _mapPhysioFromBackend(p))
              .toList(),
          'pagination': data['data']['pagination'],
        };
      } else {
        return {'success': false, 'message': 'Failed to load physiotherapists'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> getPhysiotherapistDetails(
    String physioId,
  ) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfig.baseUrl}/physiotherapists/$physioId'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'physiotherapist': _mapPhysioFromBackend(data['data']),
        };
      } else {
        return {'success': false, 'message': 'Failed to load details'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> createAppointment({
    required String token,
    required String physioId,
    required String appointmentDate,
    required String appointmentTime,
    required String complaint,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfig.baseUrl}/appointments'),
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode({
          'physiotherapist_id': physioId,
          'appointment_date': appointmentDate,
          'appointment_time': appointmentTime,
          'complaint': complaint,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'appointment': _mapAppointmentFromBackend(data['data']),
          'message': 'Appointment booked successfully',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to book',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> getMyAppointments(String token) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfig.baseUrl}/appointments/my'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'appointments': (data['data'] as List)
              .map((a) => _mapAppointmentFromBackend(a))
              .toList(),
        };
      } else {
        return {'success': false, 'message': 'Failed to load appointments'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Map<String, dynamic> _mapPhysioFromBackend(Map<String, dynamic> backend) {
    return {
      'id': backend['id'],
      'name': backend['full_name'],
      'qualification':
          (backend['qualifications'] as List?)?.first ?? 'Certified',
      'specialization': backend['specialization'] ?? 'General',
      'experience': backend['experience_years'] ?? 0,
      'imageUrl':
          backend['profile_image_url'] ?? 'https://via.placeholder.com/150',
      'rating': (backend['rating'] ?? 0.0).toDouble(),
      'reviewCount': backend['total_reviews'] ?? 0,
      'location': backend['clinic_address'] ?? '',
      'clinic': backend['clinic_name'] ?? 'Private Practice',
      'about': backend['bio'] ?? '',
      'expertise': (backend['qualifications'] as List?)?.cast<String>() ?? [],
      'languages': ['English', 'Hindi'],
      'consultationFee': (backend['consultation_fee'] ?? 0.0).toDouble(),
      'isAvailable': backend['is_verified'] ?? true,
      'nextAvailable': 'Today',
      'workingDays': (backend['available_days'] as List?)?.cast<String>() ?? [],
      'workingHours': backend['available_hours'] ?? '9 AM - 6 PM',
      'certifications':
          (backend['qualifications'] as List?)?.cast<String>() ?? [],
    };
  }

  Map<String, dynamic> _mapAppointmentFromBackend(
    Map<String, dynamic> backend,
  ) {
    return {
      'id': backend['id'],
      'physiotherapistId': backend['physiotherapist_id'],
      'patientId': backend['patient_id'],
      'appointmentDate': backend['appointment_date'],
      'appointmentTime': backend['appointment_time'],
      'durationMinutes': backend['duration_minutes'] ?? 60,
      'status': backend['status'],
      'complaint': backend['complaint'] ?? '',
      'notes': backend['notes'] ?? '',
      'fee': (backend['fee'] ?? 0.0).toDouble(),
      'paymentStatus': backend['payment_status'],
      'createdAt': backend['created_at'],
    };
  }
}
