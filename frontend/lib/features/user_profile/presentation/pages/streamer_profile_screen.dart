import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StreamerProfileScreen extends StatefulWidget {
  const StreamerProfileScreen({super.key});

  @override
  State<StreamerProfileScreen> createState() => _StreamerProfileScreenState();
}

class _StreamerProfileScreenState extends State<StreamerProfileScreen>
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
            _buildChannelsTab(),
            _buildStatsTab(),
            _buildHighlightsTab(),
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
                      const Color(0xFF9C27B0),
                      AppColors.primaryOrange,
                      AppColors.accentBlue.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.videocam, size: 60, color: Colors.white),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CricStream Pro',
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
                          'Live Streamer',
                          const Color(0xFF9C27B0),
                        ),
                        const SizedBox(width: 12),
                        _buildInfoChip('HD Quality', AppColors.success),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF9C27B0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Verified Partner • 1M+ Subscribers',
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
                    icon: const Icon(Icons.subscriptions, size: 18),
                    label: const Text('Subscribe'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Subscribers', '1.2M', Icons.people),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('Total Views', '50M', Icons.visibility),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Streams', '500+', Icons.live_tv)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('Avg Views', '25K', Icons.trending_up),
              ),
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
            color: const Color(0xFF9C27B0).withValues(alpha: 0.08),
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
              color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF9C27B0), size: 28),
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
        indicatorColor: const Color(0xFF9C27B0),
        indicatorWeight: 4,
        labelColor: const Color(0xFF9C27B0),
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        tabs: const [
          Tab(text: 'PROFILE'),
          Tab(text: 'CHANNELS'),
          Tab(text: 'STATS'),
          Tab(text: 'HIGHLIGHTS'),
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
              'Professional cricket live streamer providing HD quality streams of international and domestic matches. Trusted by millions of cricket fans worldwide.',
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
                  'Platforms',
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      'YouTube',
                      'Twitch',
                      'Facebook Live',
                      'Custom Platform',
                    ].map((e) => _buildPlatformChip(e)).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: _buildSection(
                  'Features',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFeatureRow('HD Streaming', true),
                      _buildFeatureRow('Multi-camera', true),
                      _buildFeatureRow('Live Commentary', true),
                      _buildFeatureRow('Chat Integration', true),
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

  Widget _buildChannelsTab() {
    return const Center(child: Text('Channels content'));
  }

  Widget _buildStatsTab() {
    return const Center(child: Text('Stats content'));
  }

  Widget _buildHighlightsTab() {
    return const Center(child: Text('Highlights content'));
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

  Widget _buildPlatformChip(String platform) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF9C27B0).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF9C27B0).withValues(alpha: 0.2)),
      ),
      child: Text(
        platform,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF9C27B0),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String feature, bool available) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            available ? Icons.check_circle : Icons.cancel,
            color: available ? AppColors.success : AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            feature,
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
