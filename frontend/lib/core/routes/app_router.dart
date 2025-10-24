import 'package:flutter/material.dart';

class AppRouter {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard =
      '/dashboard'; // Changed from home to dashboard
  static const String home = '/dashboard'; // Alias for backward compatibility
  static const String liveMatches = '/live-matches';
  static const String groundBooking = '/ground-booking';
  static const String consultPhysio = '/consult-physio';
  static const String yourNetwork = '/your-network';
  static const String hireStaff = '/hire-staff';
  static const String upcoming = '/upcoming';
  static const String tournaments = '/tournaments';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // We'll implement this later when we add all screens
    return null;
  }
}
