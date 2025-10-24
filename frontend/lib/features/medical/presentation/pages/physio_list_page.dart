import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/physio.dart';
import 'physio_profile_page.dart';

class PhysioListPage extends StatefulWidget {
  const PhysioListPage({super.key});

  @override
  State<PhysioListPage> createState() => _PhysioListPageState();
}

class _PhysioListPageState extends State<PhysioListPage> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Dummy data for physiotherapists
  final List<Physio> _physios = [
    Physio(
      id: '1',
      name: 'Dr. Ashraful Islam',
      qualification: 'BPT, MPT (Sports Medicine)',
      specialization: 'Sports Injury Rehabilitation',
      experience: 12,
      imageUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d',
      rating: 4.9,
      reviewCount: 342,
      location: 'Gulshan, Dhaka',
      clinic: 'Elite Sports Medicine Center',
      about:
          'Specialized in treating cricket-related injuries with over 12 years of experience. Former physiotherapist for Bangladesh National Cricket Team. Expert in biomechanics and injury prevention.',
      expertise: [
        'Shoulder Injuries',
        'Knee Rehabilitation',
        'Back Pain Management',
        'Sports Massage',
        'Injury Prevention',
      ],
      languages: ['Bengali', 'English', 'Hindi'],
      consultationFee: 2500,
      isAvailable: true,
      nextAvailable: 'Today, 3:00 PM',
      workingDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      workingHours: '9:00 AM - 8:00 PM',
      certifications: [
        'FIFA Medical Diploma',
        'Advanced Sports Injury Management',
        'Certified Manual Therapist',
      ],
    ),
    Physio(
      id: '2',
      name: 'Dr. Nusrat Jahan',
      qualification: 'BPT, MPT (Orthopedics)',
      specialization: 'Musculoskeletal Disorders',
      experience: 8,
      imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2',
      rating: 4.8,
      reviewCount: 287,
      location: 'Dhanmondi, Dhaka',
      clinic: 'Active Life Physiotherapy',
      about:
          'Expert in treating bowler\'s injuries, rotator cuff problems, and cricket-specific biomechanical issues. Passionate about helping athletes return to peak performance.',
      expertise: [
        'Bowling Action Analysis',
        'Rotator Cuff Injuries',
        'Elbow Tendinitis',
        'Postural Correction',
        'Dry Needling',
      ],
      languages: ['Bengali', 'English'],
      consultationFee: 2000,
      isAvailable: true,
      nextAvailable: 'Tomorrow, 10:00 AM',
      workingDays: ['Mon', 'Tue', 'Thu', 'Fri', 'Sat'],
      workingHours: '10:00 AM - 7:00 PM',
      certifications: [
        'Certified Dry Needling Practitioner',
        'Sports Biomechanics Specialist',
      ],
    ),
    Physio(
      id: '3',
      name: 'Dr. Kamal Rahman',
      qualification: 'BPT, DPT (Sports Physiotherapy)',
      specialization: 'Cricket Injury Management',
      experience: 15,
      imageUrl: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d',
      rating: 4.9,
      reviewCount: 456,
      location: 'Banani, Dhaka',
      clinic: 'Pro Sports Rehabilitation Center',
      about:
          'Renowned cricket physiotherapist with extensive experience treating international cricketers. Specializes in fast bowler injury management and prevention programs.',
      expertise: [
        'Fast Bowler Injuries',
        'Stress Fractures',
        'Lower Back Issues',
        'ACL Rehabilitation',
        'Performance Enhancement',
      ],
      languages: ['Bengali', 'English', 'Urdu'],
      consultationFee: 3000,
      isAvailable: false,
      nextAvailable: 'Wed, 2:00 PM',
      workingDays: ['Mon', 'Wed', 'Fri', 'Sat'],
      workingHours: '2:00 PM - 9:00 PM',
      certifications: [
        'ICC Medical Certification',
        'Advanced Spine Rehabilitation',
        'Strength & Conditioning Specialist',
      ],
    ),
    Physio(
      id: '4',
      name: 'Dr. Farhana Akter',
      qualification: 'BPT, MPT (Pediatrics)',
      specialization: 'Youth Cricket Development',
      experience: 6,
      imageUrl: 'https://images.unsplash.com/photo-1594824476967-48c8b964273f',
      rating: 4.7,
      reviewCount: 198,
      location: 'Uttara, Dhaka',
      clinic: 'Young Athletes Physiotherapy',
      about:
          'Specialized in treating young cricketers and preventing growth-related injuries. Focus on proper biomechanics development for junior players.',
      expertise: [
        'Growth Plate Injuries',
        'Flexibility Training',
        'Posture Development',
        'Overuse Prevention',
        'Pediatric Sports Medicine',
      ],
      languages: ['Bengali', 'English'],
      consultationFee: 1500,
      isAvailable: true,
      nextAvailable: 'Today, 5:00 PM',
      workingDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
      workingHours: '3:00 PM - 8:00 PM',
      certifications: [
        'Pediatric Sports Medicine Certificate',
        'Youth Development Specialist',
      ],
    ),
    Physio(
      id: '5',
      name: 'Dr. Mahmud Hassan',
      qualification: 'BPT, MPT (Sports Science)',
      specialization: 'Biomechanics & Performance',
      experience: 10,
      imageUrl: 'https://images.unsplash.com/photo-1537368910025-700350fe46c7',
      rating: 4.8,
      reviewCount: 312,
      location: 'Mirpur, Dhaka',
      clinic: 'Sports Performance Lab',
      about:
          'Combines physiotherapy with sports science to optimize cricket performance. Expert in batting technique analysis and injury prevention through biomechanical correction.',
      expertise: [
        'Batting Biomechanics',
        'Video Analysis',
        'Movement Screening',
        'Injury Prevention Programs',
        'Return to Sport',
      ],
      languages: ['Bengali', 'English'],
      consultationFee: 2200,
      isAvailable: true,
      nextAvailable: 'Today, 4:00 PM',
      workingDays: ['Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      workingHours: '11:00 AM - 9:00 PM',
      certifications: [
        'Biomechanics Specialist',
        'Functional Movement Screening',
        'Performance Analysis Expert',
      ],
    ),
    Physio(
      id: '6',
      name: 'Dr. Tasnima Sultana',
      qualification: 'BPT, MPT (Manual Therapy)',
      specialization: 'Manual Therapy & Rehabilitation',
      experience: 9,
      imageUrl: 'https://images.unsplash.com/photo-1551836022-d5d88e9218df',
      rating: 4.9,
      reviewCount: 267,
      location: 'Bashundhara, Dhaka',
      clinic: 'Complete Care Physiotherapy',
      about:
          'Expert manual therapist specializing in chronic pain management and post-surgical rehabilitation. Known for comprehensive treatment approaches.',
      expertise: [
        'Manual Therapy',
        'Chronic Pain Management',
        'Post-Surgery Rehab',
        'Soft Tissue Mobilization',
        'Joint Manipulation',
      ],
      languages: ['Bengali', 'English', 'Arabic'],
      consultationFee: 2500,
      isAvailable: true,
      nextAvailable: 'Tomorrow, 11:00 AM',
      workingDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Sat'],
      workingHours: '9:00 AM - 6:00 PM',
      certifications: [
        'Certified Manual Therapist',
        'Pain Management Specialist',
        'Mulligan Concept Practitioner',
      ],
    ),
  ];

  List<Physio> get _filteredPhysios {
    List<Physio> filtered = _physios;

    // Apply filter
    if (_selectedFilter == 'Available Now') {
      filtered = filtered.where((physio) => physio.isAvailable).toList();
    } else if (_selectedFilter == 'Experienced') {
      filtered = filtered.where((physio) => physio.experience >= 10).toList();
    } else if (_selectedFilter == 'Budget Friendly') {
      filtered = filtered
          .where((physio) => physio.consultationFee <= 2000)
          .toList();
    }

    // Apply search
    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where(
            (physio) =>
                physio.name.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                physio.specialization.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                physio.location.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ),
          )
          .toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 120,
          floating: false,
          pinned: true,
          backgroundColor: const Color(0xFF1a2332),
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'Consult a Physio',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1a2332), AppColors.accentBlue],
                ),
              ),
            ),
          ),
        ),

        // Search and Filter
        SliverToBoxAdapter(
          child: Container(
            color: const Color(0xFF1a2332),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search by name, specialization, location...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.accentBlue,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Available Now'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Experienced'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Budget Friendly'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Info Banner
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.accentBlue],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.medical_services,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expert Cricket Physiotherapists',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Get professional treatment for sports injuries',
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Results Count
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${_filteredPhysios.length} Physiotherapists Available',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // Physio List - Responsive Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              // Calculate number of columns based on screen width
              int crossAxisCount = 1; // Default for mobile
              if (constraints.crossAxisExtent > 1200) {
                crossAxisCount = 3; // Desktop - 3 columns
              } else if (constraints.crossAxisExtent > 800) {
                crossAxisCount = 2; // Tablet - 2 columns
              }

              // Use list for mobile, grid for larger screens
              if (crossAxisCount == 1) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final physio = _filteredPhysios[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildPhysioCard(physio),
                    );
                  }, childCount: _filteredPhysios.length),
                );
              } else {
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final physio = _filteredPhysios[index];
                    return _buildPhysioCard(physio);
                  }, childCount: _filteredPhysios.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.85,
                  ),
                );
              }
            },
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildPhysioCard(Physio physio) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhysioProfilePage(physio: physio),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.accentBlue, AppColors.primaryGreen],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                physio.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (physio.isAvailable)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryGreen,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Available',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          physio.qualification,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          physio.specialization,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.accentBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              physio.rating.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${physio.reviewCount})',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.work, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${physio.experience} yrs',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Location and Clinic
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.primaryOrange,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${physio.clinic}, ${physio.location}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Expertise Tags
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: physio.expertise.take(3).map((exp) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      exp,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentBlue,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Next Available and Fee
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Available',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            physio.nextAvailable,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Consultation Fee',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '৳${physio.consultationFee.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // View Profile Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhysioProfilePage(physio: physio),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View Profile & Book',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
