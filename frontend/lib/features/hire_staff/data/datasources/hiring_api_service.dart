import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/api_config.dart';
import '../../domain/models/job.dart';
import '../../domain/models/job_application.dart';

class HiringApiService {
  final http.Client _client = http.Client();

  // List all job postings
  Future<Map<String, dynamic>> listJobs({
    int page = 1,
    int limit = 10,
    String? jobType,
    String? location,
    String? status,
  }) async {
    try {
      var uri = Uri.parse('${ApiConfig.baseUrl}/jobs?page=$page&limit=$limit');

      if (jobType != null) {
        uri = uri.replace(
          queryParameters: {...uri.queryParameters, 'job_type': jobType},
        );
      }
      if (location != null) {
        uri = uri.replace(
          queryParameters: {...uri.queryParameters, 'location': location},
        );
      }
      if (status != null) {
        uri = uri.replace(
          queryParameters: {...uri.queryParameters, 'status': status},
        );
      }

      final response = await _client.get(uri, headers: ApiConfig.headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'data': (data['jobs'] as List)
              .map((j) => _mapJobFromBackend(j))
              .toList(),
          'pagination': data['pagination'],
        };
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get job details
  Future<Job> getJobDetails(String jobId) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/jobs/$jobId'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _mapJobFromBackend(data['job']);
      } else {
        throw Exception('Failed to load job details');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Create new job posting (employer only)
  Future<Job> createJob({
    required String token,
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
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}/jobs'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode({
          'title': title,
          'description': description,
          'job_type': jobType,
          'location': location,
          'employment_type': employmentType,
          'experience_required': experienceRequired ?? '',
          'salary_range': salaryRange ?? '',
          'requirements': requirements ?? [],
          'responsibilities': responsibilities ?? [],
          'benefits': benefits ?? [],
          'application_deadline': applicationDeadline ?? '',
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return _mapJobFromBackend(data['job']);
      } else {
        throw Exception('Failed to create job');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Apply for a job
  Future<JobApplication> applyForJob({
    required String token,
    required String jobId,
    required String coverLetter,
    required int experienceYears,
    String? resumeUrl,
    String? relevantExperience,
    String? availability,
    String? expectedSalary,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}/jobs/$jobId/apply'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode({
          'cover_letter': coverLetter,
          'resume_url': resumeUrl ?? '',
          'experience_years': experienceYears,
          'relevant_experience': relevantExperience ?? '',
          'availability': availability ?? '',
          'expected_salary': expectedSalary ?? '',
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return _mapApplicationFromBackend(data['application']);
      } else {
        throw Exception('Failed to apply for job');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get applications for a job (employer only)
  Future<List<JobApplication>> getJobApplications({
    required String token,
    required String jobId,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/jobs/$jobId/applications'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['applications'] as List)
            .map((app) => _mapApplicationFromBackend(app))
            .toList();
      } else {
        throw Exception('Failed to load applications');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update application status (employer only)
  Future<void> updateApplicationStatus({
    required String token,
    required String applicationId,
    required String status,
    String? notes,
  }) async {
    try {
      final response = await _client.put(
        Uri.parse('${ApiConfig.baseUrl}/applications/$applicationId/status'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode({'status': status, 'notes': notes ?? ''}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update application status');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get my posted jobs (employer)
  Future<List<Job>> getMyJobs(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/jobs/my'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['jobs'] as List)
            .map((j) => _mapJobFromBackend(j))
            .toList();
      } else {
        throw Exception('Failed to load my jobs');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get my applications (applicant)
  Future<List<JobApplication>> getMyApplications(String token) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/applications/my'),
        headers: ApiConfig.authHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['applications'] as List)
            .map((app) => _mapApplicationFromBackend(app))
            .toList();
      } else {
        throw Exception('Failed to load my applications');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update job posting (employer only)
  Future<void> updateJob({
    required String token,
    required String jobId,
    String? status,
    String? title,
    String? description,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (status != null) body['status'] = status;
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;

      final response = await _client.put(
        Uri.parse('${ApiConfig.baseUrl}/jobs/$jobId'),
        headers: ApiConfig.authHeaders(token),
        body: json.encode(body),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update job');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Private mapper: Backend JobPosting -> Frontend Job
  Job _mapJobFromBackend(Map<String, dynamic> backendJob) {
    return Job(
      id: backendJob['id'] as String,
      employerId: backendJob['employer_id'] as String,
      employerName: backendJob['employer_name'] as String? ?? 'Unknown',
      title: backendJob['title'] as String,
      description: backendJob['description'] as String,
      jobType: backendJob['job_type'] as String,
      experienceRequired: backendJob['experience_required'] as String? ?? '',
      location: backendJob['location'] as String,
      salaryRange: backendJob['salary_range'] as String? ?? '',
      employmentType: backendJob['employment_type'] as String,
      requirements: List<String>.from(backendJob['requirements'] ?? []),
      responsibilities: List<String>.from(backendJob['responsibilities'] ?? []),
      benefits: List<String>.from(backendJob['benefits'] ?? []),
      applicationDeadline: backendJob['application_deadline'] as String? ?? '',
      status: backendJob['status'] as String,
      totalApplications: backendJob['total_applications'] as int? ?? 0,
      createdAt: backendJob['created_at'] as String,
    );
  }

  // Private mapper: Backend JobApplication -> Frontend JobApplication
  JobApplication _mapApplicationFromBackend(Map<String, dynamic> backendApp) {
    return JobApplication(
      id: backendApp['id'] as String,
      jobId: backendApp['job_id'] as String,
      applicantId: backendApp['applicant_id'] as String,
      applicantName: backendApp['applicant_name'] as String? ?? 'Unknown',
      applicantEmail: backendApp['applicant_email'] as String? ?? '',
      coverLetter: backendApp['cover_letter'] as String,
      resumeUrl: backendApp['resume_url'] as String? ?? '',
      experienceYears: backendApp['experience_years'] as int? ?? 0,
      relevantExperience: backendApp['relevant_experience'] as String? ?? '',
      availability: backendApp['availability'] as String? ?? '',
      expectedSalary: backendApp['expected_salary'] as String? ?? '',
      status: backendApp['status'] as String,
      appliedAt: backendApp['applied_at'] as String,
      reviewedAt: backendApp['reviewed_at'] as String? ?? '',
      notes: backendApp['notes'] as String? ?? '',
    );
  }
}
