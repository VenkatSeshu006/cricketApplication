class JobApplication {
  final String id;
  final String jobId;
  final String applicantId;
  final String applicantName;
  final String applicantEmail;
  final String coverLetter;
  final String resumeUrl;
  final int experienceYears;
  final String relevantExperience;
  final String availability;
  final String expectedSalary;
  final String status; // pending, reviewing, shortlisted, rejected, accepted
  final String appliedAt;
  final String reviewedAt;
  final String notes;

  JobApplication({
    required this.id,
    required this.jobId,
    required this.applicantId,
    required this.applicantName,
    required this.applicantEmail,
    required this.coverLetter,
    required this.resumeUrl,
    required this.experienceYears,
    required this.relevantExperience,
    required this.availability,
    required this.expectedSalary,
    required this.status,
    required this.appliedAt,
    required this.reviewedAt,
    required this.notes,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'] as String,
      jobId: json['jobId'] as String,
      applicantId: json['applicantId'] as String,
      applicantName: json['applicantName'] as String,
      applicantEmail: json['applicantEmail'] as String,
      coverLetter: json['coverLetter'] as String,
      resumeUrl: json['resumeUrl'] as String? ?? '',
      experienceYears: json['experienceYears'] as int? ?? 0,
      relevantExperience: json['relevantExperience'] as String? ?? '',
      availability: json['availability'] as String? ?? '',
      expectedSalary: json['expectedSalary'] as String? ?? '',
      status: json['status'] as String,
      appliedAt: json['appliedAt'] as String,
      reviewedAt: json['reviewedAt'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'applicantId': applicantId,
      'applicantName': applicantName,
      'applicantEmail': applicantEmail,
      'coverLetter': coverLetter,
      'resumeUrl': resumeUrl,
      'experienceYears': experienceYears,
      'relevantExperience': relevantExperience,
      'availability': availability,
      'expectedSalary': expectedSalary,
      'status': status,
      'appliedAt': appliedAt,
      'reviewedAt': reviewedAt,
      'notes': notes,
    };
  }

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending Review';
      case 'reviewing':
        return 'Under Review';
      case 'shortlisted':
        return 'Shortlisted';
      case 'rejected':
        return 'Rejected';
      case 'accepted':
        return 'Accepted';
      default:
        return 'Unknown';
    }
  }
}
