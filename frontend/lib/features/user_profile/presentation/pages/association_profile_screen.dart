import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AssociationProfileScreen extends StatefulWidget {
  const AssociationProfileScreen({super.key});

  @override
  State<AssociationProfileScreen> createState() =>
      _AssociationProfileScreenState();
}

class _AssociationProfileScreenState extends State<AssociationProfileScreen> {
  int _selectedSection = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Hero Banner with Association Info
          _buildHeroBanner(),

          // Navigation Pills
          SliverToBoxAdapter(child: _buildNavigationPills()),

          // Content based on selected section
          SliverToBoxAdapter(child: _buildSelectedContent()),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return SliverToBoxAdapter(
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryGreen,
              AppColors.accentBlue,
              AppColors.primaryOrange,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button and actions
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share, color: Colors.white),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.bookmark_border,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Association Logo
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.shield,
                          size: 50,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Association Name
                    const Text(
                      'Board of Control for Cricket in India',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -1,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Quick Info Row
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        _buildQuickInfoBadge(Icons.flag, 'India'),
                        _buildQuickInfoBadge(Icons.calendar_today, 'Est. 1928'),
                        _buildQuickInfoBadge(Icons.verified, 'ICC Full Member'),
                        _buildQuickInfoBadge(Icons.groups, '38 Teams'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfoBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationPills() {
    final sections = [
      {'title': 'Overview', 'icon': Icons.dashboard},
      {'title': 'Tournaments', 'icon': Icons.emoji_events},
      {'title': 'Teams', 'icon': Icons.sports_cricket},
      {'title': 'Venues', 'icon': Icons.stadium},
      {'title': 'Leadership', 'icon': Icons.business},
      {'title': 'Gallery', 'icon': Icons.photo_library},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 40),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: sections.asMap().entries.map((entry) {
            final index = entry.key;
            final section = entry.value;
            final isSelected = _selectedSection == index;

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedSection = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              AppColors.primaryGreen,
                              AppColors.accentBlue,
                            ],
                          )
                        : null,
                    color: isSelected ? null : Colors.grey[100],
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : Colors.grey[300]!,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        section['icon'] as IconData,
                        size: 20,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        section['title'] as String,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSelectedContent() {
    switch (_selectedSection) {
      case 0:
        return _buildOverviewSection();
      case 1:
        return _buildTournamentsSection();
      case 2:
        return _buildTeamsSection();
      case 3:
        return _buildVenuesSection();
      case 4:
        return _buildLeadershipSection();
      case 5:
        return _buildGallerySection();
      default:
        return _buildOverviewSection();
    }
  }

  // Overview Section with Stats and Key Info
  Widget _buildOverviewSection() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Grid
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                '25+',
                'Tournaments',
                Icons.emoji_events,
                AppColors.primaryOrange,
              ),
              _buildStatCard(
                '38',
                'Affiliated Teams',
                Icons.groups,
                AppColors.accentBlue,
              ),
              _buildStatCard(
                '10K+',
                'Players',
                Icons.people,
                AppColors.primaryGreen,
              ),
              _buildStatCard('50+', 'Venues', Icons.stadium, AppColors.success),
            ],
          ),

          const SizedBox(height: 40),

