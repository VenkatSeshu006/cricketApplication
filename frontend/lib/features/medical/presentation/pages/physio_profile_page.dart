import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/physio.dart';

class PhysioProfilePage extends StatefulWidget {
  final Physio physio;

  const PhysioProfilePage({super.key, required this.physio});

  @override
  State<PhysioProfilePage> createState() => _PhysioProfilePageState();
}

class _PhysioProfilePageState extends State<PhysioProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dummy reviews
  final List<PhysioReview> _reviews = [
    PhysioReview(
      id: '1',
      patientName: 'Rakib Hassan',
      rating: 5.0,
      comment:
          'Excellent physiotherapist! Helped me recover from a shoulder injury in just 3 weeks. Very professional and knowledgeable about cricket-specific injuries.',
      date: '2 weeks ago',
      treatmentType: 'Shoulder Injury',
    ),
    PhysioReview(
      id: '2',
      patientName: 'Tanvir Ahmed',
      rating: 4.5,
      comment:
          'Great experience. The treatment plan was very effective and I could return to playing cricket sooner than expected. Highly recommended!',
      date: '1 month ago',
      treatmentType: 'Knee Rehabilitation',
    ),
    PhysioReview(
      id: '3',
      patientName: 'Sabbir Rahman',
      rating: 5.0,
      comment:
          'Best physiotherapist I have consulted. Very patient in explaining the exercises and provides detailed feedback. My bowling action has improved significantly.',
      date: '2 months ago',
      treatmentType: 'Bowling Action Analysis',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _bookAppointment() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBookingSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar with Profile Header
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1a2332),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share feature - Coming soon!'),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, color: Colors.white),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to favorites!')),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1a2332), AppColors.accentBlue],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    // Profile Image
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.white, Colors.white70],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.accentBlue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.physio.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.physio.qualification,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: widget.physio.isAvailable
                            ? AppColors.primaryGreen
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.physio.isAvailable ? 'Available Now' : 'Busy',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Quick Stats
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildStatCard(
                    Icons.star,
                    widget.physio.rating.toString(),
                    'Rating',
                    Colors.amber,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    Icons.people,
                    '${widget.physio.reviewCount}+',
                    'Patients',
                    AppColors.accentBlue,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    Icons.work,
                    '${widget.physio.experience} yrs',
                    'Experience',
                    AppColors.primaryGreen,
                  ),
                ],
              ),
            ),
          ),

          // Tab Bar
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.accentBlue,
                unselectedLabelColor: Colors.grey[600],
                indicatorColor: AppColors.accentBlue,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                tabs: const [
                  Tab(text: 'About'),
                  Tab(text: 'Reviews'),
                  Tab(text: 'Availability'),
                ],
              ),
            ),
          ),

          // Tab Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAboutTab(),
                _buildReviewsTab(),
                _buildAvailabilityTab(),
              ],
            ),
          ),
        ],
      ),

      // Book Appointment Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consultation Fee',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      '৳${widget.physio.consultationFee.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _bookAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Book Appointment',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
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
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Specialization
          _buildSectionHeader('Specialization'),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accentBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.accentBlue.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              widget.physio.specialization,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.accentBlue,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // About
          _buildSectionHeader('About'),
          const SizedBox(height: 12),
          Text(
            widget.physio.about,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 24),

          // Expertise
          _buildSectionHeader('Areas of Expertise'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.physio.expertise.map((exp) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primaryGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      exp,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Certifications
          _buildSectionHeader('Certifications'),
          const SizedBox(height: 12),
          ...widget.physio.certifications.map((cert) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        size: 20,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        cert,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 24),

          // Languages
          _buildSectionHeader('Languages'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: widget.physio.languages.map((lang) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.language,
                      size: 18,
                      color: AppColors.accentBlue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      lang,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Location
          _buildSectionHeader('Clinic Location'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.business, color: AppColors.primaryGreen),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.physio.clinic,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 20,
                      color: AppColors.primaryOrange,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.physio.location,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Opening in maps...')),
                    );
                  },
                  icon: const Icon(Icons.directions, size: 18),
                  label: const Text('Get Directions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Overview
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accentBlue, AppColors.primaryGreen],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      widget.physio.rating.toString(),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < widget.physio.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Based on ${widget.physio.reviewCount} reviews',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Patients love this physiotherapist for their expertise and care',
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          _buildSectionHeader('Patient Reviews'),
          const SizedBox(height: 12),

          // Reviews List
          ..._reviews.map((review) => _buildReviewCard(review)),
        ],
      ),
    );
  }

  Widget _buildAvailabilityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Next Available
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.physio.isAvailable
                  ? AppColors.primaryGreen.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.physio.isAvailable
                    ? AppColors.primaryGreen
                    : Colors.orange,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.physio.isAvailable
                        ? AppColors.primaryGreen
                        : Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.physio.isAvailable
                            ? 'Available Now'
                            : 'Next Available',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.physio.nextAvailable,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Working Days
          _buildSectionHeader('Working Days'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((
              day,
            ) {
              final isWorking = widget.physio.workingDays.contains(day);
              return Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isWorking ? AppColors.primaryGreen : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isWorking ? Colors.white : Colors.grey[500],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Working Hours
          _buildSectionHeader('Working Hours'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule, color: AppColors.accentBlue),
                const SizedBox(width: 12),
                Text(
                  widget.physio.workingHours,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Consultation Fee Info
          _buildSectionHeader('Consultation Fee'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.accentBlue],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Per Session',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '30-45 minutes',
                      style: TextStyle(fontSize: 13, color: Colors.white60),
                    ),
                  ],
                ),
                Text(
                  '৳${widget.physio.consultationFee.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildReviewCard(PhysioReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.accentBlue, AppColors.primaryGreen],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.patientName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      review.date,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating.floor()
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              review.treatmentType,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.accentBlue,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Icon(
            Icons.calendar_today,
            size: 48,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: 16),
          const Text(
            'Book Appointment',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Schedule your consultation with ${widget.physio.name}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Consultation Fee',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '৳${widget.physio.consultationFee.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Next Available',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.physio.nextAvailable,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Booking confirmed with ${widget.physio.name}!',
                    ),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Confirm Booking',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
