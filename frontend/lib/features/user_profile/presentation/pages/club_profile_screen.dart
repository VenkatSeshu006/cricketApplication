import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ClubProfileScreen extends StatefulWidget {
  const ClubProfileScreen({super.key});

  @override
  State<ClubProfileScreen> createState() => _ClubProfileScreenState();
}

class _ClubProfileScreenState extends State<ClubProfileScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Animated Hero Header
          _buildHeroHeader(),

          // Tab Navigation
          SliverToBoxAdapter(child: _buildTabNavigation()),

          // Dynamic Content
          SliverToBoxAdapter(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildHeroHeader() {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          // Background Image/Gradient
          Container(
            height: 450,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accentBlue,
                  AppColors.primaryGreen,
                  AppColors.accentBlue.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Pattern Overlay
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.1,
                    child: Image.asset(
                      'assets/cricket_pattern.png',
                      repeat: ImageRepeat.repeat,
                      errorBuilder: (context, error, stackTrace) => Container(),
                    ),
                  ),
                ),
                // Decorative Circles
                Positioned(
                  top: -100,
                  right: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: -50,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Actions
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
                              alpha: 0.15,
                            ),
                            padding: const EdgeInsets.all(12),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share, color: Colors.white),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Club Identity
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Club Badge
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              '🏏',
                              style: const TextStyle(fontSize: 50),
                            ),
                          ),
                        ),

                        const SizedBox(width: 32),

                        // Club Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Established Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.4),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Est. 1995',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Club Name
                              const Text(
                                'Mumbai Cricket Club',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -1.5,
                                  height: 1.1,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Location & Type
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryOrange,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Mumbai, India',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Premier League',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.verified,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Verified',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Action Buttons
                              Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.person_add,
                                      size: 18,
                                    ),
                                    label: const Text('Join Club'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppColors.accentBlue,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.email, size: 18),
                                    label: const Text('Contact'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 32),

                        // Quick Stats
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildQuickStat('250+', 'Members'),
                            const SizedBox(height: 20),
                            _buildQuickStat('45', 'Trophies'),
                            const SizedBox(height: 20),
                            _buildQuickStat('8', 'Teams'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigation() {
    final tabs = [
      {'title': 'Overview', 'icon': Icons.dashboard},
      {'title': 'Teams', 'icon': Icons.groups},
      {'title': 'Members', 'icon': Icons.people},
      {'title': 'Achievements', 'icon': Icons.emoji_events},
      {'title': 'Facilities', 'icon': Icons.stadium},
      {'title': 'Events', 'icon': Icons.event},
      {'title': 'Gallery', 'icon': Icons.photo_library},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = _selectedTab == index;

            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedTab = index;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accentBlue
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accentBlue
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        tab['icon'] as IconData,
                        size: 20,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tab['title'] as String,
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

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildTeamsTab();
      case 2:
        return _buildMembersTab();
      case 3:
        return _buildAchievementsTab();
      case 4:
        return _buildFacilitiesTab();
      case 5:
        return _buildEventsTab();
      case 6:
        return _buildGalleryTab();
      default:
        return _buildOverviewTab();
    }
  }

  // Overview Tab
  Widget _buildOverviewTab() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Performance Stats
          Row(
            children: [
              Expanded(
                child: _buildPerformanceCard(
                  'Win Rate',
                  '78.5%',
                  Icons.trending_up,
                  AppColors.success,
                  '+5.2% from last season',
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildPerformanceCard(
                  'Matches Played',
                  '156',
                  Icons.sports_cricket,
                  AppColors.accentBlue,
                  'This season',
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildPerformanceCard(
                  'Championships',
                  '12',
                  Icons.emoji_events,
                  AppColors.primaryOrange,
                  'Total wins',
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildPerformanceCard(
                  'Active Players',
                  '180',
                  Icons.people,
                  AppColors.primaryGreen,
                  'Registered members',
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // About Section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About the Club',
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
                        'Mumbai Cricket Club is one of the most prestigious cricket clubs in India, '
                        'established in 1995. We pride ourselves on developing talented cricketers '
                        'and providing world-class facilities. Our club has produced numerous '
                        'international players and has won 12 major championships. We offer '
                        'professional coaching, state-of-the-art training facilities, and a vibrant '
                        'community of cricket enthusiasts.',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.7,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Core Values
                    const Text(
                      'Our Core Values',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildValueCard(
                            Icons.sports,
                            'Excellence',
                            'Striving for the highest standards',
                            AppColors.primaryOrange,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildValueCard(
                            Icons.handshake,
                            'Integrity',
                            'Fair play and sportsmanship',
                            AppColors.accentBlue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildValueCard(
                            Icons.group,
                            'Community',
                            'Building lasting relationships',
                            AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 32),

              // Sidebar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Information',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildInfoItem(Icons.calendar_today, 'Founded', '1995'),
                    _buildInfoItem(
                      Icons.location_on,
                      'Location',
                      'Mumbai, Maharashtra',
                    ),
                    _buildInfoItem(
                      Icons.sports_cricket,
                      'Home Ground',
                      'Wankhede Stadium',
                    ),
                    _buildInfoItem(Icons.person, 'President', 'Rajesh Kumar'),
                    _buildInfoItem(Icons.phone, 'Contact', '+91 98765 43210'),
                    _buildInfoItem(Icons.email, 'Email', 'info@mumbaicc.com'),
                    _buildInfoItem(
                      Icons.language,
                      'Website',
                      'www.mumbaicc.com',
                    ),

                    const SizedBox(height: 32),

                    // Social Media
                    const Text(
                      'Connect With Us',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        _buildSocialButton(
                          Icons.facebook,
                          AppColors.accentBlue,
                        ),
                        const SizedBox(width: 12),
                        _buildSocialButton(
                          Icons.alternate_email,
                          AppColors.primaryOrange,
                        ),
                        const SizedBox(width: 12),
                        _buildSocialButton(
                          Icons.video_library,
                          AppColors.primaryOrange,
                        ),
                        const SizedBox(width: 12),
                        _buildSocialButton(
                          Icons.camera_alt,
                          AppColors.primaryGreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(
    String label,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(28),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: AppColors.accentBlue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: color, size: 22),
        padding: EdgeInsets.zero,
      ),
    );
  }

  // Teams Tab
  Widget _buildTeamsTab() {
    final teams = [
      {
        'name': 'Senior Men',
        'players': 25,
        'captain': 'Rohit Sharma',
        'color': AppColors.accentBlue,
      },
      {
        'name': 'Senior Women',
        'players': 22,
        'captain': 'Smriti Mandhana',
        'color': AppColors.primaryOrange,
      },
      {
        'name': 'Under-19',
        'players': 30,
        'captain': 'Arjun Patel',
        'color': AppColors.primaryGreen,
      },
      {
        'name': 'Under-16',
        'players': 28,
        'captain': 'Ravi Kumar',
        'color': AppColors.success,
      },
      {
        'name': 'Under-14',
        'players': 32,
        'captain': 'Ankit Singh',
        'color': AppColors.accentBlue,
      },
      {
        'name': 'Veterans',
        'players': 18,
        'captain': 'Sachin Joshi',
        'color': AppColors.primaryOrange,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Teams',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Competitive teams across all age groups',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1.3,
            ),
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              return _buildTeamCard(
                team['name'] as String,
                team['players'] as int,
                team['captain'] as String,
                team['color'] as Color,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(String name, int players, String captain, Color color) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.groups, color: Colors.white, size: 28),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$players Players',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                'Captain: ',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              Text(
                captain,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'View Details',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Members Tab
  Widget _buildMembersTab() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Club Members',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '250+ active members',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          // Member Categories
          Row(
            children: [
              Expanded(
                child: _buildMemberCategoryCard(
                  'Players',
                  180,
                  Icons.sports_cricket,
                  AppColors.accentBlue,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildMemberCategoryCard(
                  'Coaches',
                  15,
                  Icons.school,
                  AppColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildMemberCategoryCard(
                  'Support Staff',
                  25,
                  Icons.people,
                  AppColors.primaryOrange,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildMemberCategoryCard(
                  'Management',
                  12,
                  Icons.business,
                  AppColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Featured Members
          const Text(
            'Featured Members',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 0.85,
            children: [
              _buildMemberCard(
                'Rohit Sharma',
                'Captain',
                'Senior Men',
                AppColors.accentBlue,
              ),
              _buildMemberCard(
                'Smriti Mandhana',
                'Captain',
                'Senior Women',
                AppColors.primaryOrange,
              ),
              _buildMemberCard(
                'Rahul Dravid',
                'Head Coach',
                'Senior Teams',
                AppColors.primaryGreen,
              ),
              _buildMemberCard(
                'Anil Kumble',
                'Bowling Coach',
                'Senior Teams',
                AppColors.success,
              ),
              _buildMemberCard(
                'Suresh Raina',
                'Batting Coach',
                'Under-19',
                AppColors.accentBlue,
              ),
              _buildMemberCard(
                'Gautam Gambhir',
                'Mentor',
                'All Teams',
                AppColors.primaryOrange,
              ),
              _buildMemberCard(
                'Virat Kohli',
                'Vice Captain',
                'Senior Men',
                AppColors.primaryGreen,
              ),
              _buildMemberCard(
                'Jasprit Bumrah',
                'Fast Bowler',
                'Senior Men',
                AppColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCategoryCard(
    String category,
    int count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(String name, String role, String team, Color color) {
    return Container(
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
      child: Column(
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: const Center(
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  team,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Achievements Tab
  Widget _buildAchievementsTab() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Achievements & Trophies',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our journey of excellence',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.5,
            children: [
              _buildAchievementCard(
                'State Champions',
                '2023',
                AppColors.primaryOrange,
              ),
              _buildAchievementCard(
                'National League Winners',
                '2022',
                AppColors.accentBlue,
              ),
              _buildAchievementCard('T20 Champions', '2023', AppColors.success),
              _buildAchievementCard(
                'Best Club Award',
                '2021',
                AppColors.primaryGreen,
              ),
              _buildAchievementCard(
                'Under-19 Champions',
                '2023',
                AppColors.primaryOrange,
              ),
              _buildAchievementCard(
                'Women\'s League Winners',
                '2022',
                AppColors.accentBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(String title, String year, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
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
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              year,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Facilities Tab
  Widget _buildFacilitiesTab() {
    final facilities = [
      {
        'name': 'Indoor Training Center',
        'description': 'State-of-the-art indoor facility with bowling machines',
        'icon': Icons.home,
        'color': AppColors.accentBlue,
      },
      {
        'name': 'Practice Nets',
        'description': '12 professional cricket nets with quality pitches',
        'icon': Icons.grid_4x4,
        'color': AppColors.primaryGreen,
      },
      {
        'name': 'Fitness Center',
        'description': 'Modern gym with professional trainers',
        'icon': Icons.fitness_center,
        'color': AppColors.primaryOrange,
      },
      {
        'name': 'Medical Room',
        'description': 'On-site physiotherapy and medical care',
        'icon': Icons.local_hospital,
        'color': AppColors.success,
      },
      {
        'name': 'Players Lounge',
        'description': 'Comfortable lounge for team meetings',
        'icon': Icons.weekend,
        'color': AppColors.accentBlue,
      },
      {
        'name': 'Video Analysis Room',
        'description': 'Advanced video analysis equipment',
        'icon': Icons.video_library,
        'color': AppColors.primaryGreen,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'World-Class Facilities',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Everything you need to excel',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 2,
            ),
            itemCount: facilities.length,
            itemBuilder: (context, index) {
              final facility = facilities[index];
              return _buildFacilityCard(
                facility['name'] as String,
                facility['description'] as String,
                facility['icon'] as IconData,
                facility['color'] as Color,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityCard(
    String name,
    String description,
    IconData icon,
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
                colors: [color, color.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 32),
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
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Events Tab
  Widget _buildEventsTab() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join us at our upcoming events',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          Column(
            children: [
              _buildEventCard(
                'Annual General Meeting',
                'December 15, 2025',
                'Wankhede Stadium',
                '10:00 AM',
                AppColors.accentBlue,
              ),
              const SizedBox(height: 16),
              _buildEventCard(
                'Youth Cricket Camp',
                'December 20-25, 2025',
                'Indoor Training Center',
                '6:00 AM - 12:00 PM',
                AppColors.primaryGreen,
              ),
              const SizedBox(height: 16),
              _buildEventCard(
                'New Year Friendly Match',
                'January 1, 2026',
                'Wankhede Stadium',
                '2:00 PM',
                AppColors.primaryOrange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(
    String title,
    String date,
    String venue,
    String time,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(28),
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
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.event, color: Colors.white, size: 36),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      venue,
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
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Register',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Gallery Tab
  Widget _buildGalleryTab() {
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
            'Memorable moments from our club',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.2,
            ),
            itemCount: 16,
            itemBuilder: (context, index) {
              return _buildGalleryItem(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryItem(int index) {
    final colors = [
      AppColors.accentBlue,
      AppColors.primaryGreen,
      AppColors.primaryOrange,
      AppColors.success,
    ];
    final color = colors[index % colors.length];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Icon(
          Icons.photo_library,
          size: 48,
          color: color.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