          // About Section
          const Text(
            'About BCCI',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              'The Board of Control for Cricket in India (BCCI) is the national governing body for cricket in India. '
              'The board was formed in December 1928 as a society, having its registered office in Mumbai, Maharashtra. '
              'BCCI is the richest cricket board in the world and is a Full Member of the International Cricket Council (ICC).',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Key Information Cards
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  'Founded',
                  'December 1928',
                  Icons.calendar_today,
                  AppColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildInfoCard(
                  'Headquarters',
                  'Mumbai, Maharashtra',
                  Icons.location_on,
                  AppColors.accentBlue,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildInfoCard(
                  'President',
                  'Roger Binny',
                  Icons.person,
                  AppColors.primaryOrange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Vision & Mission
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGreen.withValues(alpha: 0.1),
                        AppColors.accentBlue.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryGreen.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.visibility,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Our Vision',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'To make cricket the number one sport in India and promote the game at all levels.',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accentBlue.withValues(alpha: 0.1),
                        AppColors.primaryOrange.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.accentBlue.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.accentBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.flag,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Our Mission',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'To organize, control, and promote cricket in India with integrity and professionalism.',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 16),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // Tournaments Section
  Widget _buildTournamentsSection() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ongoing Tournaments',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 2.5,
            children: [
              _buildTournamentCard(
                'Indian Premier League 2025',
                'March - May 2025',
                'LIVE',
                AppColors.primaryOrange,
                true,
              ),
              _buildTournamentCard(
                'Ranji Trophy 2024-25',
                'October 2024 - March 2025',
                'LIVE',
                AppColors.success,
                true,
              ),
            ],
          ),

          const SizedBox(height: 40),

          const Text(
            'Upcoming Tournaments',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 2.5,
            children: [
              _buildTournamentCard(
                'Duleep Trophy',
                'September 2025',
                'Upcoming',
                AppColors.accentBlue,
                false,
              ),
              _buildTournamentCard(
                'Irani Cup',
                'October 2025',
                'Upcoming',
                AppColors.primaryGreen,
                false,
              ),
              _buildTournamentCard(
                'Syed Mushtaq Ali Trophy',
                'November 2025',
                'Upcoming',
                AppColors.primaryOrange,
                false,
              ),
              _buildTournamentCard(
                'Vijay Hazare Trophy',
                'December 2025',
                'Upcoming',
                AppColors.accentBlue,
                false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentCard(
    String name,
    String dates,
    String status,
    Color color,
    bool isLive,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLive ? color : Colors.grey[300]!,
          width: isLive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isLive
                ? color.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.emoji_events, color: color, size: 24),
              ),
              const Spacer(),
              if (isLive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                dates,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Teams Section
  Widget _buildTeamsSection() {
    final teams = [
      {'name': 'Mumbai', 'logo': '🏏', 'color': AppColors.accentBlue},
      {'name': 'Karnataka', 'logo': '🏏', 'color': AppColors.primaryGreen},
      {'name': 'Delhi', 'logo': '🏏', 'color': AppColors.primaryOrange},
      {'name': 'Tamil Nadu', 'logo': '🏏', 'color': AppColors.success},
      {'name': 'Maharashtra', 'logo': '🏏', 'color': AppColors.accentBlue},
      {'name': 'Bengal', 'logo': '🏏', 'color': AppColors.primaryGreen},
      {'name': 'Gujarat', 'logo': '🏏', 'color': AppColors.primaryOrange},
      {'name': 'Punjab', 'logo': '🏏', 'color': AppColors.success},
      {'name': 'Rajasthan', 'logo': '🏏', 'color': AppColors.accentBlue},
      {'name': 'Uttar Pradesh', 'logo': '🏏', 'color': AppColors.primaryGreen},
      {'name': 'Andhra', 'logo': '🏏', 'color': AppColors.primaryOrange},
      {'name': 'Hyderabad', 'logo': '🏏', 'color': AppColors.success},
    ];

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Affiliated State Teams',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '38 state cricket associations affiliated with BCCI',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.2,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              return _buildTeamCard(
                team['name'] as String,
                team['logo'] as String,
                team['color'] as Color,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(String name, String logo, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.8), color],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(logo, style: const TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Venues Section
  Widget _buildVenuesSection() {
    final venues = [
      {
        'name': 'Narendra Modi Stadium',
        'city': 'Ahmedabad',
        'capacity': '132,000',
        'icon': Icons.stadium,
        'color': AppColors.primaryOrange,
      },
      {
        'name': 'Eden Gardens',
        'city': 'Kolkata',
        'capacity': '68,000',
        'icon': Icons.stadium,
        'color': AppColors.primaryGreen,
      },
      {
        'name': 'Wankhede Stadium',
        'city': 'Mumbai',
        'capacity': '33,108',
        'icon': Icons.stadium,
        'color': AppColors.accentBlue,
      },
      {
        'name': 'M. Chinnaswamy Stadium',
        'city': 'Bangalore',
        'capacity': '40,000',
        'icon': Icons.stadium,
        'color': AppColors.success,
      },
      {
        'name': 'M. A. Chidambaram Stadium',
        'city': 'Chennai',
        'capacity': '50,000',
        'icon': Icons.stadium,
        'color': AppColors.primaryOrange,
      },
      {
        'name': 'Rajiv Gandhi International',
        'city': 'Hyderabad',
        'capacity': '55,000',
        'icon': Icons.stadium,
        'color': AppColors.accentBlue,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Major Cricket Venues',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'World-class cricket stadiums across India',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 2.2,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: venues.length,
            itemBuilder: (context, index) {
              final venue = venues[index];
              return _buildVenueCard(
                venue['name'] as String,
                venue['city'] as String,
                venue['capacity'] as String,
                venue['color'] as Color,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVenueCard(
    String name,
    String city,
    String capacity,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.8), color],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.stadium, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      city,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.people, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Capacity: $capacity',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Leadership Section
  Widget _buildLeadershipSection() {
    final officials = [
      {
        'name': 'Roger Binny',
        'position': 'President',
        'icon': Icons.person,
        'color': AppColors.primaryOrange,
      },
      {
        'name': 'Jay Shah',
        'position': 'Secretary',
        'icon': Icons.account_circle,
        'color': AppColors.accentBlue,
      },
      {
        'name': 'Ashish Shelar',
        'position': 'Treasurer',
        'icon': Icons.account_balance,
        'color': AppColors.primaryGreen,
      },
      {
        'name': 'Devajit Saikia',
        'position': 'Joint Secretary',
        'icon': Icons.people,
        'color': AppColors.success,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Leadership Team',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Office bearers of the Board of Control for Cricket in India',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 2.5,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: officials.length,
            itemBuilder: (context, index) {
              final official = officials[index];
              return _buildOfficialCard(
                official['name'] as String,
                official['position'] as String,
                official['icon'] as IconData,
                official['color'] as Color,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOfficialCard(
    String name,
    String position,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.8), color],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 36),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  position,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Gallery Section
  Widget _buildGallerySection() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Photo Gallery',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Memorable moments from BCCI events',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.2,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 12,
            itemBuilder: (context, index) {
              return _buildPhotoCard(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(int index) {
    final colors = [
      AppColors.primaryGreen,
      AppColors.accentBlue,
      AppColors.primaryOrange,
      AppColors.success,
    ];
    final color = colors[index % colors.length];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Icon(
          Icons.photo_library,
          size: 40,
          color: color.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
