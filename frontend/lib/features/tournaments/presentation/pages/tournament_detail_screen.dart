import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class TournamentDetailScreen extends StatefulWidget {
  const TournamentDetailScreen({super.key});

  @override
  State<TournamentDetailScreen> createState() => _TournamentDetailScreenState();
}

class _TournamentDetailScreenState extends State<TournamentDetailScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a2332),
      body: CustomScrollView(
        slivers: [
          // Tournament Header
          _buildTournamentHeader(),

          // Tab Navigation
          SliverToBoxAdapter(child: _buildTabNavigation()),

          // Main Content
          SliverToBoxAdapter(child: _buildMainContent()),
        ],
      ),
    );
  }

  Widget _buildTournamentHeader() {
    return SliverToBoxAdapter(
      child: Container(
        color: const Color(0xFF1a2332),
        padding: const EdgeInsets.all(40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
              ),
            ),

            const SizedBox(width: 24),

            // Tournament Badge
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/100'),
                  fit: BoxFit.cover,
                  onError: null,
                ),
                color: AppColors.primaryOrange,
              ),
              child: const Center(
                child: Text(
                  "WOMEN'S\nWORLD CUP",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 24),

            // Tournament Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Women's World Cup 2025",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sep 30 - Nov 2',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.accentBlue,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'More Seasons >',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Upcoming Match Card
            Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SA vs PAK 2025',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTeamFlag('🇿🇦', 'SOUTH\nAFRICA'),
                      Text(
                        'VS',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      _buildTeamFlag('🇵🇰', 'PAKISTAN'),
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

  Widget _buildTeamFlag(String flag, String name) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(flag, style: const TextStyle(fontSize: 28)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTabNavigation() {
    final tabs = [
      'Overview',
      'Matches',
      'Squads',
      'Points Table',
      'News',
      'Info',
    ];

    return Container(
      color: const Color(0xFF1a2332),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = _selectedTab == index;

          return Padding(
            padding: const EdgeInsets.only(right: 40),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey[500],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(40),
      child: _buildTabContent(),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0: // Overview
        return _buildOverviewTab();
      case 1: // Matches
        return _buildMatchesTab();
      case 2: // Squads
        return _buildSquadsTab();
      case 3: // Points Table
        return _buildPointsTableTab();
      case 4: // News
        return _buildNewsTab();
      case 5: // Info
        return _buildInfoTab();
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildOverviewTab() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Content Area
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTeamSquadsSection(),
              const SizedBox(height: 40),
              _buildSeriesInfoSection(),
              const SizedBox(height: 40),
              _buildPreviousSeasonsSection(),
              const SizedBox(height: 40),
              _buildFeaturedMatchesSection(),
              const SizedBox(height: 40),
              _buildPointsTableSection(),
            ],
          ),
        ),

        const SizedBox(width: 40),

        // Sidebar
        SizedBox(
          width: 350,
          child: Column(
            children: [
              _buildKeyStatsSection(),
              const SizedBox(height: 32),
              _buildTopHeadlinesSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMatchesTab() {
    final matchesByDate = [
      {
        'date': 'Tuesday, September 30',
        'matches': [
          {
            'match': '1st ODI, Women\'s WC 2025',
            'team1': 'IND-W',
            'flag1': '🇮🇳',
            'score1': '269/8',
            'overs1': '47.0',
            'team2': 'SL-W',
            'flag2': '🇱🇰',
            'score2': '211',
            'overs2': '45.4',
            'result': 'INDW Won',
            'resultDetail': '(DLS Method)',
            'resultColor': AppColors.accentBlue,
          },
        ],
      },
      {
        'date': 'Wednesday, October 1',
        'matches': [
          {
            'match': '2nd ODI, Women\'s WC 2025',
            'team1': 'AUS-W',
            'flag1': '🇦🇺',
            'score1': '326',
            'overs1': '49.3',
            'team2': 'NZ-W',
            'flag2': '🇳🇿',
            'score2': '237',
            'overs2': '43.2',
            'result': 'AUSW Won',
            'resultDetail': 'by 89 runs',
            'resultColor': AppColors.primaryOrange,
          },
        ],
      },
      {
        'date': 'Thursday, October 2',
        'matches': [
          {
            'match': '3rd ODI, Women\'s WC 2025',
            'team1': 'BAN-W',
            'flag1': '🇧🇩',
            'score1': '131/3',
            'overs1': '31.1',
            'team2': 'PAK-W',
            'flag2': '🇵🇰',
            'score2': '129',
            'overs2': '38.3',
            'result': 'BANW Won',
            'resultDetail': 'by 7 wickets',
            'resultColor': AppColors.success,
          },
        ],
      },
      {
        'date': 'Friday, October 3',
        'matches': [
          {
            'match': '4th ODI, Women\'s WC 2025',
            'team1': 'ENG-W',
            'flag1': '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
            'score1': '298/6',
            'overs1': '50.0',
            'team2': 'SA-W',
            'flag2': '🇿🇦',
            'score2': '245',
            'overs2': '48.2',
            'result': 'ENGW Won',
            'resultDetail': 'by 53 runs',
            'resultColor': Colors.red,
          },
        ],
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Women's WC 2025 Matches",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 32),

        ...matchesByDate.map((dateGroup) {
          final date = dateGroup['date'] as String;
          final matches = dateGroup['matches'] as List<Map<String, dynamic>>;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              ...matches.map(
                (match) => Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _buildDetailedMatchCard(match),
                ),
              ),

              const SizedBox(height: 24),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildDetailedMatchCard(Map<String, dynamic> match) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            match['match'],
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              // Team 1
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[100],
                      ),
                      child: Center(
                        child: Text(
                          match['flag1'],
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match['team1'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              match['score1'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              match['overs1'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Result
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: (match['resultColor'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      match['result'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: match['resultColor'] as Color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      match['resultDetail'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              // Team 2
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          match['team2'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              match['overs2'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              match['score2'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[100],
                      ),
                      child: Center(
                        child: Text(
                          match['flag2'],
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSquadsTab() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Team List Sidebar
        Container(
          width: 280,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSquadTeamItem('India Women', '🇮🇳', '15 Players', true),
              _buildSquadTeamItem(
                'England Women',
                '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
                '15 Players',
                false,
              ),
              _buildSquadTeamItem(
                'Bangladesh Women',
                '🇧🇩',
                '15 Players',
                false,
              ),
              _buildSquadTeamItem(
                'Pakistan Women',
                '🇵🇰',
                '15 Players',
                false,
              ),
              _buildSquadTeamItem(
                'South Africa Women',
                '🇿🇦',
                '15 Players',
                false,
              ),
              _buildSquadTeamItem(
                'Australia Women',
                '🇦🇺',
                '15 Players',
                false,
              ),
              _buildSquadTeamItem(
                'New Zealand Women',
                '🇳🇿',
                '15 Players',
                false,
              ),
              _buildSquadTeamItem(
                'Sri Lanka Women',
                '🇱🇰',
                '15 Players',
                false,
              ),
            ],
          ),
        ),

        const SizedBox(width: 32),

        // Squad Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[100],
                    ),
                    child: const Center(
                      child: Text('🇮🇳', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'India Women',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '15 Players',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Batsmen
              _buildSquadRoleSection('Bat (5)', [
                {'name': 'S Mandhana', 'role': 'Batsman'},
                {'name': 'H Deol', 'role': 'Batsman'},
                {'name': 'J Rodrigues', 'role': 'Batsman'},
                {'name': 'R Ghosh (wk)', 'role': 'Batsman'},
                {'name': 'U Chetry (wk)', 'role': 'Batsman'},
              ]),

              const SizedBox(height: 32),

              // Bowlers
              _buildSquadRoleSection('Bowl (5)', [
                {'name': 'N Charani', 'role': 'Bowler'},
                {'name': 'R Yadav', 'role': 'Bowler'},
                {'name': 'K Goud', 'role': 'Bowler'},
                {'name': 'P Vastrakar', 'role': 'Bowler'},
                {'name': 'D Sharma', 'role': 'Bowler'},
              ]),

              const SizedBox(height: 32),

              // All-rounders
              _buildSquadRoleSection('All-rounder (5)', [
                {'name': 'H Kaur (c)', 'role': 'All-rounder'},
                {'name': 'D Hemalatha', 'role': 'All-rounder'},
                {'name': 'R Gaikwad', 'role': 'All-rounder'},
                {'name': 'S Sajana', 'role': 'All-rounder'},
                {'name': 'A Reddy', 'role': 'All-rounder'},
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSquadTeamItem(
    String name,
    String flag,
    String count,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.accentBlue.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.accentBlue : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
            ),
            child: Center(
              child: Text(flag, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? AppColors.accentBlue
                        : AppColors.textPrimary,
                  ),
                ),
                Text(
                  count,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquadRoleSection(
    String title,
    List<Map<String, String>> players,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: players
              .map(
                (player) => _buildPlayerCard(player['name']!, player['role']!),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPlayerCard(String name, String role) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accentBlue, AppColors.primaryGreen],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(role, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildPointsTableTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildPointsTableSection()],
    );
  }

  Widget _buildNewsTab() {
    final newsList = [
      {
        'title':
            '"We\'ve lost three like this": Nigar Sultana admits heartbreak after historic collapse vs SL',
        'time': '2 hrs ago',
        'image': '🏏',
        'category': 'Match Report',
      },
      {
        'title':
            'Alyssa Healy ruled out of World Cup match vs England; Beth Mooney to keep wickets',
        'time': '3 hrs ago',
        'image': '🏏',
        'category': 'Team News',
      },
      {
        'title':
            'What could another World Cup heartbreak mean for Harmanpreet Kaur? Decoding the fate',
        'time': '8 hrs ago',
        'image': '🏏',
        'category': 'Analysis',
      },
      {
        'title':
            'Chamari Athapaththu douses Bangladesh as Sri Lanka Women clinch low-scoring thriller',
        'time': '18 hrs ago',
        'image': '🏏',
        'category': 'Match Report',
      },
      {
        'title':
            '\'Scapegoat\' Smriti Mandhana not the villain of England loss as cricket is not a one-soldier war',
        'time': '18 hrs ago',
        'image': '🏏',
        'category': 'Opinion',
      },
      {
        'title':
            'South Africa Women vs Pakistan Women: Match preview, prediction, and live streaming details',
        'time': '1 day ago',
        'image': '🏏',
        'category': 'Preview',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Women's WC 2025 News",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 32),

        ...newsList.map(
          (news) => Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _buildNewsCard(
              news['title']!,
              news['time']!,
              news['image']!,
              news['category']!,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsCard(
    String title,
    String time,
    String image,
    String category,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(image, style: const TextStyle(fontSize: 48)),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_ios, size: 20),
            style: IconButton.styleFrom(backgroundColor: Colors.grey[100]),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Women's World Cup 2025 - Tournament Information",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 32),

          _buildInfoSection('Tournament Details', [
            _buildInfoRow('Full Name', "ICC Women's Cricket World Cup 2025"),
            _buildInfoRow('Format', 'One Day International (ODI)'),
            _buildInfoRow('Start Date', 'September 30, 2025'),
            _buildInfoRow('End Date', 'November 2, 2025'),
            _buildInfoRow('Total Matches', '31 ODIs'),
            _buildInfoRow('Participating Teams', '8 Teams'),
          ]),

          const SizedBox(height: 40),

          _buildInfoSection('Host Information', [
            _buildInfoRow('Host Country', 'India'),
            _buildInfoRow('Main Venues', 'Multiple stadiums across India'),
            _buildInfoRow(
              'Organizing Body',
              'International Cricket Council (ICC)',
            ),
          ]),

          const SizedBox(height: 40),

          _buildInfoSection('Teams', [
            _buildInfoRow(
              'Group Teams',
              'India, England, Bangladesh, Pakistan, South Africa, Australia, New Zealand, Sri Lanka',
            ),
          ]),

          const SizedBox(height: 40),

          _buildInfoSection('Tournament Format', [
            _buildInfoRow(
              'Stage 1',
              'Round-robin format where all teams play each other',
            ),
            _buildInfoRow('Stage 2', 'Top 4 teams qualify for semi-finals'),
            _buildInfoRow(
              'Finals',
              'Winners of semi-finals compete for the championship',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 20),
        ...items,
      ],
    );
  }

  Widget _buildTeamSquadsSection() {
    final teams = [
      {'name': 'IND-W', 'flag': '🇮🇳', 'color': Colors.orange},
      {'name': 'ENG-W', 'flag': '🏴󠁧󠁢󠁥󠁮󠁧󠁿', 'color': Colors.red},
      {'name': 'BAN-W', 'flag': '🇧🇩', 'color': Colors.green},
      {'name': 'PAK-W', 'flag': '🇵🇰', 'color': Colors.green},
      {'name': 'SA-W', 'flag': '🇿🇦', 'color': Colors.green},
      {'name': 'AUS-W', 'flag': '🇦🇺', 'color': Colors.blue},
      {'name': 'NZ-W', 'flag': '🇳🇿', 'color': Colors.black},
      {'name': 'SL-W', 'flag': '🇱🇰', 'color': Colors.blue},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Team Squads',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            ...teams
                .take(7)
                .map(
                  (team) => Padding(
                    padding: const EdgeInsets.only(right: 32),
                    child: _buildTeamSquadItem(
                      team['name'] as String,
                      team['flag'] as String,
                      team['color'] as Color,
                    ),
                  ),
                ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_ios, size: 20),
              style: IconButton.styleFrom(backgroundColor: Colors.grey[200]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTeamSquadItem(String name, String flag, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: color.withValues(alpha: 0.3), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(flag, style: const TextStyle(fontSize: 32)),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSeriesInfoSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Series Info',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          _buildInfoRow('Series', "Women's World Cup 2025"),
          const SizedBox(height: 16),
          _buildInfoRow('Duration', 'Sep 30 - Nov 02, 2025'),
          const SizedBox(height: 16),
          _buildInfoRow('Format', '31 ODIs'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviousSeasonsSection() {
    final seasons = ["Women's WC 2022", "Women's WC 2017", "Women's WC 2013"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Previous Seasons',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            ...seasons.map(
              (season) => Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    season,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'More Seasons >',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturedMatchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Featured Matches',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'All Matches >',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentBlue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Column(
          children: [
            _buildMatchCard(
              'SA-W',
              '🇿🇦',
              '61 / 2.0',
              'PAK-W',
              '🇵🇰',
              'Yet to bat',
              'Rain Delay',
              Colors.red,
            ),
            const SizedBox(height: 16),
            _buildMatchCard(
              'AUS-W',
              '🇦🇺',
              '',
              'ENG-W',
              '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
              '',
              '23rd ODI on\nOct 22, 3:00 PM',
              Colors.grey[700]!,
            ),
            const SizedBox(height: 16),
            _buildMatchCard(
              'SL-W',
              '🇱🇰',
              '202 / 48.4',
              'BAN-W',
              '🇧🇩',
              '195.9 / 50.0',
              'SLW Won\n21st Women\'s WC 2025',
              AppColors.success,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMatchCard(
    String team1,
    String flag1,
    String score1,
    String team2,
    String flag2,
    String score2,
    String status,
    Color statusColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Team 1
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[100],
                  ),
                  child: Center(
                    child: Text(flag1, style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      team1,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (score1.isNotEmpty)
                      Text(
                        score1,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
            ),
          ),

          // Team 2
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      team2,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (score2.isNotEmpty)
                      Text(
                        score2,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[100],
                  ),
                  child: Center(
                    child: Text(flag2, style: const TextStyle(fontSize: 22)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsTableSection() {
    final teams = [
      {
        'rank': '🥇',
        'flag': '🇦🇺',
        'name': 'Australia Women',
        'p': '5',
        'w': '4',
        'l': '0',
        'nr': '1',
        'cupr': '1.71',
        'nrr': '+1.818',
        'pts': '9',
        'color': AppColors.primaryOrange,
      },
      {
        'rank': '🥇',
        'flag': '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
        'name': 'England Women',
        'p': '5',
        'w': '4',
        'l': '0',
        'nr': '1',
        'cupr': '5.9',
        'nrr': '+1.490',
        'pts': '9',
        'color': AppColors.primaryOrange,
      },
      {
        'rank': '🥇',
        'flag': '🇿🇦',
        'name': 'South Africa Women',
        'p': '5',
        'w': '4',
        'l': '1',
        'nr': '0',
        'cupr': '10.5',
        'nrr': '-0.440',
        'pts': '8',
        'color': AppColors.primaryOrange,
      },
      {
        'rank': '',
        'flag': '🇮🇳',
        'name': 'India Women',
        'p': '5',
        'w': '2',
        'l': '3',
        'nr': '0',
        'cupr': '6.6',
        'nrr': '+0.526',
        'pts': '4',
        'color': Colors.transparent,
      },
      {
        'rank': '',
        'flag': '🇳🇿',
        'name': 'New Zealand Women',
        'p': '5',
        'w': '1',
        'l': '2',
        'nr': '2',
        'cupr': '60',
        'nrr': '-0.245',
        'pts': '4',
        'color': Colors.transparent,
      },
      {
        'rank': '',
        'flag': '🇱🇰',
        'name': 'Sri Lanka Women',
        'p': '6',
        'w': '1',
        'l': '3',
        'nr': '2',
        'cupr': '200',
        'nrr': '-1.035',
        'pts': '4',
        'color': Colors.transparent,
      },
      {
        'rank': '',
        'flag': '🇧🇩',
        'name': 'Bangladesh Women',
        'p': '6',
        'w': '1',
        'l': '5',
        'nr': '0',
        'cupr': '0.00',
        'nrr': '-0.578',
        'pts': '2',
        'color': Colors.transparent,
      },
      {
        'rank': '',
        'flag': '🇵🇰',
        'name': 'Pakistan Women',
        'p': '5',
        'w': '0',
        'l': '3',
        'nr': '2',
        'cupr': '1000',
        'nrr': '-1.887',
        'pts': '2',
        'color': Colors.transparent,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Women's WC 2025 Points Table",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Row(
              children: [
                Text(
                  'Team Form',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 80),
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'Team',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    _buildHeaderCell('P'),
                    _buildHeaderCell('W'),
                    _buildHeaderCell('L'),
                    _buildHeaderCell('NR'),
                    _buildHeaderCell('CupR'),
                    _buildHeaderCell('NRR'),
                    _buildHeaderCell('Pts'),
                  ],
                ),
              ),

              // Teams
              ...teams.map(
                (team) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: team['color'] as Color,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: Text(
                          team['rank'] as String,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[100],
                        ),
                        child: Center(
                          child: Text(
                            team['flag'] as String,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: Text(
                          team['name'] as String,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      _buildDataCell(team['p'] as String),
                      _buildDataCell(team['w'] as String),
                      _buildDataCell(team['l'] as String),
                      _buildDataCell(team['nr'] as String),
                      _buildDataCell(team['cupr'] as String),
                      _buildDataCell(team['nrr'] as String),
                      _buildDataCell(team['pts'] as String, bold: true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return SizedBox(
      width: 70,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildDataCell(String text, {bool bold = false}) {
    return SizedBox(
      width: 70,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildKeyStatsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Stats',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          _buildStatLeader(
            'Most Runs',
            'A Healy',
            'Australia Women',
            '294',
            'Runs',
            AppColors.primaryOrange,
          ),
          const SizedBox(height: 24),
          _buildStatLeader(
            'Most Wickets',
            'D Sharma',
            'India Women',
            '13',
            '',
            AppColors.accentBlue,
          ),
          const SizedBox(height: 24),
          _buildStatLeader(
            'Most Sixes',
            'R Ghosh',
            'India Women',
            '8',
            '',
            AppColors.primaryGreen,
          ),
          const SizedBox(height: 24),
          _buildStatLeader(
            'Best Strike Rate',
            'N D Klerk',
            'South Africa Women',
            '131.91',
            '',
            AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildStatLeader(
    String category,
    String playerName,
    String team,
    String stat,
    String label,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playerName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    team,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  stat,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                if (label.isNotEmpty)
                  Text(
                    label,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopHeadlinesSection() {
    final headlines = [
      {
        'title':
            '"We\'ve lost three like this": Nigar Sultana admits heartbreak after historic collapse vs SL',
        'time': '2 hrs ago',
        'image': '🏏',
      },
      {
        'title':
            'Alyssa Healy ruled out of World Cup match vs England; Beth Mooney to keep wickets',
        'time': '3 hrs ago',
        'image': '🏏',
      },
      {
        'title':
            'What could another World Cup heartbreak mean for Harmanpreet Kaur? Decoding the fate',
        'time': '8 hrs ago',
        'image': '🏏',
      },
      {
        'title':
            'Chamari Athapaththu douses Bangladesh as Sri Lanka Women clinch low-scoring thriller',
        'time': '18 hrs ago',
        'image': '🏏',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top headlines',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'All News >',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ...headlines.map(
            (headline) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        headline['image'] as String,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          headline['title'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          headline['time'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
