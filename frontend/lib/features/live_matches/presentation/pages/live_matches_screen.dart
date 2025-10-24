import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LiveMatchesScreen extends StatefulWidget {
  const LiveMatchesScreen({super.key});

  @override
  State<LiveMatchesScreen> createState() => _LiveMatchesScreenState();
}

class _LiveMatchesScreenState extends State<LiveMatchesScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'International', 'Domestic', 'Local'];

  final List<Map<String, dynamic>> _liveMatches = [
    {
      'matchType': 'International',
      'tournament': 'ICC Cricket World Cup 2023',
      'team1': 'Bangladesh',
      'team1Short': 'BAN',
      'team1Score': '287/6',
      'team1Overs': '47.2',
      'team2': 'India',
      'team2Short': 'IND',
      'team2Score': '156/3',
      'team2Overs': '28.0',
      'status': 'Live - IND need 132 runs',
      'venue': 'Mirpur, Dhaka',
      'isLive': true,
      'currentBatsmen': ['Virat Kohli 78*', 'KL Rahul 42*'],
      'currentBowler': 'Mustafizur Rahman 2/31',
      'recentBalls': ['4', '1', '0', '6', '2', '0'],
    },
    {
      'matchType': 'Domestic',
      'tournament': 'Bangladesh Premier League',
      'team1': 'Dhaka Dynamites',
      'team1Short': 'DD',
      'team1Score': '178/8',
      'team1Overs': '20.0',
      'team2': 'Chittagong Vikings',
      'team2Short': 'CV',
      'team2Score': '124/5',
      'team2Overs': '15.0',
      'status': 'Live - CV need 55 runs in 30 balls',
      'venue': 'Sher-e-Bangla Stadium',
      'isLive': true,
      'currentBatsmen': ['Sabbir Rahman 38*', 'Mahmudullah 22*'],
      'currentBowler': 'Shakib Al Hasan 1/28',
      'recentBalls': ['1', '4', '0', '1', '2', 'W'],
    },
    {
      'matchType': 'International',
      'tournament': 'Asia Cup T20 2024',
      'team1': 'Pakistan',
      'team1Short': 'PAK',
      'team1Score': '195/4',
      'team1Overs': '20.0',
      'team2': 'Sri Lanka',
      'team2Short': 'SL',
      'team2Score': '89/2',
      'team2Overs': '10.2',
      'status': 'Live - SL need 107 runs',
      'venue': 'Dubai International Stadium',
      'isLive': true,
      'currentBatsmen': ['Pathum Nissanka 45*', 'Kusal Mendis 28*'],
      'currentBowler': 'Shadab Khan 0/18',
      'recentBalls': ['6', '0', '1', '4', '1', '2'],
    },
    {
      'matchType': 'Local',
      'tournament': 'Dhaka Division League',
      'team1': 'Mirpur Warriors',
      'team1Short': 'MW',
      'team1Score': '245/9',
      'team1Overs': '50.0',
      'team2': 'Uttara Strikers',
      'team2Short': 'US',
      'team2Score': '178/6',
      'team2Overs': '38.4',
      'status': 'Live - US need 68 runs',
      'venue': 'BKSP Ground 2',
      'isLive': true,
      'currentBatsmen': ['Tanvir Ahmed 56*', 'Rubel Hossain 12*'],
      'currentBowler': 'Arafat Sunny 2/35',
      'recentBalls': ['0', '1', '1', '0', '2', '4'],
    },
    {
      'matchType': 'Domestic',
      'tournament': 'National Cricket League',
      'team1': 'Rajshahi Division',
      'team1Short': 'RAJ',
      'team1Score': '312/7',
      'team1Overs': '85.0',
      'team2': 'Khulna Division',
      'team2Short': 'KHU',
      'team2Score': '156/4',
      'team2Overs': '42.0',
      'status': 'Live - Day 2, 1st Session',
      'venue': 'Rajshahi Stadium',
      'isLive': true,
      'currentBatsmen': ['Mehidy Hasan 67*', 'Nurul Hasan 34*'],
      'currentBowler': 'Taijul Islam 1/48',
      'recentBalls': ['0', '0', '1', '0', '0', '4'],
    },
    {
      'matchType': 'International',
      'tournament': 'Women\'s T20 World Cup',
      'team1': 'Bangladesh Women',
      'team1Short': 'BAN-W',
      'team1Score': '142/6',
      'team1Overs': '20.0',
      'team2': 'Australia Women',
      'team2Short': 'AUS-W',
      'team2Score': '98/1',
      'team2Overs': '12.3',
      'status': 'Live - AUS-W need 45 runs',
      'venue': 'Cape Town',
      'isLive': true,
      'currentBatsmen': ['Alyssa Healy 52*', 'Beth Mooney 38*'],
      'currentBowler': 'Nahida Akter 1/22',
      'recentBalls': ['4', '1', '0', '1', '6', '0'],
    },
  ];

  List<Map<String, dynamic>> get _filteredMatches {
    if (_selectedFilter == 'All') return _liveMatches;
    return _liveMatches
        .where((match) => match['matchType'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.accentBlue],
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
                        Icons.sports_cricket,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            '${_filteredMatches.length} matches in progress',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Live Indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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
        ),

        // Filter Chips
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  final count = filter == 'All'
                      ? _liveMatches.length
                      : _liveMatches
                            .where((m) => m['matchType'] == filter)
                            .length;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text('$filter ($count)'),
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: AppColors.primaryGreen,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primaryGreen
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

        // Live Matches List - Responsive Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              // Calculate number of columns based on screen width
              // Using 2 columns max for matches since they're larger cards
              int crossAxisCount = 1; // Default for mobile
              if (constraints.crossAxisExtent > 900) {
                crossAxisCount = 2; // Desktop/Tablet - 2 columns
              }

              // Use list for mobile, grid for larger screens
              if (crossAxisCount == 1) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final match = _filteredMatches[index];
                    return _buildMatchCard(match);
                  }, childCount: _filteredMatches.length),
                );
              } else {
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final match = _filteredMatches[index];
                    return _buildMatchCard(match);
                  }, childCount: _filteredMatches.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                );
              }
            },
          ),
        ),

        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }

  Widget _buildMatchCard(Map<String, dynamic> match) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        children: [
          // Match Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getMatchTypeColor(match['matchType']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    match['matchType'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    match['tournament'],
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          // Teams and Scores
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Team 1
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          match['team1Short'],
                          style: TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        match['team1'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      match['team1Score'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${match['team1Overs']})',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Team 2
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          match['team2Short'],
                          style: TextStyle(
                            color: AppColors.accentBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        match['team2'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      match['team2Score'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${match['team2Overs']})',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Match Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withValues(alpha: 0.1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.sports_cricket,
                  size: 16,
                  color: AppColors.primaryOrange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    match['status'],
                    style: TextStyle(
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Current Play Info
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Play',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Batting',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...match['currentBatsmen'].map<Widget>((batsman) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                batsman,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bowling',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          match['currentBowler'],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Recent Balls
                Text(
                  'Recent Balls',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: match['recentBalls']
                      .map<Widget>((ball) => _buildBallIndicator(ball))
                      .toList(),
                ),
              ],
            ),
          ),

          // Venue and Actions
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
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    match['venue'],
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/match/detail');
                  },
                  icon: const Icon(Icons.play_circle_outline, size: 18),
                  label: const Text('Watch Live'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBallIndicator(String ball) {
    Color backgroundColor;
    Color textColor = Colors.white;

    if (ball == '4') {
      backgroundColor = AppColors.accentBlue;
    } else if (ball == '6') {
      backgroundColor = AppColors.primaryOrange;
    } else if (ball == 'W') {
      backgroundColor = Colors.red;
    } else {
      backgroundColor = Colors.grey.shade300;
      textColor = AppColors.textPrimary;
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 32,
      height: 32,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          ball,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Color _getMatchTypeColor(String type) {
    switch (type) {
      case 'International':
        return AppColors.primaryGreen;
      case 'Domestic':
        return AppColors.accentBlue;
      case 'Local':
        return AppColors.primaryOrange;
      default:
        return Colors.grey;
    }
  }
}
