import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';

class GroundApiService {
  final http.Client client;

  GroundApiService({http.Client? client}) : client = client ?? http.Client();

  /// Get list of grounds with pagination
  Future<Map<String, dynamic>> listGrounds({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfig.baseUrl}/grounds?page=$page&limit=$limit'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'grounds': (data['data']['grounds'] as List)
              .map((g) => _mapGroundFromBackend(g))
              .toList(),
          'pagination': data['data']['pagination'],
        };
      } else {
        return {'success': false, 'message': 'Failed to load grounds'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  /// Get ground details by ID
  Future<Map<String, dynamic>> getGroundDetails(String groundId) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfig.baseUrl}/grounds/$groundId'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'ground': _mapGroundFromBackend(data['data'])};
      } else {
        return {'success': false, 'message': 'Failed to load ground details'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  /// Create a booking
  Future<Map<String, dynamic>> createBooking({
    required String token,
    required String groundId,
    required String bookingDate,
    required String startTime,
    required String endTime,
    required String durationType,
    String? notes,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConfig.baseUrl}/bookings'),
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode({
          'ground_id': groundId,
          'booking_date': bookingDate,
          'start_time': startTime,
          'end_time': endTime,
          'duration_type': durationType,
          'notes': notes ?? '',
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'booking': _mapBookingFromBackend(data['data']),
          'message': 'Booking created successfully',
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to create booking',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  /// Get user's bookings
  Future<Map<String, dynamic>> getMyBookings(String token) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConfig.baseUrl}/bookings/my'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'bookings': (data['data'] as List)
              .map((b) => _mapBookingFromBackend(b))
              .toList(),
        };
      } else {
        return {'success': false, 'message': 'Failed to load bookings'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  /// Map backend ground model to frontend model
  Map<String, dynamic> _mapGroundFromBackend(
    Map<String, dynamic> backendGround,
  ) {
    return {
      'id': backendGround['id'],
      'name': backendGround['name'],
      'location': backendGround['address'] ?? '',
      'address': backendGround['address'] ?? '',
      'imageUrl': (backendGround['images'] as List?)?.isNotEmpty == true
          ? backendGround['images'][0]
          : 'https://via.placeholder.com/400x200?text=Cricket+Ground',
      'rating': (backendGround['rating'] ?? 0.0).toDouble(),
      'reviewCount': backendGround['total_reviews'] ?? 0,
      'pricePerHour': (backendGround['hourly_price'] ?? 0.0).toDouble(),
      'facilities':
          (backendGround['facilities'] as List?)?.cast<String>() ?? [],
      'type': 'Cricket Ground',
      'size': 'Full',
      'isAvailable': backendGround['is_active'] ?? true,
      'latitude': (backendGround['latitude'] ?? 0.0).toDouble(),
      'longitude': (backendGround['longitude'] ?? 0.0).toDouble(),
    };
  }

  /// Map backend booking model to frontend model
  Map<String, dynamic> _mapBookingFromBackend(
    Map<String, dynamic> backendBooking,
  ) {
    return {
      'id': backendBooking['id'],
      'groundId': backendBooking['ground_id'],
      'userId': backendBooking['user_id'],
      'bookingDate': backendBooking['booking_date'],
      'startTime': backendBooking['start_time'],
      'endTime': backendBooking['end_time'],
      'durationType': backendBooking['duration_type'],
      'totalPrice': (backendBooking['total_price'] ?? 0.0).toDouble(),
      'status': backendBooking['status'],
      'paymentStatus': backendBooking['payment_status'],
      'notes': backendBooking['notes'] ?? '',
      'createdAt': backendBooking['created_at'],
    };
  }
}
