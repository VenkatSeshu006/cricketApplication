import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({super.key});

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Header
            SliverToBoxAdapter(child: _buildCleanHeader()),
            // Tab Bar
            SliverToBoxAdapter(child: _buildCleanTabBar()),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildProfileTab(),
            _buildAchievementsTab(),
            _buildMatchesTab(),
            _buildTeamsTab(),
            _buildConnectionsTab(),
            _buildPicturesTab(),
          ],
        ),
      ),
    );
  }

  // Clean Minimalist Header
  Widget _buildCleanHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Back button and actions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 24),
                  onPressed: () => Navigator.pop(context),
                  color: AppColors.textPrimary,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share_outlined, size: 24),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Share profile coming soon!'),
                      ),
                    );
                  },
                  color: AppColors.textPrimary,
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 24),
                  onPressed: () {
                    _showProfileOptions(context);
                  },
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
          // Profile Picture and Basic Info
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Large Profile Picture with enhanced gradient
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGreen,
                        AppColors.accentBlue,
                        AppColors.primaryOrange.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withValues(alpha: 0.3),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'RS',
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 32),

                // Name and Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      const Text(
                        'Rohit Sharma',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Info Row
                      Row(
                        children: [
                          _buildInfoChip('🇮🇳 India', AppColors.primaryGreen),
                          const SizedBox(width: 12),
                          _buildInfoChip('38 years', AppColors.textSecondary),
                          const SizedBox(width: 12),
                          _buildInfoChip(
                            'Right-Handed Batter',
                            AppColors.accentBlue,
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Ranking Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '#3 ODI Batter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Share'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person_add, size: 18),
                      label: const Text('Follow'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Stats Grid - Mobile optimized (2x2)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Matches',
                      '265',
                      Icons.sports_cricket,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard('Runs', '10,866', Icons.numbers),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Average',
                      '48.96',
                      Icons.trending_up,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard('Strike Rate', '90.23', Icons.speed),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showProfileOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.primaryGreen),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit profile coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: AppColors.textSecondary,
              ),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.qr_code,
                color: AppColors.textSecondary,
              ),
              title: const Text('My QR Code'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('QR Code coming soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryGreen, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  // Clean Tab Bar
  Widget _buildCleanTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppColors.primaryGreen,
        indicatorWeight: 4,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.primaryGreen, width: 4),
          ),
        ),
        labelColor: AppColors.primaryGreen,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        indicatorSize: TabBarIndicatorSize.label,
        tabs: const [
          Tab(text: 'PROFILE'),
          Tab(text: 'ACHIEVEMENTS'),
          Tab(text: 'MATCHES'),
          Tab(text: 'TEAMS'),
          Tab(text: 'CONNECTIONS'),
          Tab(text: 'GALLERY'),
        ],
      ),
    );
  }

  // TAB 1: PROFILE
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCleanSection(
                      title: 'About',
                      child: Text(
                        'One of the world\'s best batters and the most successful captain in the Indian Premier League (IPL), Rohit Sharma is a global cricketing star. Known for his elegant stroke play and ability to play long innings, Rohit has been a key player for India across all formats.',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.7,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildCleanSection(
                      title: 'Professional Details',
                      child: Column(
                        children: [
                          _buildDetailRow2('Role', 'Opening Batter'),
                          _buildDetailRow2('Batting Style', 'Right-Handed'),
                          _buildDetailRow2('Batting Position', 'Opener'),
                          _buildDetailRow2(
                            'Bowling Style',
                            'Right-Arm Offbreak',
                          ),
                          _buildDetailRow2('Bowling Type', 'Spinner'),
                          _buildDetailRow2('Signature Shot', 'Pull Shot'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildCleanSection(
                      title: 'Teams Played For',
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          'India',
                          'Mumbai Indians',
                          'Mumbai',
                          'India A',
                          'India U19',
                          'Deccan Chargers',
                          'India Green',
                          'India Blue',
                          'Indians',
                          'Board Presidents XI',
                        ].map((team) => _buildTeamTag(team)).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 32),

              // Right Column
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCleanSection(
                      title: 'Personal Information',
                      child: Column(
                        children: [
                          _buildDetailRow2(
                            'Full Name',
                            'Rohit Gurunath Sharma',
                          ),
                          _buildDetailRow2('Gender', 'Male'),
                          _buildDetailRow2('Date of Birth', '30 April 1987'),
                          _buildDetailRow2('Age', '38 years'),
                          _buildDetailRow2(
                            'Birth Place',
                            'Nagpur, Maharashtra',
                          ),
                          _buildDetailRow2('Height', '5 ft 9 in (1.73 m)'),
                          _buildDetailRow2('Nationality', 'Indian'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildCleanSection(
                      title: 'Social Media',
                      child: Column(
                        children: [
                          _buildSocialLink2(
                            Icons.camera_alt,
                            'Instagram',
                            '@rohitsharma45',
                            AppColors.primaryOrange,
                          ),
                          const SizedBox(height: 16),
                          _buildSocialLink2(
                            Icons.alternate_email,
                            'Twitter',
                            '@ImRo45',
                            AppColors.accentBlue,
                          ),
                        ],
                      ),
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

  // TAB 2: ACHIEVEMENTS
  Widget _buildAchievementsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Major Awards',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.1,
            children: [
              _buildAwardCard(
                'ICC ODI Player\nof the Year',
                '2019',
                Icons.emoji_events,
              ),
              _buildAwardCard(
                'Wisden Leading\nCricketer',
                '2020',
                Icons.workspace_premium,
              ),
              _buildAwardCard('Arjuna\nAward', '2015', Icons.military_tech),
              _buildAwardCard('Rajiv Gandhi\nKhel Ratna', '2020', Icons.stars),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'Career Milestones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildMilestonesList(),
        ],
      ),
    );
  }

  // TAB 3: MATCHES
  Widget _buildMatchesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Career Statistics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildStatsTable(),
          const SizedBox(height: 40),
          const Text(
            'Recent Performances',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildRecentMatches(),
        ],
      ),
    );
  }

  // TAB 4: TEAMS
  Widget _buildTeamsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 1.3,
        children: [
          _buildTeamCard2(
            'India',
            'National Team',
            '2007 - Present',
            Icons.flag,
            AppColors.primaryOrange,
          ),
          _buildTeamCard2(
            'Mumbai Indians',
            'IPL',
            '2011 - Present',
            Icons.sports,
            AppColors.accentBlue,
          ),
          _buildTeamCard2(
            'Mumbai',
            'Domestic',
            '2006 - Present',
            Icons.location_city,
            AppColors.primaryGreen,
          ),
          _buildTeamCard2(
            'India A',
            'National',
            '2010 - 2015',
            Icons.sports_cricket,
            AppColors.success,
          ),
          _buildTeamCard2(
            'Deccan Chargers',
            'IPL',
            '2008 - 2010',
            Icons.groups,
            AppColors.warning,
          ),
          _buildTeamCard2(
            'India U19',
            'Youth',
            '2004 - 2006',
            Icons.school,
            AppColors.info,
          ),
        ],
      ),
    );
  }

  // TAB 5: CONNECTIONS
  Widget _buildConnectionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cricket Network',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add, size: 18),
                label: const Text('Add Connection'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.8,
            children: [
              _buildConnectionCard2('Virat Kohli', 'Batter', '🇮🇳'),
              _buildConnectionCard2('Jasprit Bumrah', 'Bowler', '🇮🇳'),
              _buildConnectionCard2('KL Rahul', 'WK-Batter', '🇮🇳'),
              _buildConnectionCard2('Hardik Pandya', 'All-Rounder', '🇮🇳'),
              _buildConnectionCard2('R Jadeja', 'All-Rounder', '🇮🇳'),
              _buildConnectionCard2('M Shami', 'Bowler', '🇮🇳'),
              _buildConnectionCard2('Shubman Gill', 'Batter', '🇮🇳'),
              _buildConnectionCard2('Rishabh Pant', 'WK-Batter', '🇮🇳'),
              _buildConnectionCard2('R Ashwin', 'Bowler', '🇮🇳'),
              _buildConnectionCard2('S Iyer', 'Batter', '🇮🇳'),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 6: GALLERY
  Widget _buildPicturesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cricket Moments',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: List.generate(12, (index) => _buildPhotoCard(index)),
          ),
        ],
      ),
    );
  }

  // Helper Widgets

  Widget _buildCleanSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 15,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildDetailRow2(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamTag(String team) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        team,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }

  Widget _buildSocialLink2(
    IconData icon,
    String platform,
    String handle,
    Color color,
  ) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                platform,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                handle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAwardCard(String title, String year, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.warning.withValues(alpha: 0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.warning, size: 40),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.4,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              year,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestonesList() {
    final milestones = [
      '3 ODI Double Centuries (Only Player)',
      '5 T20I Centuries (First Indian)',
      'Most T20I Sixes (203)',
      'Fastest to 10,000 T20 Runs',
      '5 IPL Titles as Captain',
      'Most International Sixes',
    ];

    return Column(
      children: milestones.map((milestone) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, AppColors.success.withValues(alpha: 0.03)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.success.withValues(alpha: 0.2),
                      AppColors.success.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 24,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  milestone,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          _buildTableRow2(
            'Test',
            '59',
            '4,137',
            '212',
            '46.11',
            '54.32',
            false,
          ),
          _buildTableRow2(
            'ODI',
            '265',
            '10,866',
            '264',
            '48.96',
            '90.23',
            true,
          ),
          _buildTableRow2(
            'T20I',
            '159',
            '4,231',
            '121*',
            '31.32',
            '139.24',
            false,
          ),
          _buildTableRow2(
            'IPL',
            '257',
            '6,628',
            '109*',
            '30.45',
            '130.61',
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Format', flex: 2),
          _buildHeaderCell('Mat', flex: 1),
          _buildHeaderCell('Runs', flex: 1),
          _buildHeaderCell('HS', flex: 1),
          _buildHeaderCell('Avg', flex: 1),
          _buildHeaderCell('SR', flex: 1),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
        ),
        textAlign: flex == 2 ? TextAlign.left : TextAlign.center,
      ),
    );
  }

  Widget _buildTableRow2(
    String format,
    String mat,
    String runs,
    String hs,
    String avg,
    String sr,
    bool isEven,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isEven ? Colors.grey[50] : Colors.white),
      child: Row(
        children: [
          _buildDataCell(format, bold: true, flex: 2),
          _buildDataCell(mat, flex: 1),
          _buildDataCell(runs, flex: 1),
          _buildDataCell(hs, flex: 1),
          _buildDataCell(avg, flex: 1),
          _buildDataCell(sr, flex: 1),
        ],
      ),
    );
  }

  Widget _buildDataCell(String text, {bool bold = false, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        textAlign: flex == 2 ? TextAlign.left : TextAlign.center,
      ),
    );
  }

  Widget _buildRecentMatches() {
    return Column(
      children: List.generate(5, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                AppColors.accentBlue.withValues(alpha: 0.02),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.accentBlue.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentBlue.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accentBlue.withValues(alpha: 0.2),
                      AppColors.accentBlue.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.sports_cricket,
                  color: AppColors.accentBlue,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IND vs AUS - ODI Match ${index + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mumbai • 15 Jan 2024',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '87',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  Text(
                    '52 balls',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTeamCard2(
    String name,
    String type,
    String duration,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, color.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            duration,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionCard2(String name, String role, String flag) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[50]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGreen.withValues(alpha: 0.2),
                  AppColors.accentBlue.withValues(alpha: 0.2),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: Colors.transparent,
              child: Text(
                name[0],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: 0.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              role,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.accentBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(flag, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(int index) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[100]!, Colors.grey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.photo_library,
              size: 40,
              color: AppColors.primaryGreen.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Photo ${index + 1}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
