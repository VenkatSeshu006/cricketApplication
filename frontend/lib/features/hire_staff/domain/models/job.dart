class Job {
  final String id;
  final String employerId;
  final String employerName;
  final String title;
  final String description;
  final String
  jobType; // coach, groundsman, umpire, scorer, physio, trainer, manager
  final String experienceRequired;
  final String location;
  final String salaryRange;
  final String employmentType; // full-time, part-time, contract, freelance
  final List<String> requirements;
  final List<String> responsibilities;
  final List<String> benefits;
  final String applicationDeadline; // YYYY-MM-DD
  final String status; // open, closed, filled
  final int totalApplications;
  final String createdAt;

  Job({
    required this.id,
    required this.employerId,
    required this.employerName,
    required this.title,
    required this.description,
    required this.jobType,
    required this.experienceRequired,
    required this.location,
    required this.salaryRange,
    required this.employmentType,
    required this.requirements,
    required this.responsibilities,
    required this.benefits,
    required this.applicationDeadline,
    required this.status,
    required this.totalApplications,
    required this.createdAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] as String,
      employerId: json['employerId'] as String,
      employerName: json['employerName'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      jobType: json['jobType'] as String,
      experienceRequired: json['experienceRequired'] as String? ?? '',
      location: json['location'] as String,
      salaryRange: json['salaryRange'] as String? ?? '',
      employmentType: json['employmentType'] as String,
      requirements: List<String>.from(json['requirements'] ?? []),
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      applicationDeadline: json['applicationDeadline'] as String? ?? '',
      status: json['status'] as String,
      totalApplications: json['totalApplications'] as int? ?? 0,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employerId': employerId,
      'employerName': employerName,
      'title': title,
      'description': description,
      'jobType': jobType,
      'experienceRequired': experienceRequired,
      'location': location,
      'salaryRange': salaryRange,
      'employmentType': employmentType,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'benefits': benefits,
      'applicationDeadline': applicationDeadline,
      'status': status,
      'totalApplications': totalApplications,
      'createdAt': createdAt,
    };
  }

  String get statusDisplay {
    switch (status) {
      case 'open':
        return 'Open';
      case 'closed':
        return 'Closed';
      case 'filled':
        return 'Filled';
      default:
        return 'Unknown';
    }
  }

  String get employmentTypeDisplay {
    switch (employmentType) {
      case 'full-time':
        return 'Full-time';
      case 'part-time':
        return 'Part-time';
      case 'contract':
        return 'Contract';
      case 'freelance':
        return 'Freelance';
      default:
        return employmentType;
    }
  }
}
