import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CommentatorProfileScreen extends StatefulWidget {
  const CommentatorProfileScreen({super.key});

  @override
  State<CommentatorProfileScreen> createState() =>
      _CommentatorProfileScreenState();
}

class _CommentatorProfileScreenState extends State<CommentatorProfileScreen>
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
            _buildPortfolioTab(),
            _buildBroadcastersTab(),
            _buildConnectionsTab(),
            _buildMediaTab(),
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
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryOrange,
                      AppColors.accentBlue,
                      AppColors.primaryGreen.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryOrange.withValues(alpha: 0.3),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.mic, size: 60, color: Colors.white),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Harsha Bhogle',
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
                        _buildInfoChip('Commentator', AppColors.accentBlue),
                        const SizedBox(width: 12),
                        _buildInfoChip('30+ Years', AppColors.success),
                      ],
                    ),
                    const SizedBox(height: 12),
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
                        'Voice of Cricket',
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
              Expanded(
                child: _buildStatCard('Matches', '2000+', Icons.sports_cricket),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Experience',
                  '30 Years',
                  Icons.workspace_premium,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('Languages', '3', Icons.translate),
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
            color: AppColors.primaryOrange.withValues(alpha: 0.08),
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
              color: AppColors.primaryOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryOrange, size: 28),
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
        indicatorColor: AppColors.primaryOrange,
        indicatorWeight: 4,
        labelColor: AppColors.primaryOrange,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        tabs: const [
          Tab(text: 'PROFILE'),
          Tab(text: 'PORTFOLIO'),
          Tab(text: 'BROADCASTERS'),
          Tab(text: 'CONNECTIONS'),
          Tab(text: 'MEDIA'),
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
              'India\'s most loved cricket commentator with a unique blend of wit, wisdom, and deep knowledge of the game. Known for insightful analysis and engaging commentary style.',
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
                  'Languages',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLanguageRow('English', 'Native'),
                      _buildLanguageRow('Hindi', 'Fluent'),
                      _buildLanguageRow('Marathi', 'Conversational'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: _buildSection(
                  'Commentary Style',
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      'Analytical',
                      'Entertaining',
                      'Technical',
                      'Story-driven',
                    ].map((e) => _buildSkillChip(e)).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notable Commentary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _buildMatchCard(
            'ICC World Cup Final 2011',
            'India vs Sri Lanka',
            'Wankhede Stadium, Mumbai',
            'April 2, 2011',
            Icons.emoji_events,
          ),
          _buildMatchCard(
            'India vs Australia 2001',
            'Historic Test Series',
            'Eden Gardens, Kolkata',
            'March 11-15, 2001',
            Icons.stadium,
          ),
          _buildMatchCard(
            'IPL 2023 Final',
            'Chennai vs Gujarat',
            'Ahmedabad',
            'May 29, 2023',
            Icons.sports_cricket,
          ),
        ],
      ),
    );
  }

  Widget _buildBroadcastersTab() {
    return const Center(child: Text('Broadcasters content'));
  }

  Widget _buildConnectionsTab() {
    return const Center(child: Text('Connections content'));
  }

  Widget _buildMediaTab() {
    return const Center(child: Text('Media content'));
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
        color: AppColors.primaryOrange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryOrange.withValues(alpha: 0.2)),
      ),
      child: Text(
        skill,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryOrange,
        ),
      ),
    );
  }

  Widget _buildLanguageRow(String language, String proficiency) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            language,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              proficiency,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(
    String title,
    String subtitle,
    String venue,
    String date,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryOrange.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withValues(alpha: 0.1),
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
              color: AppColors.primaryOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryOrange, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      venue,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
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
}
