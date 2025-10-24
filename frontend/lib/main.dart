import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/di/auth_injection.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/register_screen.dart';
import 'features/dashboard/presentation/pages/main_shell.dart';
import 'features/user_profile/presentation/pages/player_profile_screen.dart';
import 'features/user_profile/presentation/pages/coach_profile_screen.dart';
import 'features/user_profile/presentation/pages/commentator_profile_screen.dart';
import 'features/user_profile/presentation/pages/umpire_profile_screen.dart';
import 'features/user_profile/presentation/pages/doctor_profile_screen.dart';
import 'features/user_profile/presentation/pages/streamer_profile_screen.dart';
import 'features/user_profile/presentation/pages/organiser_profile_screen.dart';
import 'features/user_profile/presentation/pages/association_profile_screen.dart';
import 'features/user_profile/presentation/pages/club_profile_screen.dart';
import 'features/tournaments/presentation/pages/tournament_detail_screen.dart';
import 'features/tournaments/presentation/pages/match_detail_screen.dart';
import 'features/shops/presentation/pages/shop_list_page.dart';
import 'features/academies/presentation/pages/academy_list_page.dart';
import 'features/organizations/presentation/pages/organization_list_page.dart';
import 'features/tournaments/presentation/pages/create/create_tournament_page.dart';
import 'features/live_matches/presentation/pages/create/create_match_page.dart';
import 'features/streaming/presentation/pages/setup_streaming_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await DependencyInjection.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DependencyInjection.authBloc..add(const CheckAuthStatus()),
      child: MaterialApp(
        title: 'CricNet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        // Web: Dashboard, Mobile: Login
        initialRoute: kIsWeb ? '/dashboard' : '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const MainShell(),
          '/profile': (context) => const PlayerProfileScreen(),
          '/profile/coach': (context) => const CoachProfileScreen(),
          '/profile/commentator': (context) => const CommentatorProfileScreen(),
          '/profile/umpire': (context) => const UmpireProfileScreen(),
          '/profile/doctor': (context) => const DoctorProfileScreen(),
          '/profile/streamer': (context) => const StreamerProfileScreen(),
          '/profile/organiser': (context) => const OrganiserProfileScreen(),
          '/profile/association': (context) => const AssociationProfileScreen(),
          '/profile/club': (context) => const ClubProfileScreen(),
          '/tournament/detail': (context) => const TournamentDetailScreen(),
          '/match/detail': (context) => const MatchDetailScreen(),
          '/shops': (context) => const ShopListPage(),
          '/academies': (context) => const AcademyListPage(),
          '/organizations': (context) => const OrganizationListPage(),
          '/tournament/create': (context) => const CreateTournamentPage(),
          '/match/create': (context) => const CreateMatchPage(),
          '/streaming/setup': (context) => const SetupStreamingPage(),
        },
      ),
    );
  }
}
