import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../domain/models/academy.dart';
import 'academy_detail_page.dart';

class AcademyListPage extends StatefulWidget {
  const AcademyListPage({super.key});

  @override
  State<AcademyListPage> createState() => _AcademyListPageState();
}

class _AcademyListPageState extends State<AcademyListPage> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Mock data for academies
  final List<Academy> _academies = [
    Academy(
      id: '1',
      name: 'Elite Cricket Academy',
      location: 'Gulshan, Dhaka',
      address: 'Plot 45, Road 11, Gulshan 1, Dhaka 1212',
      imageUrl: 'https://images.unsplash.com/photo-1531415074968-036ba1b575da',
      rating: 4.9,
      reviewCount: 456,
      description:
          'Premier cricket academy with world-class facilities and experienced coaches. Specialized training programs for all age groups.',
      programs: [
        'Batting',
        'Bowling',
        'Fielding',
        'All-Round',
        'Wicket Keeping',
      ],
      facilities: [
        'Indoor Nets',
        'Outdoor Ground',
        'Gym',
        'Video Analysis',
        'Physio Center',
      ],
      coaches: ['5 Professional Coaches', '2 International Players'],
      established: '2010',
      totalStudents: 350,
      ageGroups: ['U-12', 'U-15', 'U-19', 'Adult'],
      fees: {
        'Batting': 5000,
        'Bowling': 5000,
        'All-Round': 7500,
        'Wicket Keeping': 4500,
      },
      contactNumber: '+880 1711-123456',
      email: 'info@elitecricket.com',
      timing: '6:00 AM - 9:00 PM',
      hasAccommodation: true,
      hasPlayground: true,
      hasCertification: true,
      latitude: 23.7808,
      longitude: 90.4209,
      achievements: [
        '25+ Students in National Team',
        '100+ District Level Players',
        'ICC Level 2 Certified Academy',
      ],
      ownerName: 'Rashid Khan',
    ),
    Academy(
      id: '2',
      name: 'Young Strikers Academy',
      location: 'Dhanmondi, Dhaka',
      address: 'House 27, Road 8, Dhanmondi, Dhaka 1205',
      imageUrl: 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e',
      rating: 4.7,
      reviewCount: 298,
      description:
          'Focus on developing young talent with personalized coaching and modern training methods.',
      programs: ['Batting', 'Bowling', 'Fielding'],
      facilities: ['Outdoor Ground', 'Practice Nets', 'Changing Rooms'],
      coaches: ['3 Professional Coaches'],
      established: '2015',
      totalStudents: 180,
      ageGroups: ['U-12', 'U-15', 'U-19'],
      fees: {'Batting': 3500, 'Bowling': 3500, 'Fielding': 3000},
      contactNumber: '+880 1812-234567',
      email: 'contact@youngstrikers.com',
      timing: '4:00 PM - 8:00 PM',
      hasAccommodation: false,
      hasPlayground: true,
      hasCertification: true,
      latitude: 23.7461,
      longitude: 90.3742,
      achievements: [
        '10+ Division Level Players',
        'U-19 Championship Winners 2023',
      ],
      ownerName: 'Imran Hossain',
    ),
    Academy(
      id: '3',
      name: 'Champions Cricket Institute',
      location: 'Banani, Dhaka',
      address: 'Block C, Road 15, Banani, Dhaka 1213',
      imageUrl: 'https://images.unsplash.com/photo-1624526267942-ab0ff8a3e972',
      rating: 4.8,
      reviewCount: 512,
      description:
          'Professional cricket training institute with emphasis on technique and match preparation.',
      programs: [
        'Batting',
        'Bowling',
        'All-Round',
        'Wicket Keeping',
        'Mental Conditioning',
      ],
      facilities: [
        'Indoor Nets',
        'Outdoor Ground',
        'Gym',
        'Swimming Pool',
        'Sports Psychology Center',
      ],
      coaches: ['6 Professional Coaches', '1 Mental Coach'],
      established: '2008',
      totalStudents: 420,
      ageGroups: ['U-12', 'U-15', 'U-19', 'Adult', 'Professional'],
      fees: {
        'Batting': 6000,
        'Bowling': 6000,
        'All-Round': 9000,
        'Mental Conditioning': 4000,
      },
      contactNumber: '+880 1911-345678',
      email: 'info@championsci.com',
      timing: '5:00 AM - 10:00 PM',
      hasAccommodation: true,
      hasPlayground: true,
      hasCertification: true,
      latitude: 23.7937,
      longitude: 90.4066,
      achievements: [
        '40+ State Level Players',
        '15+ National Team Players',
        'BCB Recognized Academy',
      ],
      ownerName: 'Mashrafe Mortaza',
    ),
    Academy(
      id: '4',
      name: 'Mirpur Cricket Academy',
      location: 'Mirpur, Dhaka',
      address: 'Section 2, Mirpur, Dhaka 1216',
      imageUrl: 'https://images.unsplash.com/photo-1595435742656-5272d0b3e4b7',
      rating: 4.6,
      reviewCount: 234,
      description:
          'Community-focused cricket academy providing affordable training for aspiring cricketers.',
      programs: ['Batting', 'Bowling', 'Fielding', 'All-Round'],
      facilities: ['Outdoor Ground', 'Practice Nets', 'Equipment Store'],
      coaches: ['4 Professional Coaches'],
      established: '2016',
      totalStudents: 220,
      ageGroups: ['U-12', 'U-15', 'U-19', 'Adult'],
      fees: {'Batting': 2500, 'Bowling': 2500, 'All-Round': 4000},
      contactNumber: '+880 1611-456789',
      email: 'mirpurcricket@gmail.com',
      timing: '3:00 PM - 9:00 PM',
      hasAccommodation: false,
      hasPlayground: true,
      hasCertification: false,
      latitude: 23.8223,
      longitude: 90.3654,
      achievements: [
        '5+ District Level Players',
        'Inter-Academy Champions 2024',
      ],
      ownerName: 'Shakib Rahman',
    ),
    Academy(
      id: '5',
      name: 'Future Stars Cricket Academy',
      location: 'Uttara, Dhaka',
      address: 'Sector 7, Uttara, Dhaka 1230',
      imageUrl: 'https://images.unsplash.com/photo-1512719994953-eabf50895df7',
      rating: 4.5,
      reviewCount: 189,
      description:
          'Modern cricket academy with focus on youth development and international standards.',
      programs: ['Batting', 'Bowling', 'All-Round', 'Fitness Training'],
      facilities: ['Indoor Nets', 'Gym', 'Physio Center', 'Video Analysis'],
      coaches: ['3 Professional Coaches', '1 Fitness Trainer'],
      established: '2018',
      totalStudents: 150,
      ageGroups: ['U-12', 'U-15', 'U-19'],
      fees: {
        'Batting': 4000,
        'Bowling': 4000,
        'All-Round': 6000,
        'Fitness Training': 3000,
      },
      contactNumber: '+880 1711-567890',
      email: 'info@futurestars.com',
      timing: '6:00 AM - 8:00 PM',
      hasAccommodation: false,
      hasPlayground: true,
      hasCertification: true,
      latitude: 23.8759,
      longitude: 90.3795,
      achievements: [
        'U-15 Tournament Winners 2024',
        '8+ Division Level Players',
      ],
      ownerName: 'Tamim Iqbal',
    ),
    Academy(
      id: '6',
      name: 'Professional Cricket Training Center',
      location: 'Bashundhara, Dhaka',
      address: 'Block H, Bashundhara R/A, Dhaka 1229',
      imageUrl: 'https://images.unsplash.com/photo-1589487391730-58f20eb2c308',
      rating: 4.9,
      reviewCount: 623,
      description:
          'Elite training center with international coaching staff and state-of-the-art facilities.',
      programs: [
        'Batting',
        'Bowling',
        'All-Round',
        'Wicket Keeping',
        'Fielding',
        'Match Tactics',
      ],
      facilities: [
        'Indoor Nets',
        'Outdoor Ground',
        'Gym',
        'Swimming Pool',
        'Video Analysis',
        'Physio Center',
        'Accommodation',
      ],
      coaches: [
        '8 Professional Coaches',
        '2 International Players',
        '1 Sports Psychologist',
      ],
      established: '2005',
      totalStudents: 500,
      ageGroups: ['U-12', 'U-15', 'U-19', 'Adult', 'Professional'],
      fees: {
        'Batting': 8000,
        'Bowling': 8000,
        'All-Round': 12000,
        'Wicket Keeping': 7000,
        'Match Tactics': 5000,
      },
      contactNumber: '+880 1812-678901',
      email: 'info@pctc.com',
      timing: '24/7 (Residential)',
      hasAccommodation: true,
      hasPlayground: true,
      hasCertification: true,
      latitude: 23.8223,
      longitude: 90.4292,
      achievements: [
        '50+ National Team Players',
        '200+ State Level Players',
        'ICC Recognized Training Center',
        'Best Academy Award 2023',
      ],
      ownerName: 'Mohammad Ashraful',
    ),
  ];

  List<Academy> get _filteredAcademies {
    List<Academy> filtered = _academies;

    // Filter by program
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((academy) => academy.programs.contains(_selectedFilter))
          .toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((academy) {
        return academy.name.toLowerCase().contains(query) ||
            academy.location.toLowerCase().contains(query) ||
            academy.programs.any((p) => p.toLowerCase().contains(query));
      }).toList();
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
    final maxWidth = ResponsiveHelper.getValue(
      context,
      mobile: double.infinity,
      tablet: 900,
      desktop: 1200,
    );

    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        title: const Text(
          'Cricket Academies',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppColors.border.withValues(alpha: 0.3),
            height: 1,
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            children: [
              // Search and Filter Section
              Container(
                color: Colors.white,
                padding: ResponsiveHelper.getPagePadding(context),
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search academies, programs, or location...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.primaryGreen,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.border.withValues(alpha: 0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.border.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryGreen,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All'),
                          _buildFilterChip('Batting'),
                          _buildFilterChip('Bowling'),
                          _buildFilterChip('All-Round'),
                          _buildFilterChip('Wicket Keeping'),
                          _buildFilterChip('Fielding'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Results Header
              Container(
                padding: ResponsiveHelper.getPagePadding(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_filteredAcademies.length} Academies Found',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.sort),
                      onSelected: (value) {
                        // Implement sorting
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'rating',
                          child: Text('Highest Rated'),
                        ),
                        const PopupMenuItem(
                          value: 'reviews',
                          child: Text('Most Reviews'),
                        ),
                        const PopupMenuItem(
                          value: 'students',
                          child: Text('Most Students'),
                        ),
                        const PopupMenuItem(
                          value: 'name',
                          child: Text('Name (A-Z)'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Academy List
              Expanded(
                child: _filteredAcademies.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: ResponsiveHelper.getPagePadding(context),
                        itemCount: _filteredAcademies.length,
                        itemBuilder: (context, index) {
                          return _buildAcademyCard(_filteredAcademies[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = label;
          });
        },
        backgroundColor: Colors.white,
        selectedColor: AppColors.primaryGreen.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primaryGreen,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primaryGreen : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected
              ? AppColors.primaryGreen
              : AppColors.border.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildAcademyCard(Academy academy) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AcademyDetailPage(academy: academy),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Academy Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    academy.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: AppColors.surfaceColor,
                      child: const Icon(
                        Icons.school,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                if (academy.hasCertification)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.verified, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'CERTIFIED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          academy.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Academy Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    academy.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          academy.location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Text(
                        'Est. ${academy.established}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    academy.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Stats Row
                  Row(
                    children: [
                      _buildStatChip(
                        Icons.people,
                        '${academy.totalStudents}+ Students',
                      ),
                      const SizedBox(width: 8),
                      _buildStatChip(
                        Icons.sports,
                        '${academy.programs.length} Programs',
                      ),
                      const SizedBox(width: 8),
                      _buildStatChip(
                        Icons.star,
                        '${academy.reviewCount} Reviews',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Programs
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: academy.programs.take(4).map((program) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.primaryGreen.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Text(
                          program,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  // Features Row
                  Row(
                    children: [
                      if (academy.hasPlayground)
                        _buildFeatureIcon(Icons.sports_cricket, 'Playground'),
                      if (academy.hasAccommodation)
                        _buildFeatureIcon(Icons.hotel, 'Accommodation'),
                      if (academy.facilities.contains('Gym'))
                        _buildFeatureIcon(Icons.fitness_center, 'Gym'),
                      if (academy.facilities.contains('Video Analysis'))
                        _buildFeatureIcon(Icons.videocam, 'Video Analysis'),
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

  Widget _buildStatChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: AppColors.primaryGreen),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No academies found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or filters',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
