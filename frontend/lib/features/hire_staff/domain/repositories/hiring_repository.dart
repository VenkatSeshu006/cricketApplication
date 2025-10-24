
abstract class HiringRepository {
  Future<Map<String, dynamic>> listJobs({
    int page = 1,
    int limit = 10,
    String? jobType,
    String? location,
    String? status,
  });

  Future<Map<String, dynamic>> getJobDetails(String jobId);

  Future<Map<String, dynamic>> createJob({
    required String title,
    required String description,
    required String jobType,
    required String location,
    required String employmentType,
    String? experienceRequired,
    String? salaryRange,
    List<String>? requirements,
    List<String>? responsibilities,
    List<String>? benefits,
    String? applicationDeadline,
  });

  Future<Map<String, dynamic>> applyForJob({
    required String jobId,
    required String coverLetter,
    required int experienceYears,
    String? resumeUrl,
    String? relevantExperience,
    String? availability,
    String? expectedSalary,
  });

  Future<Map<String, dynamic>> getJobApplications(String jobId);

  Future<Map<String, dynamic>> updateApplicationStatus({
    required String applicationId,
    required String status,
    String? notes,
  });

  Future<Map<String, dynamic>> getMyJobs();

  Future<Map<String, dynamic>> getMyApplications();

  Future<Map<String, dynamic>> updateJob({
    required String jobId,
    String? status,
    String? title,
    String? description,
  });
}
