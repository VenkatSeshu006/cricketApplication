import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/staff.dart';

class StaffDetailPage extends StatefulWidget {
  final Staff staff;

  const StaffDetailPage({super.key, required this.staff});

  @override
  State<StaffDetailPage> createState() => _StaffDetailPageState();
}

class _StaffDetailPageState extends State<StaffDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<StaffReview> _reviews = [
    StaffReview(
      id: '1',
      clientName: 'Dhaka Gladiators',
      rating: 5.0,
      comment:
          'Excellent professional! Very knowledgeable and patient. Helped our team improve significantly.',
      date: DateTime(2024, 10, 15),
      eventType: 'Tournament Coaching',
    ),
    StaffReview(
      id: '2',
      clientName: 'Mirpur Sports Club',
      rating: 4.5,
      comment:
          'Great experience and expertise. Highly recommend for anyone looking for quality service.',
      date: DateTime(2024, 9, 28),
      eventType: 'Training Session',
    ),
    StaffReview(
      id: '3',
      clientName: 'Bangladesh U19 Team',
      rating: 5.0,
      comment:
          'Outstanding work! Very professional and dedicated. Will definitely work with again.',
      date: DateTime(2024, 8, 12),
      eventType: 'Youth Development Camp',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: _getRoleColor(widget.staff.role),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getRoleColor(widget.staff.role),
                      _getRoleColor(widget.staff.role).withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  widget.staff.name.substring(0, 1),
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.staff.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.staff.role,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                                  ),
                                  if (widget.staff.qualification != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.staff.qualification!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share functionality coming soon!'),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to bookmarks!')),
                  );
                },
              ),
            ],
          ),

          // Quick Stats
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      Icons.star,
                      widget.staff.rating.toString(),
                      'Rating',
                      Colors.amber,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      Icons.sports_cricket,
                      widget.staff.matchesHandled.toString(),
                      'Matches',
                      AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      Icons.work_history,
                      '${widget.staff.experience}+',
                      'Years',
                      AppColors.accentBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tab Bar
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: _getRoleColor(widget.staff.role),
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: _getRoleColor(widget.staff.role),
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
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Specialization Highlight
          if (widget.staff.specialization != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getRoleColor(widget.staff.role).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getRoleColor(
                    widget.staff.role,
                  ).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.stars, color: _getRoleColor(widget.staff.role)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Specialization',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.staff.specialization!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getRoleColor(widget.staff.role),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // About Section
          const Text(
            'About',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            widget.staff.about,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),

          // Expertise
          const Text(
            'Expertise',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.staff.expertise.map((exp) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _getRoleColor(
                    widget.staff.role,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getRoleColor(
                      widget.staff.role,
                    ).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  exp,
                  style: TextStyle(
                    fontSize: 13,
                    color: _getRoleColor(widget.staff.role),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Certifications
          const Text(
            'Certifications',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...widget.staff.certifications.map((cert) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified, color: _getRoleColor(widget.staff.role)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      cert,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 24),

          // Languages
          const Text(
            'Languages',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            children: [
              ...widget.staff.languages.map((lang) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    lang,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.accentBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 24), // Organization & Location
          if (widget.staff.organization != null) ...[
            _buildInfoRow(
              Icons.business,
              'Organization',
              widget.staff.organization!,
            ),
            const SizedBox(height: 16),
          ],
          _buildInfoRow(Icons.location_on, 'Location', widget.staff.location),
          const SizedBox(height: 24),

          // Notable Tournaments
          const Text(
            'Notable Tournaments',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...widget.staff.tournaments.map((tournament) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 18,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(width: 12),
                  Text(tournament, style: const TextStyle(fontSize: 14)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Overview
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.withValues(alpha: 0.1),
                  Colors.amber.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      widget.staff.rating.toString(),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < widget.staff.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber[700],
                          size: 20,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.staff.reviewCount} reviews',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar(5, 0.85),
                      _buildRatingBar(4, 0.10),
                      _buildRatingBar(3, 0.03),
                      _buildRatingBar(2, 0.01),
                      _buildRatingBar(1, 0.01),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Reviews List
          const Text(
            'Recent Reviews',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._reviews.map((review) => _buildReviewCard(review)),
        ],
      ),
    );
  }

  Widget _buildAvailabilityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Next Available
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.success.withValues(alpha: 0.1),
                  AppColors.success.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.event_available, color: AppColors.success, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Available',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.staff.nextAvailable ?? 'Not specified',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
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
          const Text(
            'Working Days',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayChip('Mon', widget.staff.availability.contains('Mon')),
              _buildDayChip('Tue', widget.staff.availability.contains('Tue')),
              _buildDayChip('Wed', widget.staff.availability.contains('Wed')),
              _buildDayChip('Thu', widget.staff.availability.contains('Thu')),
              _buildDayChip('Fri', widget.staff.availability.contains('Fri')),
              _buildDayChip('Sat', widget.staff.availability.contains('Sat')),
              _buildDayChip('Sun', widget.staff.availability.contains('Sun')),
            ],
          ),
          const SizedBox(height: 24),

          // Rate Information
          const Text(
            'Rate Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hourly Rate',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '৳${widget.staff.hourlyRate.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AppColors.accentBlue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Rates may vary for tournaments and special events',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.accentBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$stars', style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          Icon(Icons.star, size: 14, color: Colors.amber[700]),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber[700]!),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percentage * 100).toInt()}%',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(StaffReview review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
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
                  color: _getRoleColor(
                    widget.staff.role,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    review.clientName.substring(0, 1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getRoleColor(widget.staff.role),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.clientName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < review.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            size: 14,
                            color: Colors.amber[700],
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          '${review.date.day}/${review.date.month}/${review.date.year}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          if (review.eventType != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accentBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                review.eventType!,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.accentBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDayChip(String day, bool isAvailable) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: isAvailable
            ? _getRoleColor(widget.staff.role)
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isAvailable ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '৳${widget.staff.hourlyRate.toStringAsFixed(0)}/hour',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                if (widget.staff.isAvailable)
                  Text(
                    'Available Now',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  Text(
                    'Next: ${widget.staff.nextAvailable}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                _showBookingBottomSheet();
              },
              icon: const Icon(Icons.calendar_today, size: 20),
              label: const Text('Book Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _getRoleColor(widget.staff.role),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Book ${widget.staff.name}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.staff.role,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _getRoleColor(
                          widget.staff.role,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Hourly Rate',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '৳${widget.staff.hourlyRate.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _getRoleColor(widget.staff.role),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'To book this professional, please contact us:',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    _buildContactOption(
                      Icons.phone,
                      'Call',
                      '+880 1234-567890',
                    ),
                    _buildContactOption(
                      Icons.email,
                      'Email',
                      'booking@cricapp.com',
                    ),
                    _buildContactOption(
                      Icons.chat,
                      'WhatsApp',
                      '+880 1234-567890',
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
                                'Booking request sent for ${widget.staff.name}!',
                              ),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getRoleColor(widget.staff.role),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Confirm Booking Request',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  Widget _buildContactOption(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: _getRoleColor(widget.staff.role)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Coach':
        return AppColors.primaryGreen;
      case 'Umpire':
        return AppColors.accentBlue;
      case 'Groundskeeper':
        return Colors.brown;
      default:
        return AppColors.textPrimary;
    }
  }
}
