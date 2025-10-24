import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen>
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
            _buildServicesTab(),
            _buildExperienceTab(),
            _buildPatientsTab(),
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
                      const Color(0xFFE91E63),
                      AppColors.primaryOrange,
                      AppColors.accentBlue.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE91E63).withValues(alpha: 0.3),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.local_hospital,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dr. Patrick Farhart',
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
                        _buildInfoChip(
                          '🇦🇺 Australia',
                          AppColors.primaryOrange,
                        ),
                        const SizedBox(width: 12),
                        _buildInfoChip(
                          'Sports Physician',
                          const Color(0xFFE91E63),
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
                        color: const Color(0xFFE91E63),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Cricket Australia Team Doctor',
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
                    icon: const Icon(Icons.event, size: 18),
                    label: const Text('Book Appointment'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: _buildStatCard('Patients', '500+', Icons.people)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Experience',
                  '15 Years',
                  Icons.workspace_premium,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard('Success Rate', '96%', Icons.trending_up),
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
            color: const Color(0xFFE91E63).withValues(alpha: 0.08),
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
              color: const Color(0xFFE91E63).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFE91E63), size: 28),
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
        indicatorColor: const Color(0xFFE91E63),
        indicatorWeight: 4,
        labelColor: const Color(0xFFE91E63),
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        tabs: const [
          Tab(text: 'PROFILE'),
          Tab(text: 'SERVICES'),
          Tab(text: 'EXPERIENCE'),
          Tab(text: 'PATIENTS'),
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
              'Specialist in sports medicine and cricket injuries. Team doctor for Cricket Australia with expertise in injury prevention, rehabilitation, and player fitness.',
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
                      'Sports Medicine',
                      'Injury Prevention',
                      'Rehabilitation',
                      'Fitness Assessment',
                      'Nutrition',
                    ].map((e) => _buildSkillChip(e)).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: _buildSection(
                  'Qualifications',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('MBBS', 'University of Melbourne'),
                      _buildDetailRow('Sports Medicine', 'ASCA Certified'),
                      _buildDetailRow('Physiotherapy', 'Advanced Diploma'),
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

  Widget _buildServicesTab() {
    return const Center(child: Text('Services content'));
  }

  Widget _buildExperienceTab() {
    return const Center(child: Text('Experience content'));
  }

  Widget _buildPatientsTab() {
    return const Center(child: Text('Patients content'));
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
        color: const Color(0xFFE91E63).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE91E63).withValues(alpha: 0.2)),
      ),
      child: Text(
        skill,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE91E63),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
