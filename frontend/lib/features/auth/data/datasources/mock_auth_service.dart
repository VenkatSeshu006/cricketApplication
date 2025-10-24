import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';

/// Mock Authentication Service - No Backend Required!
/// This simulates authentication locally for frontend development
class MockAuthService {
  final SharedPreferences prefs;

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';
  static const String _keyUserRole = 'user_role';
  static const String _keyUserPhone = 'user_phone';

  MockAuthService(this.prefs);

  /// Mock Login - Always succeeds with valid credentials
  Future<User?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Simple validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (!email.contains('@')) {
      throw Exception('Invalid email format');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Create mock user based on email
    final mockUser = User(
      id: 'mock-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      fullName: _getNameFromEmail(email),
      phone: '+919876543210',
      role: _getRoleFromEmail(email),
      isVerified: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Save to local storage
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserId, mockUser.id);
    await prefs.setString(_keyUserEmail, mockUser.email);
    await prefs.setString(_keyUserName, mockUser.fullName);
    await prefs.setString(_keyUserRole, mockUser.role);
    if (mockUser.phone != null) {
      await prefs.setString(_keyUserPhone, mockUser.phone!);
    }

    return mockUser;
  }

  /// Mock Register - Always succeeds
  Future<User> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String role = 'player',
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Validation
    if (email.isEmpty || !email.contains('@')) {
      throw Exception('Invalid email format');
    }
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }
    if (fullName.isEmpty) {
      throw Exception('Full name is required');
    }

    final mockUser = User(
      id: 'mock-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      fullName: fullName,
      phone: phone,
      role: role,
      isVerified: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Save to local storage
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserId, mockUser.id);
    await prefs.setString(_keyUserEmail, mockUser.email);
    await prefs.setString(_keyUserName, mockUser.fullName);
    await prefs.setString(_keyUserRole, mockUser.role);
    if (mockUser.phone != null) {
      await prefs.setString(_keyUserPhone, mockUser.phone!);
    }

    return mockUser;
  }

  /// Get current logged-in user
  Future<User?> getCurrentUser() async {
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    if (!isLoggedIn) return null;

    final id = prefs.getString(_keyUserId);
    final email = prefs.getString(_keyUserEmail);
    final name = prefs.getString(_keyUserName);
    final role = prefs.getString(_keyUserRole);
    final phone = prefs.getString(_keyUserPhone);

    if (id == null || email == null || name == null || role == null) {
      return null;
    }

    return User(
      id: id,
      email: email,
      fullName: name,
      phone: phone,
      role: role,
      isVerified: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Logout
  Future<void> logout() async {
    await prefs.clear();
  }

  // Helper methods
  String _getNameFromEmail(String email) {
    final username = email.split('@')[0];
    final words = username.split(RegExp(r'[._-]'));
    return words
        .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  String _getRoleFromEmail(String email) {
    final lower = email.toLowerCase();
    if (lower.contains('owner') || lower.contains('ground')) {
      return 'ground_owner';
    } else if (lower.contains('organizer') || lower.contains('admin')) {
      return 'organizer';
    }
    return 'player';
  }
}
