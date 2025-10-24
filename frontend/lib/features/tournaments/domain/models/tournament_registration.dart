class TournamentRegistration {
  final String id;
  final String tournamentId;
  final String teamId;
  final String registrationDate;
  final String status; // pending, approved, rejected, withdrawn
  final String paymentStatus; // pending, paid, refunded
  final String? captainId;
  final int squadSize;
  final String? approvedBy;
  final String? approvedAt;
  final String? rejectionReason;
  final String createdAt;

  TournamentRegistration({
    required this.id,
    required this.tournamentId,
    required this.teamId,
    required this.registrationDate,
    required this.status,
    required this.paymentStatus,
    this.captainId,
    required this.squadSize,
    this.approvedBy,
    this.approvedAt,
    this.rejectionReason,
    required this.createdAt,
  });

  factory TournamentRegistration.fromJson(Map<String, dynamic> json) {
    return TournamentRegistration(
      id: json['id'] as String,
      tournamentId: json['tournamentId'] as String,
      teamId: json['teamId'] as String,
      registrationDate: json['registrationDate'] as String,
      status: json['status'] as String,
      paymentStatus: json['paymentStatus'] as String,
      captainId: json['captainId'] as String?,
      squadSize: json['squadSize'] as int,
      approvedBy: json['approvedBy'] as String?,
      approvedAt: json['approvedAt'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournamentId': tournamentId,
      'teamId': teamId,
      'registrationDate': registrationDate,
      'status': status,
      'paymentStatus': paymentStatus,
      'captainId': captainId,
      'squadSize': squadSize,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt,
      'rejectionReason': rejectionReason,
      'createdAt': createdAt,
    };
  }

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'withdrawn':
        return 'Withdrawn';
      default:
        return 'Unknown';
    }
  }

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
}
