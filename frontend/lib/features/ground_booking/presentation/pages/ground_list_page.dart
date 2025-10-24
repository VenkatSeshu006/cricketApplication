import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../domain/models/ground.dart';
import 'ground_detail_page.dart';

class GroundListPage extends StatefulWidget {
  const GroundListPage({super.key});

  @override
  State<GroundListPage> createState() => _GroundListPageState();
}

class _GroundListPageState extends State<GroundListPage> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Dummy data for grounds
  final List<Ground> _grounds = [
    Ground(
      id: '1',
      name: 'Elite Sports Arena',
      location: 'Gulshan, Dhaka',
      address: 'Plot 45, Road 11, Gulshan 1, Dhaka 1212',
      imageUrl: 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e',
      rating: 4.8,
      reviewCount: 245,
      pricePerHour: 3500,
      facilities: ['Floodlights', 'Parking', 'Changing Room', 'Cafeteria'],
      type: 'Turf',
      size: 'Full',
      isAvailable: true,
      latitude: 23.7808,
      longitude: 90.4209,
    ),
    Ground(
      id: '2',
      name: 'Green Field Cricket Ground',
      location: 'Dhanmondi, Dhaka',
      address: 'House 27, Road 8, Dhanmondi, Dhaka 1205',
      imageUrl: 'https://images.unsplash.com/photo-1531415074968-036ba1b575da',
      rating: 4.5,
      reviewCount: 189,
      pricePerHour: 2800,
      facilities: ['Floodlights', 'Parking', 'Changing Room'],
      type: 'Grass',
      size: 'Full',
      isAvailable: true,
      latitude: 23.7461,
      longitude: 90.3742,
    ),
    Ground(
      id: '3',
      name: 'Champions Turf',
      location: 'Banani, Dhaka',
      address: 'Block B, Road 12, Banani, Dhaka 1213',
      imageUrl: 'https://images.unsplash.com/photo-1589487391730-58f20eb2c308',
      rating: 4.7,
      reviewCount: 312,
      pricePerHour: 4000,
      facilities: [
        'Floodlights',
        'Parking',
        'Changing Room',
        'Cafeteria',
        'Scoreboard',
      ],
      type: 'Turf',
      size: 'Full',
      isAvailable: true,
      latitude: 23.7937,
      longitude: 90.4066,
    ),
    Ground(
      id: '4',
      name: 'Mirpur Cricket Complex',
      location: 'Mirpur, Dhaka',
      address: 'Section 2, Mirpur, Dhaka 1216',
      imageUrl: 'https://images.unsplash.com/photo-1624526267942-ab0ff8a3e972',
      rating: 4.6,
      reviewCount: 198,
      pricePerHour: 3200,
      facilities: ['Floodlights', 'Parking', 'Changing Room', 'Practice Nets'],
      type: 'Turf',
      size: 'Full',
      isAvailable: true,
      latitude: 23.8223,
      longitude: 90.3654,
    ),
    Ground(
      id: '5',
      name: 'Victory Ground',
      location: 'Uttara, Dhaka',
      address: 'Sector 7, Uttara, Dhaka 1230',
      imageUrl: 'https://images.unsplash.com/photo-1512719994953-eabf50895df7',
      rating: 4.4,
      reviewCount: 156,
      pricePerHour: 2500,
      facilities: ['Floodlights', 'Parking', 'Changing Room'],
      type: 'Grass',
      size: 'Half',
      isAvailable: true,
      latitude: 23.8759,
      longitude: 90.3795,
    ),
    Ground(
      id: '6',
      name: 'Star Sports Ground',
      location: 'Bashundhara, Dhaka',
      address: 'Block J, Bashundhara R/A, Dhaka 1229',
      imageUrl: 'https://images.unsplash.com/photo-1595435742656-5272d0b3e4b7',
      rating: 4.9,
      reviewCount: 421,
      pricePerHour: 4500,
      facilities: [
        'Floodlights',
        'Parking',
        'Changing Room',
        'Cafeteria',
        'Scoreboard',
        'Practice Nets',
      ],
      type: 'Turf',
      size: 'Full',
      isAvailable: true,
      latitude: 23.8223,
      longitude: 90.4292,
    ),
    Ground(
      id: '7',
      name: 'Box Cricket Arena Gulshan',
      location: 'Gulshan, Dhaka',
      address: 'Road 44, Gulshan 2, Dhaka 1212',
      imageUrl: 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e',
      rating: 4.6,
      reviewCount: 178,
      pricePerHour: 2000,
      facilities: ['Floodlights', 'Parking', 'Changing Room', 'Scoreboard'],
      type: 'Box Cricket',
      size: 'Box',
      isAvailable: true,
      latitude: 23.7925,
      longitude: 90.4078,
    ),
    Ground(
      id: '8',
      name: 'Urban Box Cricket',
      location: 'Banani, Dhaka',
      address: 'Road 27, Banani, Dhaka 1213',
      imageUrl: 'https://images.unsplash.com/photo-1589487391730-58f20eb2c308',
      rating: 4.7,
      reviewCount: 234,
      pricePerHour: 2200,
      facilities: [
        'Floodlights',
        'Parking',
        'Changing Room',
        'Cafeteria',
        'Scoreboard',
      ],
      type: 'Box Cricket',
      size: 'Box',
      isAvailable: true,
      latitude: 23.7945,
      longitude: 90.4042,
    ),
    Ground(
      id: '9',
      name: 'Fast Track Box Arena',
      location: 'Uttara, Dhaka',
      address: 'Sector 10, Uttara, Dhaka 1230',
      imageUrl: 'https://images.unsplash.com/photo-1624526267942-ab0ff8a3e972',
      rating: 4.5,
      reviewCount: 156,
      pricePerHour: 1800,
      facilities: ['Floodlights', 'Parking', 'Changing Room'],
      type: 'Box Cricket',
      size: 'Box',
      isAvailable: true,
      latitude: 23.8756,
      longitude: 90.3988,
    ),
    Ground(
      id: '10',
      name: 'Pro Cricket Nets Dhanmondi',
      location: 'Dhanmondi, Dhaka',
      address: 'Road 15, Dhanmondi, Dhaka 1209',
      imageUrl: 'https://images.unsplash.com/photo-1531415074968-036ba1b575da',
      rating: 4.8,
      reviewCount: 298,
      pricePerHour: 800,
      facilities: [
        'Floodlights',
        'Parking',
        'Changing Room',
        'Bowling Machine',
      ],
      type: 'Net Cricket',
      size: 'Net',
      isAvailable: true,
      latitude: 23.7515,
      longitude: 90.3779,
    ),
    Ground(
      id: '11',
      name: 'Cricket Practice Nets Mirpur',
      location: 'Mirpur, Dhaka',
      address: 'Section 6, Mirpur, Dhaka 1216',
      imageUrl: 'https://images.unsplash.com/photo-1512719994953-eabf50895df7',
      rating: 4.6,
      reviewCount: 187,
      pricePerHour: 600,
      facilities: ['Floodlights', 'Parking', 'Bowling Machine'],
      type: 'Net Cricket',
      size: 'Net',
      isAvailable: true,
      latitude: 23.8103,
      longitude: 90.3688,
    ),
    Ground(
      id: '12',
      name: 'Elite Nets Bashundhara',
      location: 'Bashundhara, Dhaka',
      address: 'Block G, Bashundhara R/A, Dhaka 1229',
      imageUrl: 'https://images.unsplash.com/photo-1595435742656-5272d0b3e4b7',
      rating: 4.9,
      reviewCount: 342,
      pricePerHour: 1000,
      facilities: [
        'Floodlights',
        'Parking',
        'Changing Room',
        'Bowling Machine',
        'Video Analysis',
      ],
      type: 'Net Cricket',
      size: 'Net',
      isAvailable: true,
      latitude: 23.8198,
      longitude: 90.4255,
    ),
  ];

  List<Ground> get _filteredGrounds {
    List<Ground> filtered = _grounds;

    // Apply filter
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((ground) => ground.type == _selectedFilter)
          .toList();
    }

    // Apply search
    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where(
            (ground) =>
                ground.name.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                ground.location.toLowerCase().contains(
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
    return RefreshIndicator(
      onRefresh: () async {
        // Capture messenger before async gap
        final messenger = ScaffoldMessenger.of(context);
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          setState(() {});
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Grounds refreshed!'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
      color: AppColors.primaryOrange,
      child: Container(
        color: Colors.grey[50],
        child: CustomScrollView(
          slivers: [
            // Search and Filter Section
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryOrange, AppColors.warning],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
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
                          hintText: 'Search grounds or locations...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.primaryOrange,
                            size: 24,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('All'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Turf'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Grass'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Box Cricket'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Net Cricket'),
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_filteredGrounds.length} Grounds Available',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    // Sort/Filter icon
                    IconButton(
                      icon: const Icon(
                        Icons.tune,
                        color: AppColors.primaryOrange,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Advanced filters coming soon!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Grounds List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final ground = _filteredGrounds[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildGroundCard(ground),
                  );
                }, childCount: _filteredGrounds.length),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.5),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.primaryOrange : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildGroundCard(Ground ground) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroundDetailPage(ground: ground),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.stadium,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                ),
                // Status Badge
                if (ground.isAvailable)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Available',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Type Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ground.type,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: ResponsiveHelper.getCardPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    ground.name,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getTitle2(context),
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(
                    height: ResponsiveHelper.getSpacing(context, size: 'small'),
                  ),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: AppColors.primaryOrange,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          ground.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Rating and Reviews
                  Row(
                    children: [
                      const Icon(Icons.star, size: 18, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        ground.rating.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${ground.reviewCount} reviews)',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ground.size,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentBlue,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Facilities
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ground.facilities.take(3).map((facility) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getFacilityIcon(facility),
                              size: 14,
                              color: AppColors.primaryGreen,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              facility,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Price and Book Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '৳${ground.pricePerHour}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          Text(
                            'per hour',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GroundDetailPage(ground: ground),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Book Now',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
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

  IconData _getFacilityIcon(String facility) {
    switch (facility.toLowerCase()) {
      case 'floodlights':
        return Icons.lightbulb;
      case 'parking':
        return Icons.local_parking;
      case 'changing room':
        return Icons.meeting_room;
      case 'cafeteria':
        return Icons.restaurant;
      case 'scoreboard':
        return Icons.scoreboard;
      case 'practice nets':
        return Icons.sports_cricket;
      case 'bowling machine':
        return Icons.sports_baseball;
      case 'video analysis':
        return Icons.videocam;
      default:
        return Icons.check_circle;
    }
  }
}
