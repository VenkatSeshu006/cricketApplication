import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // ========================================
  // 🔧 DEPLOYMENT CONFIGURATION
  // ========================================

  // Set this to true when deploying to cloud (AWS/GCP/Azure)
  static const bool USE_CLOUD_BACKEND = true;

  // ========================================
  // BACKEND URLS
  // ========================================

  // Local development (computer)
  static const String _localBackendUrl = 'http://localhost:8080/api/v1';

  // Android emulator (10.0.2.2 = localhost on host machine)
  static const String _androidEmulatorUrl = 'http://10.0.2.2:8080/api/v1';

  // 🌐 CLOUD BACKEND URL - UPDATE THIS AFTER DEPLOYING TO AWS/GCP/AZURE
  // Example: 'http://YOUR_EC2_IP:8080/api/v1' or 'https://your-domain.com/api/v1'
  static const String _cloudBackendUrl = 'http://13.233.117.234:8080/api/v1';

  /// Get the appropriate backend URL based on platform and environment
  static String get baseUrl {
    // If using cloud backend (for physical device testing)
    if (USE_CLOUD_BACKEND) {
      return _cloudBackendUrl;
    }

    // Local development mode
    if (kIsWeb) {
      return _localBackendUrl;
    } else {
      // For Android emulator/device (local testing)
      return _androidEmulatorUrl;
    }
  }

  // ========================================
  // HTTP HEADERS
  // ========================================

  /// Default headers for non-authenticated requests
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Headers for authenticated requests
  static Map<String, String> authHeaders(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // ========================================
  // API ENDPOINTS
  // ========================================

  static String get authRegisterUrl => '$baseUrl/auth/register';
  static String get authLoginUrl => '$baseUrl/auth/login';
  static String get authLogoutUrl => '$baseUrl/auth/logout';
  static String get authMeUrl => '$baseUrl/auth/me';

  // Health check
  static String get healthUrl => '$baseUrl/health';
}
