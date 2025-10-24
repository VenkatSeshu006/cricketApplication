import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import 'home_dashboard_screen.dart';
import 'all_pages_screen.dart';
import '../../../live_matches/presentation/pages/live_matches_screen.dart';
import '../../../ground_booking/presentation/pages/ground_booking_screen.dart';
import '../../../shops/presentation/pages/shop_list_page.dart';
import '../../../academies/presentation/pages/academy_list_page.dart';
import '../../../organizations/presentation/pages/organization_list_page.dart';
import '../../../medical/presentation/pages/consult_physio_screen.dart';
import '../../../network/presentation/pages/your_network_screen.dart';
import '../../../network/presentation/bloc/network_bloc.dart';
import '../../../network/presentation/bloc/network_event.dart';
import '../../../network/data/repositories/mock_network_repository.dart';
import '../../../hire_staff/presentation/pages/hire_staff_screen.dart';
import '../../../tournaments/presentation/pages/upcoming_screen.dart';
import '../../../tournaments/presentation/pages/tournaments_screen.dart';
import '../../../community/presentation/pages/community_feed_screen.dart';
import '../../../chat/presentation/pages/chat_list_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  // Screen titles for AppBar
  final List<String> _screenTitles = [
    'Home',
    'Live Matches',
    'Book Ground',
    'Book Ground',
    'Cricket Shops',
    'Academies',
    'Organizations',
    'Consult Physio',
    'Your Network',
    'Hire Staff',
    'Upcoming Events',
    'Tournaments',
    'Community',
    'Chats',
  ];

  // Screen colors for AppBar
  final List<Color> _screenColors = [
    AppColors.primaryGreen,
    AppColors.primaryGreen,
    AppColors.primaryOrange,
    AppColors.primaryOrange,
    AppColors.accentBlue,
    AppColors.primaryGreen,
    AppColors.accentBlue,
    AppColors.accentBlue,
    AppColors.accentBlue,
    AppColors.accentBlue,
    AppColors.primaryOrange,
    AppColors.primaryOrange,
    AppColors.primaryGreen,
    AppColors.primaryGreen,
  ];

  void _navigateToAllPages() async {
    final int? selectedPage = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (context) => const AllPagesScreen()),
    );

    if (selectedPage != null) {
      setState(() {
        _selectedIndex = selectedPage;
      });
    }
  }

  List<Widget> get _screens => [
    HomeDashboardScreen(
      onNavigate: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
    ),
    const LiveMatchesScreen(),
    const GroundBookingScreen(),
    const GroundBookingScreen(),
    const ShopListPage(),
    const AcademyListPage(),
    const OrganizationListPage(),
    const ConsultPhysioScreen(),
    BlocProvider(
      create: (context) =>
          NetworkBloc(repository: MockNetworkRepository())
            ..add(const LoadConnections()),
      child: const YourNetworkScreen(),
    ),
    const HireStaffScreen(),
    const UpcomingScreen(),
    const TournamentsScreen(),
    const CommunityFeedScreen(),
    const ChatListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget? _buildFAB(BuildContext context) {
    // Show FAB only on specific screens
    switch (_selectedIndex) {
      // Home - No FAB (removed as per user request)
      case 1: // Live Matches - Create Match
        return FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Create Match feature coming soon!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          backgroundColor: AppColors.primaryOrange,
          child: const Icon(Icons.add),
        );
      // Ground Booking - No FAB (removed as per user request)
      case 10: // Upcoming Events - Create Event
        return FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Create Event feature coming soon!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          backgroundColor: AppColors.primaryOrange,
          child: const Icon(Icons.add),
        );
      case 11: // Tournaments - Register
        return FloatingActionButton.extended(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tournament registration coming soon!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          backgroundColor: AppColors.primaryOrange,
          icon: const Icon(Icons.emoji_events),
          label: const Text('Register'),
        );
      case 12: // Community - Create Post
        return FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Create Post feature coming soon!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          backgroundColor: AppColors.primaryGreen,
          child: const Icon(Icons.add),
        );
      case 13: // Chat - New Chat
        return FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('New Chat feature coming soon!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          backgroundColor: AppColors.primaryGreen,
          child: const Icon(Icons.chat_bubble),
        );
      default:
        return null; // No FAB for other screens
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        _screenTitles[_selectedIndex],
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
      ),
      backgroundColor: _screenColors[_selectedIndex],
      foregroundColor: Colors.white,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          tooltip: 'Navigation Menu',
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        // Search (show on specific screens)
        if (_shouldShowSearch())
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Search ${_screenTitles[_selectedIndex]} coming soon!',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        // Notifications
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          tooltip: 'Notifications',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notifications feature coming soon!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        // Profile
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              child: const Text(
                'P',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ),
      ],
    );
  }

  bool _shouldShowSearch() {
    // Show search on screens with lists/content to search
    return [1, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13].contains(_selectedIndex);
  }

  Widget _buildBottomNav() {
    // Map for main navigation: bottom nav index to screen index
    final Map<int, int> navMapping = {
      0: 0, // Home
      1: 1, // Live Matches
      2: 2, // Ground Booking
      3: 13, // Chat
    };

    // Find current bottom nav index from screen index
    int currentBottomIndex = 0;
    navMapping.forEach((bottomIndex, screenIndex) {
      if (screenIndex == _selectedIndex) {
        currentBottomIndex = bottomIndex;
      }
    });

    return NavigationBar(
      selectedIndex: currentBottomIndex,
      onDestinationSelected: (bottomIndex) {
        if (bottomIndex == 4) {
          // Special handling for "More" button
          _navigateToAllPages();
        } else {
          setState(() {
            _selectedIndex = navMapping[bottomIndex]!;
          });
        }
      },
      backgroundColor: AppColors.background,
      indicatorColor: AppColors.primaryGreen.withValues(alpha: 0.15),
      elevation: 8,
      height: 65,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.sports_cricket_outlined),
          selectedIcon: Icon(Icons.sports_cricket),
          label: 'Matches',
        ),
        NavigationDestination(
          icon: Icon(Icons.stadium_outlined),
          selectedIcon: Icon(Icons.stadium),
          label: 'Grounds',
        ),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline),
          selectedIcon: Icon(Icons.chat_bubble),
          label: 'Chat',
        ),
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'More',
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // User Header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.accentBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: const Text(
                'P',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
            accountName: const Text(
              'Player Name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            accountEmail: const Text('player@cricket.com'),
            otherAccountsPictures: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ],
          ),

          // Main Navigation Section
          _buildSectionHeader('MAIN'),
          _buildDrawerItem(
            icon: Icons.home_outlined,
            title: 'Home',
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 0);
            },
          ),
          _buildDrawerItem(
            icon: Icons.person_outline,
            title: 'My Profile',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),

          // Cricket Features Section
          _buildSectionHeader('CRICKET'),
          _buildDrawerItem(
            icon: Icons.sports_cricket,
            title: 'Live Matches',
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 1);
            },
          ),
          _buildDrawerItem(
            icon: Icons.stadium,
            title: 'Ground Booking',
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 2);
            },
          ),
          _buildDrawerItem(
            icon: Icons.emoji_events_outlined,
            title: 'Tournaments',
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 11);
            },
          ),
          _buildDrawerItem(
            icon: Icons.event_outlined,
            title: 'Upcoming Events',
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 10);
            },
          ),

          // Services Section
          _buildSectionHeader('SERVICES'),
          _buildDrawerItem(
            icon: Icons.shopping_bag_outlined,
            title: 'Cricket Shops',
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 4);
            },
          ),
          _buildDrawerItem(
            icon: Icons.school_outlined,
            title: 'Academies',
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 5);
            },
          ),
          _buildDrawerItem(
            icon: Icons.business_outlined,
            title: 'Organizations',
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 6);
            },
          ),
          _buildDrawerItem(
            icon: Icons.medical_services_outlined,
            title: 'Consult Physio',
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 7);
            },
          ),
          _buildDrawerItem(
            icon: Icons.work_outline,
            title: 'Hire Staff',
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 9);
            },
          ),

          // Social Section
          _buildSectionHeader('SOCIAL'),
          _buildDrawerItem(
            icon: Icons.people_outline,
            title: 'My Network',
            trailing: _buildBadge('24'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 8);
            },
          ),
          _buildDrawerItem(
            icon: Icons.forum_outlined,
            title: 'Community',
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 12);
            },
          ),
          _buildDrawerItem(
            icon: Icons.chat_bubble_outline,
            title: 'Messages',
            trailing: _buildBadge('5'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 13);
            },
          ),

          const Divider(height: 32),

          // Settings & More
          _buildSectionHeader('SETTINGS'),
          _buildDrawerItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            trailing: _buildBadge('12'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon!')),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          _buildDrawerItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support coming soon!')),
              );
            },
          ),

          const Divider(),

          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            color: AppColors.error,
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Widget? trailing,
    Color? color,
  }) {
    final itemColor = color ?? AppColors.textPrimary;
    return ListTile(
      leading: Icon(icon, color: itemColor, size: 24),
      title: Text(
        title,
        style: TextStyle(
          color: itemColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildBadge(String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        count,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
