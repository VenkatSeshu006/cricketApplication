class Tournament {
  final String id;
  final String name;
  final String? shortName;
  final String? description;
  final String tournamentType; // knockout, round_robin, league, mixed
  final String matchFormat; // T10, T20, ODI, Test
  final String startDate;
  final String endDate;
  final String registrationDeadline;
  final int maxTeams;
  final int minTeams;
  final double entryFee;
  final double prizePool;
  final String
  status; // upcoming, registration_open, registration_closed, ongoing, completed, cancelled
  final String? venueName;
  final String? venueCity;
  final String organizerId;
  final String? logoUrl;
  final String? bannerUrl;
  final String createdAt;

  Tournament({
    required this.id,
    required this.name,
    this.shortName,
    this.description,
    required this.tournamentType,
    required this.matchFormat,
    required this.startDate,
    required this.endDate,
    required this.registrationDeadline,
    required this.maxTeams,
    required this.minTeams,
    required this.entryFee,
    required this.prizePool,
    required this.status,
    this.venueName,
    this.venueCity,
    required this.organizerId,
    this.logoUrl,
    this.bannerUrl,
    required this.createdAt,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['shortName'] as String?,
      description: json['description'] as String?,
      tournamentType: json['tournamentType'] as String,
      matchFormat: json['matchFormat'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      registrationDeadline: json['registrationDeadline'] as String,
      maxTeams: json['maxTeams'] as int,
      minTeams: json['minTeams'] as int,
      entryFee: (json['entryFee'] as num?)?.toDouble() ?? 0.0,
      prizePool: (json['prizePool'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String,
      venueName: json['venueName'] as String?,
      venueCity: json['venueCity'] as String?,
      organizerId: json['organizerId'] as String,
      logoUrl: json['logoUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortName': shortName,
      'description': description,
      'tournamentType': tournamentType,
      'matchFormat': matchFormat,
      'startDate': startDate,
      'endDate': endDate,
      'registrationDeadline': registrationDeadline,
      'maxTeams': maxTeams,
      'minTeams': minTeams,
      'entryFee': entryFee,
      'prizePool': prizePool,
      'status': status,
      'venueName': venueName,
      'venueCity': venueCity,
      'organizerId': organizerId,
      'logoUrl': logoUrl,
      'bannerUrl': bannerUrl,
      'createdAt': createdAt,
    };
  }

  String get statusDisplay {
    switch (status) {
      case 'upcoming':
        return 'Upcoming';
      case 'registration_open':
        return 'Registration Open';
      case 'registration_closed':
        return 'Registration Closed';
      case 'ongoing':
        return 'Ongoing';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  bool get isRegistrationOpen => status == 'registration_open';
  bool get isOngoing => status == 'ongoing';
  bool get isCompleted => status == 'completed';
}
