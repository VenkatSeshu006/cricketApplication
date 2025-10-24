import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomeDashboardScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const HomeDashboardScreen({super.key, required this.onNavigate});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _selectedMatchTab = 0; // 0 = Top Matches, 1 = Live

  Future<void> _handleRefresh() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dashboard refreshed!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppColors.primaryGreen,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(context),

            const SizedBox(height: 24),

            // Stats Cards
            _buildStatsCards(context),

            const SizedBox(height: 24),

            // Live Matches Section
            _buildLiveMatchesSection(context),

            const SizedBox(height: 24),

            // Quick Actions Grid
            _buildQuickActionsSection(context),

            const SizedBox(height: 24),

            // Your Network Preview
            _buildYourNetworkSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting = hour < 12
        ? 'Good Morning'
        : hour < 18
        ? 'Good Afternoon'
        : 'Good Evening';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting,',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          '${_getFirstName()}!',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Explore live matches, book grounds, and connect with your network',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  String _getFirstName() {
    return 'Player'; // Replace with actual user name
  }

  Widget _buildStatsCards(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.sports_cricket,
                title: 'Matches Played',
                value: '24',
                trend: '+3 this month',
                trendPositive: true,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.stadium,
                title: 'Grounds Booked',
                value: '8',
                trend: '+2 this month',
                trendPositive: true,
                color: AppColors.accentBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.people,
                title: 'Network',
                value: '156',
                trend: '+12 this month',
                trendPositive: true,
                color: AppColors.primaryOrange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.emoji_events,
                title: 'Tournaments',
                value: '5',
                trend: 'Upcoming',
                trendPositive: false,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String trend,
    required bool trendPositive,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Icon(
                trendPositive ? Icons.trending_up : Icons.info_outline,
                color: trendPositive
                    ? AppColors.success
                    : AppColors.textTertiary,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            trend,
            style: TextStyle(
              fontSize: 10,
              color: trendPositive ? AppColors.success : AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMatchesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab Bar Header
        Row(
          children: [
            InkWell(
              onTap: () => setState(() => _selectedMatchTab = 0),
              child: _buildTabButton('Top Matches', _selectedMatchTab == 0),
            ),
            const SizedBox(width: 24),
            InkWell(
              onTap: () => setState(() => _selectedMatchTab = 1),
              child: _buildTabButton('Live (1)', _selectedMatchTab == 1),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.calendar_today, size: 16),
              label: const Text('Cricket Schedule'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accentBlue,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Horizontal Scrollable Match Cards
        SizedBox(
          height: 200, // Increased height to prevent overflow
          child: _selectedMatchTab == 0
              ? _buildTopMatchesList()
              : _buildLiveMatchesList(),
        ),
      ],
    );
  }

  Widget _buildTopMatchesList() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        _buildMatchCard(
          date: '23 Oct',
          matchTitle: 'IND vs AUS 2025',
          matchType: '2nd ODI',
          venue: 'Adelaide Oval, Adelaide',
          team1: 'Australia',
          team2: 'India',
          team1Flag: '🇦🇺',
          team2Flag: '🇮🇳',
          team1Score: null,
          team2Score: null,
          result: null,
          isUpcoming: true,
        ),
        const SizedBox(width: 16),
        _buildMatchCard(
          date: null,
          matchTitle: 'IND vs AUS 2025',
          matchType: '1st ODI',
          venue: 'Perth Stadium',
          team1: 'IND',
          team2: 'AUS',
          team1Flag: '🇮🇳',
          team2Flag: '🇦🇺',
          team1Score: '136-9',
          team1Overs: '26.0',
          team2Score: '131-3',
          team2Overs: '21.1',
          result: 'AUS won by 7 wickets',
          resultColor: AppColors.success,
          isUpcoming: false,
        ),
        const SizedBox(width: 16),
        _buildMatchCard(
          date: null,
          matchTitle: 'Women\'s WC 2025',
          matchType: '21st ODI',
          venue: 'Dr. DY Patil Sports Academy, Mumbai',
          team1: 'SL-W',
          team2: 'BAN-W',
          team1Flag: '🇱🇰',
          team2Flag: '🇧🇩',
          team1Score: '202',
          team1Overs: '48.4',
          team2Score: '195-9',
          team2Overs: '50.0',
          result: 'SL-W won by 7 runs',
          resultColor: AppColors.success,
          isUpcoming: false,
        ),
        const SizedBox(width: 16),
        _buildMatchCard(
          date: null,
          matchTitle: 'Women\'s WC 2025',
          matchType: '22nd ODI',
          venue: 'Mumbai',
          team1: 'SA-W',
          team2: 'PAK-W',
          team1Flag: '🇿🇦',
          team2Flag: '🇵🇰',
          team1Score: '215',
          team1Overs: '49.2',
          team2Score: '178-8',
          team2Overs: '50.0',
          result: 'SA-W won by 37 runs',
          resultColor: AppColors.success,
          isUpcoming: false,
        ),
      ],
    );
  }

  Widget _buildLiveMatchesList() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        _buildMatchCard(
          date: null,
          matchTitle: 'PAK vs NZ 2025',
          matchType: 'T20I',
          venue: 'National Stadium, Karachi',
          team1: 'PAK',
          team2: 'NZ',
          team1Flag: '🇵🇰',
          team2Flag: '🇳🇿',
          team1Score: '167-5',
          team1Overs: '18.3',
          team2Score: '142-8',
          team2Overs: '20.0',
          result: '🔴 LIVE - PAK need 6 runs',
          resultColor: AppColors.error,
          isUpcoming: false,
          isLive: true,
        ),
      ],
    );
  }

  Widget _buildTabButton(String text, bool isActive) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isActive ? AppColors.textPrimary : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildMatchCard({
    String? date,
    required String matchTitle,
    required String matchType,
    required String venue,
    required String team1,
    required String team2,
    required String team1Flag,
    required String team2Flag,
    String? team1Score,
    String? team1Overs,
    String? team2Score,
    String? team2Overs,
    String? result,
    Color? resultColor,
    required bool isUpcoming,
    bool isLive = false,
  }) {
    return Container(
      width: 380,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with Date and Title
            Row(
              children: [
                if (date != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    matchTitle,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Match Type and Venue
            Text(
              '$matchType , $venue',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 16),

            // Teams and Scores
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Team 1
                Row(
                  children: [
                    Text(team1Flag, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        team1,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (team1Score != null) ...[
                      Text(
                        team1Score,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (team1Overs != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          team1Overs,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),

                const SizedBox(height: 12),

                // Team 2
                Row(
                  children: [
                    Text(team2Flag, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        team2,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (team2Score != null) ...[
                      Text(
                        team2Score,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (team2Overs != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          team2Overs,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Result or Status
            if (result != null)
              Text(
                result,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: resultColor ?? AppColors.success,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    final actions = [
      _QuickAction(
        title: 'Book Your Ground',
        icon: Icons.stadium,
        color: AppColors.primaryOrange,
        onTap: () {
          widget.onNavigate(3); // Index 3 = Ground Booking
        },
      ),
      _QuickAction(
        title: 'Consult a Physio',
        icon: Icons.medical_services,
        color: AppColors.accentBlue,
        onTap: () {
          widget.onNavigate(4); // Index 4 = Consult Physio
        },
      ),
      _QuickAction(
        title: 'Hire Staff',
        icon: Icons.work,
        color: AppColors.success,
        onTap: () {
          widget.onNavigate(6); // Index 6 = Hire Staff
        },
      ),
      _QuickAction(
        title: 'View Tournaments',
        icon: Icons.emoji_events,
        color: AppColors.warning,
        onTap: () {
          widget.onNavigate(8); // Index 8 = Tournaments
        },
      ),
      _QuickAction(
        title: 'Community',
        icon: Icons.forum,
        color: AppColors.primaryGreen,
        onTap: () {
          widget.onNavigate(9); // Index 9 = Community
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final action = actions[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: action.onTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: action.color.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              action.icon,
                              color: action.color,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Flexible(
                            child: Text(
                              action.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildYourNetworkSection(BuildContext context) {
    final mockContacts = [
      _NetworkContact(
        name: 'Dr. Priya Sharma',
        role: 'Physio - Muscular Specialist',
        rate: '\$33 / Hour',
      ),
      _NetworkContact(
        name: 'Coach John Doe',
        role: 'Cricket Coach',
        rate: '\$45 / Hour',
      ),
      _NetworkContact(
        name: 'Alex Thompson',
        role: 'Ground Manager',
        rate: '\$28 / Hour',
      ),
      _NetworkContact(
        name: 'Sarah Williams',
        role: 'Team Analyst',
        rate: '\$35 / Hour',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Network',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to your network
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 1200
                ? 4
                : constraints.maxWidth > 800
                ? 3
                : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: mockContacts.length,
              itemBuilder: (context, index) {
                final contact = mockContacts[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: AppColors.primaryOrange.withValues(
                          alpha: 0.2,
                        ),
                        child: Text(
                          contact.name[0],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        contact.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contact.role,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        contact.rate,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                          child: const Text('Book'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _QuickAction {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _QuickAction({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _NetworkContact {
  final String name;
  final String role;
  final String rate;

  _NetworkContact({required this.name, required this.role, required this.rate});
}
