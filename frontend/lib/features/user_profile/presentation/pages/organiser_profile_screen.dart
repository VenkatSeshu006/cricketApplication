import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class OrganiserProfileScreen extends StatefulWidget {
  const OrganiserProfileScreen({super.key});

  @override
  State<OrganiserProfileScreen> createState() => _OrganiserProfileScreenState();
}

class _OrganiserProfileScreenState extends State<OrganiserProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
            _buildEventsTab(),
            _buildVenuesTab(),
            _buildPartnersTab(),
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
                  child: Icon(Icons.event_note, size: 60, color: Colors.white),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sports Events India',
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
                        _buildInfoChip(
                          'Tournament Organiser',
                          AppColors.accentBlue,
                        ),
                        const SizedBox(width: 12),
                        _buildInfoChip('15+ Years', AppColors.success),
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
                        'BCCI Certified • 100+ Events',
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
              Expanded(child: _buildStatCard('Events', '120+', Icons.event)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Experience',
                  '15 Years',
                  Icons.workspace_premium,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Venues', '25', Icons.stadium)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Rating', '4.8/5', Icons.star)),
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
          Tab(text: 'EVENTS'),
          Tab(text: 'VENUES'),
          Tab(text: 'PARTNERS'),
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
              'Leading cricket tournament organiser in India specializing in domestic leagues, corporate tournaments, and youth championships. Known for professional event management and smooth execution.',
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
                  'Event Types',
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      'Tournaments',
                      'Corporate Events',
                      'School Leagues',
                      'Exhibition Matches',
                      'Charity Games',
                    ].map((e) => _buildSkillChip(e)).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: _buildSection(
                  'Services',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildServiceRow('Tournament Planning'),
                      _buildServiceRow('Venue Management'),
                      _buildServiceRow('Team Coordination'),
                      _buildServiceRow('Media Coverage'),
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

  Widget _buildEventsTab() {
    return const Center(child: Text('Events content'));
  }

  Widget _buildVenuesTab() {
    return const Center(child: Text('Venues content'));
  }

  Widget _buildPartnersTab() {
    return const Center(child: Text('Partners content'));
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

  Widget _buildServiceRow(String service) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.check, color: AppColors.success, size: 16),
          ),
          const SizedBox(width: 12),
          Text(
            service,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
