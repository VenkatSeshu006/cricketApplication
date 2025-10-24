import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CoachProfileScreen extends StatefulWidget {
  const CoachProfileScreen({super.key});

  @override
  State<CoachProfileScreen> createState() => _CoachProfileScreenState();
}

class _CoachProfileScreenState extends State<CoachProfileScreen>
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
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildTabBar()),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildProfileTab(),
            _buildExperienceTab(),
            _buildAchievementsTab(),
            _buildPlayersTab(),
            _buildConnectionsTab(),
            _buildGalleryTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accentBlue,
                      AppColors.primaryGreen,
                      AppColors.primaryOrange.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentBlue.withValues(alpha: 0.3),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.school, size: 60, color: Colors.white),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ravi Shastri',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildInfoChip('🇮🇳 India', AppColors.primaryOrange),
                        const SizedBox(width: 12),
                        _buildInfoChip('Head Coach', AppColors.accentBlue),
                        const SizedBox(width: 12),
                        _buildInfoChip('25+ Years Exp', AppColors.success),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'ICC Level 3 Certified',
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
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Share'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.message, size: 18),
                    label: const Text('Contact'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: _buildStatCard('Students', '150+', Icons.people)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Experience',
                  '25 Years',
                  Icons.workspace_premium,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('Trophies', '12', Icons.emoji_events),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Rating', '4.9/5', Icons.star)),
            ],
          ),
        ],
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentBlue.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accentBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.accentBlue, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: AppColors.accentBlue,
        indicatorWeight: 4,
        labelColor: AppColors.accentBlue,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        tabs: const [
          Tab(text: 'PROFILE'),
          Tab(text: 'EXPERIENCE'),
          Tab(text: 'ACHIEVEMENTS'),
          Tab(text: 'PLAYERS'),
          Tab(text: 'CONNECTIONS'),
          Tab(text: 'GALLERY'),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'About',
            Text(
              'Renowned cricket coach with over 25 years of experience in developing world-class players. Former Indian cricketer turned coach, known for strategic thinking and player development.',
              style: TextStyle(
                fontSize: 15,
                height: 1.7,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildSection(
                  'Specializations',
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      'Batting Technique',
                      'Mental Conditioning',
                      'Match Strategy',
                      'Leadership Development',
                      'Fitness Training',
                      'Team Building',
                    ].map((e) => _buildSkillChip(e)).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: _buildSection(
                  'Certifications',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('ICC Level 3 Coach', '2015'),
                      _buildDetailRow('NCA Certification', '2010'),
                      _buildDetailRow('Sports Psychology', '2018'),
                      _buildDetailRow('Fitness Trainer', '2012'),
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

  Widget _buildExperienceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Coaching Experience',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildExperienceCard(
            'India National Team',
            'Head Coach',
            '2017 - 2021',
            'Led team to historic series wins in Australia, achieved #1 Test ranking',
            Icons.flag,
            AppColors.primaryOrange,
          ),
          _buildExperienceCard(
            'Mumbai Indians',
            'Batting Coach',
            '2014 - 2017',
            'Won 2 IPL titles, developed young talent',
            Icons.sports_cricket,
            AppColors.accentBlue,
          ),
          _buildExperienceCard(
            'National Cricket Academy',
            'Senior Coach',
            '2010 - 2014',
            'Trained U19 and emerging players',
            Icons.school,
            AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsTab() {
    return const Center(child: Text('Achievements content'));
  }

  Widget _buildPlayersTab() {
    return const Center(child: Text('Players content'));
  }

  Widget _buildConnectionsTab() {
    return const Center(child: Text('Connections content'));
  }

  Widget _buildGalleryTab() {
    return const Center(child: Text('Gallery content'));
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
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
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accentBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.2)),
      ),
      child: Text(
        skill,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.accentBlue,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(
    String organization,
    String position,
    String duration,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  organization,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  position,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  duration,
                  style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
