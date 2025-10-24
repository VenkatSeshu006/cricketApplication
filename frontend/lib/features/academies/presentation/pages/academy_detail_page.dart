import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../domain/models/academy.dart';
import '../../domain/models/coach.dart';

class AcademyDetailPage extends StatefulWidget {
  final Academy academy;

  const AcademyDetailPage({super.key, required this.academy});

  @override
  State<AcademyDetailPage> createState() => _AcademyDetailPageState();
}

class _AcademyDetailPageState extends State<AcademyDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock coaches data
  late List<Coach> _coaches;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeMockCoaches();
  }

  void _initializeMockCoaches() {
    _coaches = [
      Coach(
        id: '1',
        name: 'Habibul Bashar',
        specialization: 'Batting',
        experience: 15,
        certification: 'ICC Level 3',
        rating: 4.9,
        imageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
        studentsTrained: 250,
        achievements: [
          'Former National Team Player',
          'Trained 5 National Players',
          'Best Coach Award 2022',
        ],
        description:
            'Former national team batsman with 15 years of coaching experience. Specialized in technique refinement and match preparation.',
        isHeadCoach: true,
      ),
      Coach(
        id: '2',
        name: 'Shahadat Hossain',
        specialization: 'Bowling',
        experience: 12,
        certification: 'ICC Level 2',
        rating: 4.7,
        imageUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e',
        studentsTrained: 180,
        achievements: [
          'Fast Bowling Specialist',
          'Trained 8 State Level Players',
          'Biomechanics Expert',
        ],
        description:
            'Expert fast bowling coach with focus on pace, accuracy, and injury prevention.',
        isHeadCoach: false,
      ),
      Coach(
        id: '3',
        name: 'Khaled Mashud',
        specialization: 'Wicket Keeping',
        experience: 10,
        certification: 'ICC Level 2',
        rating: 4.8,
        imageUrl:
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d',
        studentsTrained: 120,
        achievements: [
          'Former National Wicket Keeper',
          'Trained 3 National Team Players',
          'Keeping Technique Expert',
        ],
        description:
            'Former international wicket keeper specializing in keeping techniques and batting skills.',
        isHeadCoach: false,
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(children: [_buildInfoCards(), _buildTabBar()]),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildProgramsTab(),
                _buildCoachesTab(),
                _buildReviewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppColors.primaryGreen,
      flexibleSpace: FlexibleSpaceBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.academy.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.academy.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.primaryGreen,
                child: const Icon(Icons.school, size: 80, color: Colors.white),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            if (widget.academy.hasCertification)
              Positioned(
                top: 60,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified, size: 16, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'CERTIFIED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildInfoCards() {
    return Padding(
      padding: ResponsiveHelper.getPagePadding(context),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickInfoCard(
                  Icons.star,
                  widget.academy.rating.toString(),
                  '${widget.academy.reviewCount} Reviews',
                  Colors.amber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickInfoCard(
                  Icons.people,
                  '${widget.academy.totalStudents}+',
                  'Students',
                  AppColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickInfoCard(
                  Icons.calendar_today,
                  widget.academy.established,
                  'Established',
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildQuickInfoCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primaryGreen,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primaryGreen,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Programs'),
          Tab(text: 'Coaches'),
          Tab(text: 'Reviews'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getPagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildSectionTitle('About Academy'),
          const SizedBox(height: 12),
          Text(
            widget.academy.description,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Contact Information'),
          const SizedBox(height: 12),
          _buildContactInfo(Icons.location_on, widget.academy.address),
          _buildContactInfo(Icons.phone, widget.academy.contactNumber),
          _buildContactInfo(Icons.email, widget.academy.email),
          _buildContactInfo(Icons.access_time, widget.academy.timing),
          const SizedBox(height: 24),
          _buildSectionTitle('Facilities'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.academy.facilities
                .map((facility) => _buildFacilityChip(facility))
                .toList(),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Age Groups'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.academy.ageGroups
                .map((age) => _buildAgeGroupChip(age))
                .toList(),
          ),
          if (widget.academy.achievements.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionTitle('Achievements'),
            const SizedBox(height: 12),
            ...widget.academy.achievements.map(
              (achievement) => _buildAchievementItem(achievement),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showEnrollmentDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Enroll Now',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProgramsTab() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getPagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildSectionTitle('Available Programs'),
          const SizedBox(height: 16),
          ...widget.academy.programs.map((program) {
            final fee = (widget.academy.fees[program] ?? 0).toInt();
            return _buildProgramCard(program, fee);
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProgramCard(String program, int fee) {
    IconData icon;
    String description;

    switch (program) {
      case 'Batting':
        icon = Icons.sports_cricket;
        description =
            'Comprehensive batting training focusing on technique, footwork, and shot selection.';
        break;
      case 'Bowling':
        icon = Icons.track_changes;
        description =
            'Expert bowling coaching including pace, spin, and variation techniques.';
        break;
      case 'All-Round':
        icon = Icons.all_inclusive;
        description =
            'Complete cricket training covering batting, bowling, and fielding skills.';
        break;
      case 'Wicket Keeping':
        icon = Icons.sports;
        description =
            'Specialized training for wicket keepers including catching and batting skills.';
        break;
      case 'Fielding':
        icon = Icons.run_circle;
        description =
            'Advanced fielding techniques, agility training, and catching practice.';
        break;
      default:
        icon = Icons.sports;
        description = 'Specialized training program for cricket excellence.';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primaryGreen, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '৳$fee/month',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '4 sessions/week',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachesTab() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getPagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildSectionTitle('Our Expert Coaches'),
          const SizedBox(height: 16),
          ..._coaches.map((coach) => _buildCoachCard(coach)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCoachCard(Coach coach) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(coach.imageUrl),
                  onBackgroundImageError: (exception, stackTrace) {},
                  child: coach.imageUrl.isEmpty
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
                if (coach.isHeadCoach)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          coach.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              coach.rating.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${coach.specialization} • ${coach.certification}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    coach.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildCoachStat(
                        Icons.school,
                        '${coach.experience} years',
                      ),
                      const SizedBox(width: 12),
                      _buildCoachStat(
                        Icons.people,
                        '${coach.studentsTrained}+ trained',
                      ),
                    ],
                  ),
                  if (coach.achievements.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ...coach.achievements
                        .take(2)
                        .map(
                          (achievement) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.emoji_events,
                                  size: 14,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    achievement,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      padding: ResponsiveHelper.getPagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildRatingSummary(),
          const SizedBox(height: 24),
          _buildSectionTitle('Student Reviews'),
          const SizedBox(height: 16),
          ..._buildMockReviews(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      widget.academy.rating.toString(),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < widget.academy.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.academy.reviewCount} reviews',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar(5, 0.75),
                      _buildRatingBar(4, 0.15),
                      _buildRatingBar(3, 0.06),
                      _buildRatingBar(2, 0.03),
                      _buildRatingBar(1, 0.01),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$stars',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 14, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: AppColors.border.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percentage * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMockReviews() {
    final reviews = [
      {
        'name': 'Rakib Hassan',
        'rating': 5.0,
        'date': '2 days ago',
        'comment':
            'Excellent academy with professional coaches. My son has improved significantly in just 3 months. Highly recommended!',
        'program': 'Batting',
      },
      {
        'name': 'Nusrat Jahan',
        'rating': 5.0,
        'date': '1 week ago',
        'comment':
            'Great facilities and very supportive coaching staff. The academy focuses on both technique and mental strength.',
        'program': 'All-Round',
      },
      {
        'name': 'Kamal Uddin',
        'rating': 4.0,
        'date': '2 weeks ago',
        'comment':
            'Good academy with experienced coaches. The only improvement needed is better scheduling flexibility.',
        'program': 'Bowling',
      },
    ];

    return reviews.map((review) => _buildReviewCard(review)).toList();
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryGreen.withValues(
                    alpha: 0.2,
                  ),
                  child: Text(
                    review['name'].toString()[0],
                    style: const TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['name'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        review['date'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        review['rating'].toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review['comment'] as String,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Program: ${review['program']}',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityChip(String facility) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getFacilityIcon(facility),
            size: 16,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(width: 6),
          Text(
            facility,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeGroupChip(String ageGroup) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Text(
        ageGroup,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.blue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAchievementItem(String achievement) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.emoji_events, size: 20, color: Colors.amber),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              achievement,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFacilityIcon(String facility) {
    final facilityIcons = {
      'Indoor Nets': Icons.sports_cricket,
      'Outdoor Ground': Icons.sports,
      'Gym': Icons.fitness_center,
      'Video Analysis': Icons.videocam,
      'Physio Center': Icons.local_hospital,
      'Swimming Pool': Icons.pool,
      'Practice Nets': Icons.sports_cricket,
      'Changing Rooms': Icons.meeting_room,
      'Equipment Store': Icons.store,
      'Sports Psychology Center': Icons.psychology,
      'Accommodation': Icons.hotel,
    };
    return facilityIcons[facility] ?? Icons.check_circle;
  }

  void _showEnrollmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enroll in Academy'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Academy: ${widget.academy.name}'),
            const SizedBox(height: 16),
            const Text(
              'Please select a program and complete the enrollment form:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Personal Information\n• Program Selection\n• Medical History\n• Payment Details',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Enrollment feature coming soon!'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }
}
