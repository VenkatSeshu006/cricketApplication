class Appointment {
  final String id;
  final String physiotherapistId;
  final String patientId;
  final String appointmentDate;
  final String appointmentTime;
  final int durationMinutes;
  final String status;
  final String complaint;
  final String notes;
  final double fee;
  final String paymentStatus;
  final String createdAt;

  Appointment({
    required this.id,
    required this.physiotherapistId,
    required this.patientId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.durationMinutes,
    required this.status,
    required this.complaint,
    required this.notes,
    required this.fee,
    required this.paymentStatus,
    required this.createdAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      physiotherapistId: json['physiotherapistId'] as String,
      patientId: json['patientId'] as String,
      appointmentDate: json['appointmentDate'] as String,
      appointmentTime: json['appointmentTime'] as String,
      durationMinutes: json['durationMinutes'] as int? ?? 60,
      status: json['status'] as String,
      complaint: json['complaint'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      fee: (json['fee'] as num).toDouble(),
      paymentStatus: json['paymentStatus'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
}
