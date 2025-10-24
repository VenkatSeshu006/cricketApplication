import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../domain/models/organization.dart';
import 'organization_detail_page.dart';

class OrganizationListPage extends StatefulWidget {
  const OrganizationListPage({super.key});

  @override
  State<OrganizationListPage> createState() => _OrganizationListPageState();
}

class _OrganizationListPageState extends State<OrganizationListPage> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Mock data for organizations
  final List<Organization> _organizations = [
    Organization(
      id: '1',
      name: 'Dhaka Cricket Club',
      type: 'Club',
      location: 'Mirpur, Dhaka',
      address: 'Shere Bangla National Cricket Stadium, Mirpur, Dhaka 1216',
      imageUrl: 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e',
      logoUrl: 'https://images.unsplash.com/photo-1614332625148-c28e41fc4374',
      rating: 4.8,
      reviewCount: 342,
      description:
          'Premier cricket club in Dhaka with over 50 years of history. We nurture talent and promote cricket at all levels with state-of-the-art facilities.',
      established: '1970',
      memberCount: 450,
      presidentName: 'Nazmul Hassan',
      secretaryName: 'Jalal Yunus',
      contactNumber: '+880 1711-123456',
      email: 'info@dhakacricketclub.com',
      website: 'www.dhakacricketclub.com',
      achievements: [
        'National Club Championship Winners 2023',
        '15+ Players in National Team',
        'Division Champions 2022, 2021, 2020',
        'Best Club Award - BCB 2023',
      ],
      teams: ['Men\'s A Team', 'Men\'s B Team', 'U-19 Team', 'Women\'s Team'],
      facilities: [
        'Cricket Ground',
        'Practice Nets',
        'Gym',
        'Clubhouse',
        'Swimming Pool',
      ],
      events: [
        'Inter-Club Tournament',
        'Youth Development Camp',
        'Annual Awards Ceremony',
      ],
      affiliations: ['BCB', 'Dhaka District Cricket Association'],
      acceptingMembers: true,
      membershipFee: 15000,
      membershipBenefits: [
        'Access to all facilities',
        'Professional coaching',
        'Tournament participation',
        'Club merchandise discount',
        'Networking events',
      ],
      membershipRequirements: [
        'Age 15+',
        'Basic cricket skills',
        'Valid ID proof',
        'Recommendation from existing member',
      ],
      activities: [
        'Weekly training sessions',
        'Monthly tournaments',
        'Social gatherings',
      ],
      meetingSchedule: 'Every Saturday 5:00 PM',
      facebookUrl: 'facebook.com/dhakacricketclub',
      instagramUrl: 'instagram.com/dhakacricketclub',
      twitterUrl: 'twitter.com/dhakacricket',
      latitude: 23.7808,
      longitude: 90.4209,
      isVerified: true,
      isActive: true,
      foundingYear: 1970,
    ),
    Organization(
      id: '2',
      name: 'Bangladesh Cricket Association',
      type: 'Association',
      location: 'Gulshan, Dhaka',
      address: 'Plot 15, Road 45, Gulshan 2, Dhaka 1212',
      imageUrl: 'https://images.unsplash.com/photo-1531415074968-036ba1b575da',
      logoUrl: null,
      rating: 4.9,
      reviewCount: 567,
      description:
          'The governing body for cricket in Bangladesh. Organizing tournaments, developing infrastructure, and promoting cricket nationwide.',
      established: '1972',
      memberCount: 1200,
      presidentName: 'Asif Mahmud',
      secretaryName: 'Habibul Bashar',
      contactNumber: '+880 1812-234567',
      email: 'contact@bca.org.bd',
      website: 'www.bca.org.bd',
      achievements: [
        'Organized 500+ tournaments',
        'Developed 50+ cricket grounds',
        'Trained 1000+ coaches',
        'International Recognition - ICC',
      ],
      teams: [
        'National Selection Committee',
        'Development Squad',
        'Women\'s Cricket Division',
      ],
      facilities: [
        'Multiple Cricket Grounds',
        'Training Centers',
        'Administrative Office',
        'Conference Hall',
      ],
      events: [
        'National Championship',
        'Divisional Tournaments',
        'Coaching Certification Programs',
        'Annual General Meeting',
      ],
      affiliations: ['ICC', 'ACC', 'BCB'],
      acceptingMembers: true,
      membershipFee: 5000,
      membershipBenefits: [
        'Voting rights',
        'Tournament participation',
        'Certification programs access',
        'Networking opportunities',
      ],
      membershipRequirements: [
        'Cricket club affiliation',
        'Good standing in cricket community',
        'Application approval',
      ],
      activities: [
        'Tournament organization',
        'Coach training',
        'Infrastructure development',
      ],
      meetingSchedule: 'Monthly - First Sunday 10:00 AM',
      facebookUrl: 'facebook.com/bcaofficial',
      latitude: 23.7937,
      longitude: 90.4066,
      isVerified: true,
      isActive: true,
      foundingYear: 1972,
    ),
    Organization(
      id: '3',
      name: 'Chattogram Cricket League',
      type: 'League',
      location: 'Chattogram',
      address: 'MA Aziz Stadium, Chattogram 4100',
      imageUrl: 'https://images.unsplash.com/photo-1624526267942-ab0ff8a3e972',
      logoUrl: null,
      rating: 4.6,
      reviewCount: 198,
      description:
          'Professional cricket league organizing competitive matches across Chattogram region. Promoting local talent and providing competitive platform.',
      established: '2015',
      memberCount: 280,
      presidentName: 'Mahmudullah Riyad',
      secretaryName: 'Tamim Ahmed',
      contactNumber: '+880 1911-345678',
      email: 'info@chattogramleague.com',
      website: 'www.chattogramleague.com',
      achievements: [
        'Successfully organized 8 seasons',
        '20+ players moved to first-class cricket',
        'Best Regional League Award 2023',
      ],
      teams: [
        'Chattogram Challengers',
        'Port City Warriors',
        'Coastal Strikers',
        'Agrabad United',
      ],
      facilities: ['MA Aziz Stadium', 'Practice Ground', 'Media Center'],
      events: [
        'League Season (March-May)',
        'All-Star Match',
        'Player Auction',
        'Awards Night',
      ],
      affiliations: ['Chattogram District Cricket Association', 'BCB'],
      acceptingMembers: false,
      membershipFee: null,
      membershipBenefits: [],
      membershipRequirements: [],
      activities: [
        'League matches',
        'Player development',
        'Fan engagement events',
      ],
      meetingSchedule: 'Bi-monthly meetings',
      facebookUrl: 'facebook.com/chattogramleague',
      instagramUrl: 'instagram.com/chattogramleague',
      latitude: 22.3569,
      longitude: 91.7832,
      isVerified: true,
      isActive: true,
      foundingYear: 2015,
    ),
    Organization(
      id: '4',
      name: 'Uttara Cricket Association',
      type: 'Association',
      location: 'Uttara, Dhaka',
      address: 'Sector 10, Uttara Model Town, Dhaka 1230',
      imageUrl: 'https://images.unsplash.com/photo-1512719994953-eabf50895df7',
      logoUrl: null,
      rating: 4.7,
      reviewCount: 234,
      description:
          'Community-focused cricket association serving Uttara region. Dedicated to grassroots development and youth cricket programs.',
      established: '2005',
      memberCount: 350,
      presidentName: 'Shakib Rahman',
      secretaryName: 'Mushfiq Hasan',
      contactNumber: '+880 1611-456789',
      email: 'uttaracricket@gmail.com',
      website: null,
      achievements: [
        'Developed 3 cricket grounds',
        'Youth program with 200+ participants',
        'Inter-school tournament organizers',
      ],
      teams: ['Uttara XI', 'U-19 Squad', 'U-15 Squad', 'Women\'s Team'],
      facilities: ['Cricket Ground', 'Practice Nets', 'Community Hall'],
      events: [
        'Uttara Premier League',
        'School Championship',
        'Women\'s Cricket Festival',
      ],
      affiliations: ['Dhaka District Cricket Association'],
      acceptingMembers: true,
      membershipFee: 3000,
      membershipBenefits: [
        'Ground access',
        'Tournament participation',
        'Coaching support',
        'Community events',
      ],
      membershipRequirements: [
        'Uttara resident',
        'Age 12+',
        'Basic cricket knowledge',
      ],
      activities: [
        'Weekend training',
        'Monthly tournaments',
        'School outreach programs',
      ],
      meetingSchedule: 'Every 2nd & 4th Friday 6:00 PM',
      facebookUrl: 'facebook.com/uttaracricket',
      latitude: 23.8759,
      longitude: 90.3795,
      isVerified: true,
      isActive: true,
      foundingYear: 2005,
    ),
    Organization(
      id: '5',
      name: 'Sylhet Cricket Federation',
      type: 'Federation',
      location: 'Sylhet',
      address: 'Sylhet International Cricket Stadium, Sylhet 3100',
      imageUrl: 'https://images.unsplash.com/photo-1589487391730-58f20eb2c308',
      logoUrl: null,
      rating: 4.5,
      reviewCount: 156,
      description:
          'Regional cricket federation overseeing all cricket activities in Sylhet division. Organizing tournaments and developing cricket infrastructure.',
      established: '2010',
      memberCount: 520,
      presidentName: 'Alok Kapali',
      secretaryName: 'Rajin Saleh',
      contactNumber: '+880 1711-567890',
      email: 'info@sylhetcricket.org',
      website: 'www.sylhetcricket.org',
      achievements: [
        'Hosted 10+ international matches',
        'Developed 8 cricket grounds',
        '30+ players in national squad',
        'Best Federation Award 2022',
      ],
      teams: ['Sylhet Division Team', 'U-23 Team', 'Women\'s Squad'],
      facilities: [
        'International Stadium',
        'Indoor Cricket Academy',
        'Training Center',
        'Player Hostel',
      ],
      events: [
        'Sylhet Premier League',
        'Inter-District Championship',
        'National Team Trials',
        'Coaching Seminars',
      ],
      affiliations: ['BCB', 'Sylhet District Sports Association'],
      acceptingMembers: true,
      membershipFee: 8000,
      membershipBenefits: [
        'Access to all facilities',
        'Professional coaching',
        'Tournament representation',
        'Career development support',
      ],
      membershipRequirements: [
        'Sylhet division resident',
        'Cricket experience',
        'Age 16+',
        'Recommendation letter',
      ],
      activities: [
        'Tournament organization',
        'Player development programs',
        'Umpire training',
      ],
      meetingSchedule: 'Monthly - Last Saturday 4:00 PM',
      facebookUrl: 'facebook.com/sylhetcricket',
      instagramUrl: 'instagram.com/sylhetcricket',
      twitterUrl: 'twitter.com/sylhetcricket',
      latitude: 24.8949,
      longitude: 91.8687,
      isVerified: true,
      isActive: true,
      foundingYear: 2010,
    ),
    Organization(
      id: '6',
      name: 'Dhanmondi Sports Club',
      type: 'Club',
      location: 'Dhanmondi, Dhaka',
      address: 'Road 27, Dhanmondi Residential Area, Dhaka 1209',
      imageUrl: 'https://images.unsplash.com/photo-1595435742656-5272d0b3e4b7',
      logoUrl: null,
      rating: 4.4,
      reviewCount: 187,
      description:
          'Multi-sports club with strong cricket tradition. Offering recreational and competitive cricket for all age groups.',
      established: '1985',
      memberCount: 320,
      presidentName: 'Khaled Mahmud',
      secretaryName: 'Naimur Rahman',
      contactNumber: '+880 1812-678901',
      email: 'info@dhanmondisports.com',
      website: 'www.dhanmondisports.com',
      achievements: [
        'Inter-Club Champions 2023',
        'Veterans Tournament Winners',
        'Best Sports Club Award - Dhaka 2022',
      ],
      teams: ['Senior Team', 'Veterans Team', 'U-17 Team'],
      facilities: [
        'Cricket Ground',
        'Practice Nets',
        'Sports Complex',
        'Restaurant',
      ],
      events: [
        'Annual Cricket Tournament',
        'Inter-Club Matches',
        'Family Sports Day',
      ],
      affiliations: ['Dhaka Sports Council'],
      acceptingMembers: true,
      membershipFee: 12000,
      membershipBenefits: [
        'Full facility access',
        'Coaching sessions',
        'Family membership option',
        'Social events',
        'Restaurant discounts',
      ],
      membershipRequirements: [
        'Age 18+',
        'Application form',
        'Two sponsor members',
        'Interview',
      ],
      activities: [
        'Regular practice sessions',
        'Monthly club matches',
        'Social gatherings',
        'Coaching camps',
      ],
      meetingSchedule: 'Every Thursday 7:00 PM',
      facebookUrl: 'facebook.com/dhanmondisports',
      latitude: 23.7461,
      longitude: 90.3742,
      isVerified: true,
      isActive: true,
      foundingYear: 1985,
    ),
  ];

  List<Organization> get _filteredOrganizations {
    List<Organization> filtered = _organizations;

    // Filter by type
    if (_selectedFilter != 'All') {
      filtered = filtered.where((org) => org.type == _selectedFilter).toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((org) {
        return org.name.toLowerCase().contains(query) ||
            org.location.toLowerCase().contains(query) ||
            org.type.toLowerCase().contains(query) ||
            org.description.toLowerCase().contains(query);
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
          'Cricket Organizations',
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
                        hintText: 'Search organizations, type, or location...',
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
                          _buildFilterChip('Club'),
                          _buildFilterChip('Association'),
                          _buildFilterChip('Federation'),
                          _buildFilterChip('League'),
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
                      '${_filteredOrganizations.length} Organizations Found',
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
                          value: 'members',
                          child: Text('Most Members'),
                        ),
                        const PopupMenuItem(
                          value: 'oldest',
                          child: Text('Oldest First'),
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
              // Organization List
              Expanded(
                child: _filteredOrganizations.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: ResponsiveHelper.getPagePadding(context),
                        itemCount: _filteredOrganizations.length,
                        itemBuilder: (context, index) {
                          return _buildOrganizationCard(
                            _filteredOrganizations[index],
                          );
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

  Widget _buildOrganizationCard(Organization org) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrganizationDetailPage(organization: org),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Organization Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    org.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: AppColors.surfaceColor,
                      child: const Icon(
                        Icons.business,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                if (org.isVerified)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.verified, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'VERIFIED',
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
                      color: _getTypeColor(org.type).withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      org.type.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Organization Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          org.name,
                          style: const TextStyle(
                            fontSize: 18,
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
                              org.rating.toString(),
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
                          org.location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Text(
                        'Est. ${org.established}',
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
                    org.description,
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
                        '${org.memberCount}+ Members',
                      ),
                      const SizedBox(width: 8),
                      _buildStatChip(Icons.sports, '${org.teams.length} Teams'),
                      const SizedBox(width: 8),
                      _buildStatChip(Icons.star, '${org.reviewCount} Reviews'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Leadership
                  if (org.presidentName != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 16,
                          color: AppColors.primaryGreen,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'President: ${org.presidentName}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  // Membership Status
                  if (org.acceptingMembers)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primaryGreen.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.how_to_reg,
                            size: 16,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Accepting New Members',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (org.membershipFee != null) ...[
                            const Spacer(),
                            Text(
                              '৳${org.membershipFee!.toInt()}/year',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
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

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Club':
        return AppColors.primaryGreen;
      case 'Association':
        return Colors.blue;
      case 'Federation':
        return Colors.purple;
      case 'League':
        return Colors.orange;
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_outlined,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No organizations found',
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
