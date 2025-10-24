import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'tournament_detail_screen.dart';

class TournamentsScreen extends StatefulWidget {
  const TournamentsScreen({super.key});

  @override
  State<TournamentsScreen> createState() => _TournamentsScreenState();
}

class _TournamentsScreenState extends State<TournamentsScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _filters = ['All', 'Open', 'Ongoing', 'Completed'];

  final List<Map<String, dynamic>> _tournaments = [
    {
      'name': 'Dhaka Premier League 2024',
      'type': 'List A',
      'status': 'Ongoing',
      'startDate': 'Oct 15, 2024',
      'endDate': 'Dec 20, 2024',
      'location': 'Dhaka, Bangladesh',
      'teams': 12,
      'entryFee': 50000,
      'prizePool': 5000000,
      'format': '50 Overs',
      'matchesPlayed': 28,
      'totalMatches': 66,
      'organizer': 'Bangladesh Cricket Board',
      'ageGroup': 'Open',
      'registrationDeadline': null,
    },
    {
      'name': 'Corporate Cricket Championship',
      'type': 'T20',
      'status': 'Open',
      'startDate': 'Nov 1, 2024',
      'endDate': 'Nov 15, 2024',
      'location': 'Mirpur, Dhaka',
      'teams': 8,
      'entryFee': 25000,
      'prizePool': 500000,
      'format': '20 Overs',
      'matchesPlayed': 0,
      'totalMatches': 15,
      'organizer': 'Dhaka Sports Association',
      'ageGroup': 'Open',
      'registrationDeadline': 'Oct 28, 2024',
    },
    {
      'name': 'Bangladesh Premier League 2024',
      'type': 'T20',
      'status': 'Open',
      'startDate': 'Nov 20, 2024',
      'endDate': 'Dec 31, 2024',
      'location': 'Multiple Venues',
      'teams': 7,
      'entryFee': 150000,
      'prizePool': 20000000,
      'format': '20 Overs',
      'matchesPlayed': 0,
      'totalMatches': 46,
      'organizer': 'Bangladesh Cricket Board',
      'ageGroup': 'Professional',
      'registrationDeadline': 'Nov 5, 2024',
    },
    {
      'name': 'U-19 District Championship',
      'type': 'Limited Overs',
      'status': 'Open',
      'startDate': 'Oct 25, 2024',
      'endDate': 'Nov 10, 2024',
      'location': 'Chittagong',
      'teams': 16,
      'entryFee': 10000,
      'prizePool': 300000,
      'format': '40 Overs',
      'matchesPlayed': 0,
      'totalMatches': 30,
      'organizer': 'Chittagong Cricket Association',
      'ageGroup': 'Under 19',
      'registrationDeadline': 'Oct 23, 2024',
    },
    {
      'name': 'National Cricket League',
      'type': 'First Class',
      'status': 'Ongoing',
      'startDate': 'Sep 10, 2024',
      'endDate': 'Dec 25, 2024',
      'location': 'Nationwide',
      'teams': 8,
      'entryFee': 75000,
      'prizePool': 3000000,
      'format': '4-Day',
      'matchesPlayed': 18,
      'totalMatches': 28,
      'organizer': 'Bangladesh Cricket Board',
      'ageGroup': 'Open',
      'registrationDeadline': null,
    },
    {
      'name': 'Sylhet Summer T20 League',
      'type': 'T20',
      'status': 'Completed',
      'startDate': 'Aug 1, 2024',
      'endDate': 'Aug 20, 2024',
      'location': 'Sylhet',
      'teams': 10,
      'entryFee': 15000,
      'prizePool': 400000,
      'format': '20 Overs',
      'matchesPlayed': 23,
      'totalMatches': 23,
      'organizer': 'Sylhet Division Sports Council',
      'ageGroup': 'Open',
      'registrationDeadline': null,
      'winner': 'Sylhet Strikers',
    },
    {
      'name': 'Women\'s T20 Challenge',
      'type': 'T20',
      'status': 'Open',
      'startDate': 'Nov 5, 2024',
      'endDate': 'Nov 12, 2024',
      'location': 'Dhaka',
      'teams': 6,
      'entryFee': 12000,
      'prizePool': 250000,
      'format': '20 Overs',
      'matchesPlayed': 0,
      'totalMatches': 10,
      'organizer': 'Bangladesh Women\'s Cricket',
      'ageGroup': 'Women',
      'registrationDeadline': 'Oct 30, 2024',
    },
    {
      'name': 'Rajshahi Division League',
      'type': 'Limited Overs',
      'status': 'Ongoing',
      'startDate': 'Oct 1, 2024',
      'endDate': 'Oct 31, 2024',
      'location': 'Rajshahi',
      'teams': 8,
      'entryFee': 20000,
      'prizePool': 600000,
      'format': '45 Overs',
      'matchesPlayed': 12,
      'totalMatches': 20,
      'organizer': 'Rajshahi Sports Authority',
      'ageGroup': 'Open',
      'registrationDeadline': null,
    },
  ];

  List<Map<String, dynamic>> get _filteredTournaments {
    var filtered = _tournaments;

    // Filter by status
    if (_selectedFilter != 'All') {
      filtered = filtered.where((t) => t['status'] == _selectedFilter).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) {
        return t['name'].toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            t['location'].toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            t['organizer'].toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryOrange, AppColors.warning],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cricket Tournaments',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getTitle1(context),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: ResponsiveHelper.getSpacing(
                              context,
                              size: 'small',
                            ),
                          ),
                          Text(
                            'Find and join competitive cricket events',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getBody(context),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: ResponsiveHelper.getSpacing(context, size: 'large'),
                ),
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search tournaments...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getBorderRadius(
                          context,
                          size: 'medium',
                        ),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Filter Chips
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getValue(
                context,
                mobile: 24,
                tablet: 28,
                desktop: 32,
              ),
              vertical: ResponsiveHelper.getValue(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  final count = filter == 'All'
                      ? _tournaments.length
                      : _tournaments.where((t) => t['status'] == filter).length;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: ResponsiveHelper.getSpacing(
                        context,
                        size: 'medium',
                      ),
                    ),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text('$filter ($count)'),
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: AppColors.primaryOrange,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: ResponsiveHelper.getBody(context),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.getBorderRadius(
                            context,
                            size: 'large',
                          ),
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primaryOrange
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        // Tournaments List - Responsive Grid
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getValue(
              context,
              mobile: 24,
              tablet: 28,
              desktop: 32,
            ),
          ),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              // Calculate number of columns based on screen width
              // Using 2 columns max for tournaments since they're larger cards
              int crossAxisCount = 1; // Default for mobile
              if (constraints.crossAxisExtent > 900) {
                crossAxisCount = 2; // Desktop/Tablet - 2 columns
              }

              // Use list for mobile, grid for larger screens
              if (crossAxisCount == 1) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final tournament = _filteredTournaments[index];
                    return _buildTournamentCard(tournament);
                  }, childCount: _filteredTournaments.length),
                );
              } else {
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final tournament = _filteredTournaments[index];
                    return _buildTournamentCard(tournament);
                  }, childCount: _filteredTournaments.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: ResponsiveHelper.getSpacing(
                      context,
                      size: 'medium',
                    ),
                    crossAxisSpacing: ResponsiveHelper.getSpacing(
                      context,
                      size: 'medium',
                    ),
                    childAspectRatio: 0.8,
                  ),
                );
              }
            },
          ),
        ),

        SliverPadding(
          padding: EdgeInsets.only(
            bottom: ResponsiveHelper.getValue(
              context,
              mobile: 24,
              tablet: 28,
              desktop: 32,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTournamentCard(Map<String, dynamic> tournament) {
    final status = tournament['status'];
    final statusColor = _getStatusColor(status);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TournamentDetailScreen(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: ResponsiveHelper.getSpacing(context, size: 'medium'),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getBorderRadius(context, size: 'medium'),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(
                ResponsiveHelper.getValue(
                  context,
                  mobile: 20,
                  tablet: 22,
                  desktop: 24,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      ResponsiveHelper.getValue(
                        context,
                        mobile: 12,
                        tablet: 14,
                        desktop: 16,
                      ),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          statusColor,
                          statusColor.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getBorderRadius(
                          context,
                          size: 'medium',
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: ResponsiveHelper.getIconSize(
                        context,
                        size: 'medium',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getSpacing(context, size: 'medium'),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                tournament['name'],
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getHeadline(
                                    context,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.getValue(
                                  context,
                                  mobile: 12,
                                  tablet: 14,
                                  desktop: 16,
                                ),
                                vertical: ResponsiveHelper.getValue(
                                  context,
                                  mobile: 6,
                                  tablet: 7,
                                  desktop: 8,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.getBorderRadius(
                                    context,
                                    size: 'medium',
                                  ),
                                ),
                                border: Border.all(color: statusColor),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getCaption(
                                    context,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ResponsiveHelper.getSpacing(
                            context,
                            size: 'small',
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.getValue(
                                  context,
                                  mobile: 10,
                                  tablet: 11,
                                  desktop: 12,
                                ),
                                vertical: ResponsiveHelper.getValue(
                                  context,
                                  mobile: 4,
                                  tablet: 5,
                                  desktop: 6,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accentBlue.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.getBorderRadius(
                                    context,
                                    size: 'small',
                                  ),
                                ),
                              ),
                              child: Text(
                                tournament['type'],
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getCaption(
                                    context,
                                  ),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accentBlue,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: ResponsiveHelper.getSpacing(
                                context,
                                size: 'small',
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ResponsiveHelper.getValue(
                                  context,
                                  mobile: 10,
                                  tablet: 11,
                                  desktop: 12,
                                ),
                                vertical: ResponsiveHelper.getValue(
                                  context,
                                  mobile: 4,
                                  tablet: 5,
                                  desktop: 6,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveHelper.getBorderRadius(
                                    context,
                                    size: 'small',
                                  ),
                                ),
                              ),
                              child: Text(
                                tournament['format'],
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getCaption(
                                    context,
                                  ),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryGreen,
                                ),
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

            const Divider(height: 1),

            // Tournament Info
            Padding(
              padding: EdgeInsets.all(
                ResponsiveHelper.getValue(
                  context,
                  mobile: 20,
                  tablet: 22,
                  desktop: 24,
                ),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Duration',
                    '${tournament['startDate']} - ${tournament['endDate']}',
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getSpacing(
                      context,
                      size: 'medium',
                    ),
                  ),
                  _buildInfoRow(
                    Icons.location_on,
                    'Location',
                    tournament['location'],
                  ),
                  SizedBox(
                    height: ResponsiveHelper.getSpacing(
                      context,
                      size: 'medium',
                    ),
                  ),
                  _buildInfoRow(
                    Icons.groups,
                    'Teams',
                    '${tournament['teams']} teams',
                  ),
                  if (tournament['registrationDeadline'] != null) ...[
                    SizedBox(
                      height: ResponsiveHelper.getSpacing(
                        context,
                        size: 'medium',
                      ),
                    ),
                    _buildInfoRow(
                      Icons.event_available,
                      'Registration Deadline',
                      tournament['registrationDeadline'],
                      highlight: true,
                    ),
                  ],
                ],
              ),
            ),

            // Progress Bar (for ongoing tournaments)
            if (status == 'Ongoing') ...[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getValue(
                    context,
                    mobile: 20,
                    tablet: 22,
                    desktop: 24,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tournament Progress',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getCaption(context),
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${tournament['matchesPlayed']}/${tournament['totalMatches']} matches',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getCaption(context),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ResponsiveHelper.getSpacing(
                        context,
                        size: 'small',
                      ),
                    ),
                    LinearProgressIndicator(
                      value:
                          tournament['matchesPlayed'] /
                          tournament['totalMatches'],
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ResponsiveHelper.getValue(
                  context,
                  mobile: 20,
                  tablet: 22,
                  desktop: 24,
                ),
              ),
            ],

            // Winner (for completed tournaments)
            if (status == 'Completed' && tournament['winner'] != null) ...[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getValue(
                    context,
                    mobile: 20,
                    tablet: 22,
                    desktop: 24,
                  ),
                ),
                margin: EdgeInsets.only(
                  bottom: ResponsiveHelper.getValue(
                    context,
                    mobile: 20,
                    tablet: 22,
                    desktop: 24,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(
                    ResponsiveHelper.getValue(
                      context,
                      mobile: 16,
                      tablet: 18,
                      desktop: 20,
                    ),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber.withValues(alpha: 0.2),
                        Colors.amber.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getBorderRadius(context, size: 'medium'),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: Colors.amber[700],
                        size: ResponsiveHelper.getIconSize(
                          context,
                          size: 'medium',
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getSpacing(
                          context,
                          size: 'medium',
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Champion',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            tournament['winner'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber[900],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Bottom Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Entry Fee',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '৳${tournament['entryFee'].toString()}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prize Pool',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '৳${tournament['prizePool'].toString()}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TournamentDetailScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: statusColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(status == 'Open' ? 'Register' : 'View Details'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool highlight = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: highlight ? AppColors.primaryOrange : AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w600,
              color: highlight
                  ? AppColors.primaryOrange
                  : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return AppColors.success;
      case 'Ongoing':
        return AppColors.primaryOrange;
      case 'Completed':
        return Colors.grey;
      default:
        return AppColors.textPrimary;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
