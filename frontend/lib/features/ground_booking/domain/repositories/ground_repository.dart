
abstract class GroundRepository {
  Future<Map<String, dynamic>> listGrounds({int page = 1, int limit = 10});
  Future<Map<String, dynamic>> getGroundDetails(String groundId);
  Future<Map<String, dynamic>> createBooking({
    required String groundId,
    required String bookingDate,
    required String startTime,
    required String endTime,
    required String durationType,
    String? notes,
  });
  Future<Map<String, dynamic>> getMyBookings();
}
