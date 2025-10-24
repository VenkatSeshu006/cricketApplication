
abstract class MedicalRepository {
  Future<Map<String, dynamic>> listPhysiotherapists({
    int page = 1,
    int limit = 10,
  });
  Future<Map<String, dynamic>> getPhysiotherapistDetails(String physioId);
  Future<Map<String, dynamic>> createAppointment({
    required String physioId,
    required String date,
    required String time,
    required String complaint,
  });
  Future<Map<String, dynamic>> getMyAppointments();
}
