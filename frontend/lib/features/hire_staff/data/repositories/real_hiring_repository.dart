import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/hiring_repository.dart';
import '../datasources/hiring_api_service.dart';

class RealHiringRepository implements HiringRepository {
  final HiringApiService _apiService;
  static const _keyToken = 'auth_token';

  RealHiringRepository(this._apiService);

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  @override
  Future<Map<String, dynamic>> listJobs({
    int page = 1,
    int limit = 10,
    String? jobType,
    String? location,
    String? status,
  }) async {
    try {
      final result = await _apiService.listJobs(
        page: page,
        limit: limit,
        jobType: jobType,
        location: location,
        status: status,
      );

      return {
        'success': true,
        'data': result['data'],
        'pagination': result['pagination'],
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load jobs: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getJobDetails(String jobId) async {
    try {
      final job = await _apiService.getJobDetails(jobId);

      return {'success': true, 'data': job};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load job details: ${e.toString()}',
      };
    }
  }

  @override
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
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      final job = await _apiService.createJob(
        token: token,
        title: title,
        description: description,
        jobType: jobType,
        location: location,
        employmentType: employmentType,
        experienceRequired: experienceRequired,
        salaryRange: salaryRange,
        requirements: requirements,
        responsibilities: responsibilities,
        benefits: benefits,
        applicationDeadline: applicationDeadline,
      );

      return {
        'success': true,
        'data': job,
        'message': 'Job posted successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to create job: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> applyForJob({
    required String jobId,
    required String coverLetter,
    required int experienceYears,
    String? resumeUrl,
    String? relevantExperience,
    String? availability,
    String? expectedSalary,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      final application = await _apiService.applyForJob(
        token: token,
        jobId: jobId,
        coverLetter: coverLetter,
        experienceYears: experienceYears,
        resumeUrl: resumeUrl,
        relevantExperience: relevantExperience,
        availability: availability,
        expectedSalary: expectedSalary,
      );

      return {
        'success': true,
        'data': application,
        'message': 'Application submitted successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to apply for job: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getJobApplications(String jobId) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      final applications = await _apiService.getJobApplications(
        token: token,
        jobId: jobId,
      );

      return {'success': true, 'data': applications};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load applications: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> updateApplicationStatus({
    required String applicationId,
    required String status,
    String? notes,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.updateApplicationStatus(
        token: token,
        applicationId: applicationId,
        status: status,
        notes: notes,
      );

      return {
        'success': true,
        'message': 'Application status updated successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update application status: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getMyJobs() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      final jobs = await _apiService.getMyJobs(token);

      return {'success': true, 'data': jobs};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load my jobs: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getMyApplications() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      final applications = await _apiService.getMyApplications(token);

      return {'success': true, 'data': applications};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to load my applications: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> updateJob({
    required String jobId,
    String? status,
    String? title,
    String? description,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return {
          'success': false,
          'error': 'Authentication required. Please login first.',
        };
      }

      await _apiService.updateJob(
        token: token,
        jobId: jobId,
        status: status,
        title: title,
        description: description,
      );

      return {'success': true, 'message': 'Job updated successfully'};
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to update job: ${e.toString()}',
      };
    }
  }
}
