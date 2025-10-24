class Booking {
  final String id;
  final String groundId;
  final String userId;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final String durationType;
  final double totalPrice;
  final String status;
  final String paymentStatus;
  final String notes;
  final String createdAt;

  Booking({
    required this.id,
    required this.groundId,
    required this.userId,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.durationType,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    required this.notes,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      groundId: json['groundId'] as String,
      userId: json['userId'] as String,
      bookingDate: json['bookingDate'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      durationType: json['durationType'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String,
      paymentStatus: json['paymentStatus'] as String,
      notes: json['notes'] as String? ?? '',
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groundId': groundId,
      'userId': userId,
      'bookingDate': bookingDate,
      'startTime': startTime,
      'endTime': endTime,
      'durationType': durationType,
      'totalPrice': totalPrice,
      'status': status,
      'paymentStatus': paymentStatus,
      'notes': notes,
      'createdAt': createdAt,
    };
  }

  // Helper getters
  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'cancelled':
        return 'Cancelled';
      case 'completed':
        return 'Completed';
      default:
        return status;
    }
  }

  String get paymentStatusDisplay {
    switch (paymentStatus) {
      case 'pending':
        return 'Payment Pending';
      case 'paid':
        return 'Paid';
      case 'refunded':
        return 'Refunded';
      default:
        return paymentStatus;
    }
  }
}
