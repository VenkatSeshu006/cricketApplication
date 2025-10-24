import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/ground.dart';
import '../../domain/models/booking.dart';
import '../../domain/repositories/ground_repository.dart';
import '../datasources/ground_api_service.dart';

class RealGroundRepository implements GroundRepository {
  final GroundApiService apiService;
  final SharedPreferences sharedPreferences;

  static const String _keyToken = 'auth_token';

  RealGroundRepository({
    required this.apiService,
    required this.sharedPreferences,
  });

  @override
  Future<Map<String, dynamic>> listGrounds({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final result = await apiService.listGrounds(page: page, limit: limit);

      if (result['success'] == true) {
        final grounds = (result['grounds'] as List)
            .map((g) => Ground.fromJson(g as Map<String, dynamic>))
            .toList();

        return {
          'success': true,
          'grounds': grounds,
          'pagination': result['pagination'],
        };
      } else {
        return {
          'success': false,
          'message': result['message'],
          'grounds': <Ground>[],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to load grounds: ${e.toString()}',
        'grounds': <Ground>[],
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getGroundDetails(String groundId) async {
    try {
      final result = await apiService.getGroundDetails(groundId);

      if (result['success'] == true) {
        final ground = Ground.fromJson(
          result['ground'] as Map<String, dynamic>,
        );
        return {'success': true, 'ground': ground};
      } else {
        return {'success': false, 'message': result['message']};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to load ground details: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> createBooking({
    required String groundId,
    required String bookingDate,
    required String startTime,
    required String endTime,
    required String durationType,
    String? notes,
  }) async {
    try {
      final token = sharedPreferences.getString(_keyToken);
      if (token == null) {
        return {
          'success': false,
          'message': 'Please login to create a booking',
        };
      }

      final result = await apiService.createBooking(
        token: token,
        groundId: groundId,
        bookingDate: bookingDate,
        startTime: startTime,
        endTime: endTime,
        durationType: durationType,
        notes: notes,
      );

      if (result['success'] == true) {
        final booking = Booking.fromJson(
          result['booking'] as Map<String, dynamic>,
        );
        return {
          'success': true,
          'booking': booking,
          'message': result['message'],
        };
      } else {
        return {'success': false, 'message': result['message']};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to create booking: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getMyBookings() async {
    try {
      final token = sharedPreferences.getString(_keyToken);
      if (token == null) {
        return {
          'success': false,
          'message': 'Please login to view bookings',
          'bookings': <Booking>[],
        };
      }

      final result = await apiService.getMyBookings(token);

      if (result['success'] == true) {
        final bookings = (result['bookings'] as List)
            .map((b) => Booking.fromJson(b as Map<String, dynamic>))
            .toList();

        return {'success': true, 'bookings': bookings};
      } else {
        return {
          'success': false,
          'message': result['message'],
          'bookings': <Booking>[],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to load bookings: ${e.toString()}',
        'bookings': <Booking>[],
      };
    }
  }
}
