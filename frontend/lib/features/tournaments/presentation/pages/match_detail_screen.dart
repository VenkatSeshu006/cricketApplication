import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class MatchDetailScreen extends StatefulWidget {
  const MatchDetailScreen({super.key});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  int _selectedTab = 0;
  bool _isBookmarked = false;
  int _selectedTeamScorecard = 0; // 0 for BAN, 1 for WI
  bool _isOverallComparison = true; // true for Overall, false for On Venue

  void _shareMatch() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality - Coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked ? 'Match bookmarked!' : 'Bookmark removed'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a2332),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a2332),
        foregroundColor: Colors.white,
        title: const Text(
          'BAN vs WI, 2nd ODI',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: _shareMatch,
            icon: const Icon(Icons.share),
            tooltip: 'Share',
          ),
          IconButton(
            onPressed: _toggleBookmark,
            icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            color: _isBookmarked ? AppColors.primaryOrange : Colors.white,
            tooltip: _isBookmarked ? 'Remove bookmark' : 'Bookmark',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Match Header
          _buildMatchHeader(),

          // Tab Navigation
          SliverToBoxAdapter(child: _buildTabNavigation()),

          // Tab Content
          SliverToBoxAdapter(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildMatchHeader() {
    return SliverToBoxAdapter(
      child: Container(
        color: const Color(0xFF1a2332),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            // Score Display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // West Indies
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            child: const Center(
                              child: Text(
                                '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'WI',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'PP',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '5-1',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        '1.0',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Over Display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Over',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bangladesh
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'BAN',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            child: const Center(
                              child: Text(
                                '🇧🇩',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '213-7',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        '(50.0)',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Match Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.accentBlue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'CRR : 6.00    RRR : 4.27',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'WI need 209 runs in 294 balls',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabNavigation() {
    final tabs = ['Match Info', 'Live', 'Scorecard'];

    return Container(
      color: const Color(0xFF1a2332),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = _selectedTab == index;

          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
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

  Widget _buildTabContent() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(16),
      child: _selectedTab == 0
          ? _buildMatchInfoTab()
          : _selectedTab == 1
          ? _buildLiveTab()
          : _buildScorecardTab(),
    );
  }

  Widget _buildMatchInfoTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Match Details
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: const Center(
                      child: Text('🏏', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '2nd ODI',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'WI vs BAN 2025',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accentBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'BAN won toss, chose to bat',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              _buildInfoRow(
                Icons.calendar_today,
                'Tuesday, 21 October, 1:00 PM',
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                Icons.location_on,
                'Sher-e-Bangla National Stadium, Dhaka',
              ),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.tv, 'FANCODE'),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Team Form
        _buildTeamFormSection(),

        const SizedBox(height: 32),

        // Playing XI
        _buildPlayingXISection(),

        const SizedBox(height: 32),

        // Head to Head
        _buildHeadToHeadSection(),

        const SizedBox(height: 32),

        // Team Comparison
        _buildTeamComparisonSection(),

        const SizedBox(height: 32),

        // Venue Stats
        _buildVenueStatsSection(),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamFormSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            'Team Form',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '(Last 5 matches)',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          _buildTeamFormRow('Bangladesh', '🇧🇩', ['W', 'L', 'L', 'L', 'L']),
          const SizedBox(height: 20),
          _buildTeamFormRow('West Indies', '🏴󠁧󠁢󠁥󠁮󠁧󠁿', [
            'L',
            'W',
            'W',
            'L',
            'L',
          ]),
        ],
      ),
    );
  }

  Widget _buildTeamFormRow(String team, String flag, List<String> form) {
    return Row(
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
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            team,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Row(
          children: form.map((result) {
            return Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: result == 'W' ? AppColors.success : Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  result,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPlayingXISection() {
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
            'Playing XI',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              // Bangladesh
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.accentBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Text('🇧🇩', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 8),
                          Text(
                            'BAN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPlayerItem('S Sarkar', 'All Rounder'),
                    _buildPlayerItem('N H Shanto', 'Batter'),
                    _buildPlayerItem(
                      'M H Miraz(C)',
                      'All Rounder',
                      isCaptain: true,
                    ),
                    _buildPlayerItem('N Hasan(WK)', 'Batter', isWK: true),
                    _buildPlayerItem('N Ahmed', 'All Rounder'),
                    _buildPlayerItem('M Rahman', 'Bowler'),
                  ],
                ),
              ),

              const SizedBox(width: 32),

              // West Indies
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'WI',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPlayerItem('S Hassan', 'All Rounder'),
                    _buildPlayerItem('T Hridoy', 'Batter'),
                    _buildPlayerItem('M I Ankon', 'Batter'),
                    _buildPlayerItem('R Hossain', 'All Rounder'),
                    _buildPlayerItem('T Islam', 'Bowler'),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          ExpansionTile(
            title: const Text(
              'On Bench',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            children: [
              _buildPlayerItem('Additional Player 1', 'All Rounder'),
              _buildPlayerItem('Additional Player 2', 'Batter'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerItem(
    String name,
    String role, {
    bool isCaptain = false,
    bool isWK = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accentBlue, AppColors.primaryGreen],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 24),
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
                    fontWeight: FontWeight.w600,
                    color: isCaptain
                        ? AppColors.primaryOrange
                        : AppColors.textPrimary,
                  ),
                ),
                Text(
                  role,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          if (isCaptain || isWK)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isCaptain
                    ? AppColors.primaryOrange.withValues(alpha: 0.1)
                    : AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isCaptain ? 'C' : 'WK',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: isCaptain ? AppColors.primaryOrange : AppColors.info,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeadToHeadSection() {
    final matches = [
      {
        'team1': 'BAN',
        'score1': '207',
        'overs1': '49.4',
        'result': 'BAN Won',
        'match': '1st ODI, WI vs BAN 2025',
        'team2': 'WI',
        'score2': '39.0',
        'overs2': '133',
      },
      {
        'team1': 'WI',
        'score1': '325/6',
        'overs1': '45.5',
        'result': 'WI Won',
        'match': '3rd ODI, BAN vs WI 2024',
        'team2': 'BAN',
        'score2': '50.0',
        'overs2': '321/5',
      },
      {
        'team1': 'WI',
        'score1': '230/3',
        'overs1': '36.5',
        'result': 'WI Won',
        'match': '2nd ODI, BAN vs WI 2024',
        'team2': 'BAN',
        'score2': '45.5',
        'overs2': '227',
      },
      {
        'team1': 'WI',
        'score1': '295/5',
        'overs1': '47.4',
        'result': 'WI Won',
        'match': '1st ODI, BAN vs WI 2024',
        'team2': 'BAN',
        'score2': '50.0',
        'overs2': '294/6',
      },
    ];

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
            'Head to Head',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '(Last 10 matches)',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          // H2H Score
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🇧🇩', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                const Text(
                  'BAN',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 32),
                const Text(
                  '7',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  '-',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  '3',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 32),
                const Text(
                  'WI',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                const Text('🏴󠁧󠁢󠁥󠁮󠁧󠁿', style: TextStyle(fontSize: 32)),
              ],
            ),
          ),

          const SizedBox(height: 24),

          ...matches.map(
            (match) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildH2HMatchCard(match),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildH2HMatchCard(Map<String, String> match) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Text(
            match['match']!,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      match['team1']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${match['score1']}  ${match['overs1']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: match['result']!.contains('BAN')
                      ? AppColors.success.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  match['result']!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: match['result']!.contains('BAN')
                        ? AppColors.success
                        : Colors.red,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${match['overs2']}  ${match['score2']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      match['team2']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
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

  Widget _buildTeamComparisonSection() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Team Comparison',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isOverallComparison = true;
                      });
                    },
                    child: _buildTabButton('Overall', _isOverallComparison),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isOverallComparison = false;
                      });
                    },
                    child: _buildTabButton('On Venue', !_isOverallComparison),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '(Last 10 matches)',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          // Team Headers
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text('🇧🇩', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    const Text(
                      'BAN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'vs all teams',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'vs all teams',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'WI',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildComparisonRow('10', 'Matches Played', '10'),
          _buildComparisonRow(
            '20%',
            'Win',
            '40%',
            leftColor: Colors.red,
            rightColor: AppColors.success,
          ),
          _buildComparisonRow(
            '201',
            'Avg Score',
            '250',
            leftColor: Colors.red,
            rightColor: AppColors.success,
          ),
          _buildComparisonRow(
            '321',
            'Highest Score',
            '385',
            leftColor: Colors.red,
            rightColor: AppColors.success,
          ),
          _buildComparisonRow(
            '93',
            'Lowest Score',
            '133',
            leftColor: AppColors.success,
            rightColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.accentBlue : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildComparisonRow(
    String leftValue,
    String label,
    String rightValue, {
    Color? leftColor,
    Color? rightColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              leftValue,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: leftColor ?? AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              rightValue,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: rightColor ?? AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVenueStatsSection() {
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
            'Sher-e-Bangla National Stadium, Dhaka',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),

          // Weather
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('☀️', style: TextStyle(fontSize: 48)),
                const SizedBox(width: 20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sher-e-Bangla National Stadium, Dhaka',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '32.2°C',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Hazy sunshine',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.water_drop,
                          size: 16,
                          color: AppColors.accentBlue,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '48% (Humidity)',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.cloud, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        const Text(
                          '1% Chance',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          const Text(
            'Venue Stats',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Donut Chart
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        width: 180,
                        height: 180,
                        child: CircularProgressIndicator(
                          value: 0.53,
                          strokeWidth: 20,
                          backgroundColor: AppColors.success,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '123',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Matches',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 40),

              // Stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Win Bat first',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          '46%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Win Bowl first',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          '47%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildVenueStatRow('Avg 1st Inns', '224'),
                    const SizedBox(height: 12),
                    _buildVenueStatRow('Avg 2st Inns', '190'),
                    const SizedBox(height: 12),
                    _buildVenueStatRow(
                      'Highest Total',
                      '370-4',
                      detail: 'by IND vs BAN',
                    ),
                    const SizedBox(height: 12),
                    _buildVenueStatRow(
                      'Lowest Total',
                      '58-10',
                      detail: 'by WI vs BAN',
                    ),
                    const SizedBox(height: 12),
                    _buildVenueStatRow(
                      'Highest Chased',
                      '330-4',
                      detail: 'by PAK vs IND',
                    ),
                    const SizedBox(height: 12),
                    _buildVenueStatRow(
                      'Lowest Defended',
                      '105-10',
                      detail: 'by BAN vs IND',
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          const Text(
            'Pace vs Spin on Venue',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '(Last 10 matches)',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),

          Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pace',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '44 Wkt',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 0.34,
                        minHeight: 12,
                        backgroundColor: Colors.red.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.success,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Spin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '84 Wkt',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '34%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    'WICKETS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[400],
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Text(
                    '66%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          const Text(
            'Recent Matches on Venue',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          _buildVenueMatchCard(
            'BAN',
            '🇧🇩',
            '207',
            '49.4',
            'BAN Won',
            '1st ODI, WI vs BAN 2025',
            'WI',
            '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
            '39.0',
            '133',
          ),
        ],
      ),
    );
  }

  Widget _buildVenueStatRow(String label, String value, {String? detail}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (detail != null)
          Expanded(
            flex: 2,
            child: Text(
              detail,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }

  Widget _buildVenueMatchCard(
    String team1,
    String flag1,
    String score1,
    String overs1,
    String result,
    String match,
    String team2,
    String flag2,
    String score2,
    String overs2,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          const Text('🇧🇩', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
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
                Text(
                  '$score1  $overs1',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Text(
                  'BAN Won',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  match,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
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
                Text(
                  '$overs2  $score2',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Text('🏴󠁧󠁢󠁥󠁮󠁧󠁿', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildLiveTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ball by Ball Commentary',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),

        // Current Over Summary
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accentBlue, AppColors.primaryGreen],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CURRENT OVER',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'Over 4.5',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildBallIndicator('1', Colors.white),
                  const SizedBox(width: 8),
                  _buildBallIndicator('0', Colors.white70),
                  const SizedBox(width: 8),
                  _buildBallIndicator('4', Colors.greenAccent),
                  const SizedBox(width: 8),
                  _buildBallIndicator('W', Colors.redAccent),
                  const SizedBox(width: 8),
                  _buildBallIndicator('1', Colors.white),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Commentary Timeline
        _buildCommentaryCard(
          '4.5',
          'Nasum Ahmed to Alick Athanaze',
          'SINGLE! Tossed up delivery, driven towards mid-off for a quick single',
          '12/3',
          false,
        ),
        const SizedBox(height: 16),
        _buildCommentaryCard(
          '4.4',
          'Nasum Ahmed to Keacy Carty',
          'WICKET! Huge breakthrough! Carty tries to sweep but gets a top edge, simple catch for the keeper. Bangladesh on top!',
          '11/3',
          true,
        ),
        const SizedBox(height: 16),
        _buildCommentaryCard(
          '4.3',
          'Nasum Ahmed to Keacy Carty',
          'FOUR! Beautiful shot! Fuller ball, Carty dances down the track and lofts it over mid-on for a boundary',
          '11/2',
          false,
        ),
        const SizedBox(height: 16),
        _buildCommentaryCard(
          '4.2',
          'Nasum Ahmed to Keacy Carty',
          'Dot ball. Flighted delivery, defended solidly off the front foot',
          '7/2',
          false,
        ),
        const SizedBox(height: 16),
        _buildCommentaryCard(
          '4.1',
          'Nasum Ahmed to Alick Athanaze',
          'SINGLE! Arm ball, worked away towards square leg for one run',
          '7/2',
          false,
        ),

        const SizedBox(height: 24),

        // End of Over 4
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'END OF OVER 4',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                '6 runs, 1 wicket',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _buildCommentaryCard(
          '3.6',
          'Mehidy Hasan Miraz to Shai Hope',
          'Dot ball. Flighted on off stump, defended watchfully',
          '6/2',
          false,
        ),
        const SizedBox(height: 16),
        _buildCommentaryCard(
          '3.5',
          'Mehidy Hasan Miraz to Shai Hope',
          'TWO RUNS! Swept away fine, fielder cuts it off near the boundary',
          '6/2',
          false,
        ),
        const SizedBox(height: 16),
        _buildCommentaryCard(
          '3.4',
          'Mehidy Hasan Miraz to Shai Hope',
          'WICKET! Huge wicket! Hope tries to go big but miscues it completely, mid-on takes an easy catch',
          '4/2',
          true,
        ),
      ],
    );
  }

  Widget _buildScorecardTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Scorecard',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),

        // Team Score Selector
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedTeamScorecard = 0;
                  });
                },
                child: _buildTeamScoreButton(
                  'BAN',
                  '🇧🇩',
                  '213-7 (50.0)',
                  _selectedTeamScorecard == 0,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedTeamScorecard = 1;
                  });
                },
                child: _buildTeamScoreButton(
                  'WI',
                  '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
                  '5-1 (1.1)',
                  _selectedTeamScorecard == 1,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Batting Section
        Container(
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
                'BATTING',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24),

              // Batting Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Batter',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        'R',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        'B',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        '4s',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        '6s',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        'SR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Show different batsmen based on selected team
              if (_selectedTeamScorecard == 0) ...[
                // Bangladesh Batting
                _buildBatterRow(
                  'Tamim Iqbal',
                  'c Hope b Joseph',
                  '45',
                  '52',
                  '6',
                  '1',
                  '86.54',
                ),
                _buildBatterRow(
                  'Litton Das',
                  'b Alzarri',
                  '32',
                  '41',
                  '4',
                  '0',
                  '78.05',
                ),
                _buildBatterRow(
                  'Najmul Shanto (C)',
                  'c Carty b Motie',
                  '67',
                  '74',
                  '7',
                  '2',
                  '90.54',
                ),
                _buildBatterRow(
                  'Mushfiqur Rahim',
                  'not out',
                  '42',
                  '38',
                  '3',
                  '1',
                  '110.53',
                ),
                _buildBatterRow(
                  'Mahmudullah',
                  'lbw b Hosein',
                  '15',
                  '21',
                  '1',
                  '0',
                  '71.43',
                ),
                _buildBatterRow(
                  'Mehidy Hasan',
                  'c Chase b Joseph',
                  '8',
                  '12',
                  '1',
                  '0',
                  '66.67',
                ),
                _buildBatterRow(
                  'Afif Hossain',
                  'not out',
                  '4',
                  '5',
                  '0',
                  '0',
                  '80.00',
                ),
              ] else ...[
                // West Indies Batting
                _buildBatterRow(
                  'Shai Hope',
                  'Batting',
                  '2',
                  '3',
                  '0',
                  '0',
                  '66.67',
                ),
                _buildBatterRow(
                  'Brandon King',
                  'lbw b Ahmed',
                  '0',
                  '1',
                  '0',
                  '0',
                  '0.00',
                ),
                _buildBatterRow(
                  'Keacy Carty',
                  'Batting',
                  '3',
                  '2',
                  '0',
                  '0',
                  '150.00',
                ),
                _buildBatterRow(
                  'Alick Athanaze',
                  'not out',
                  '0',
                  '0',
                  '0',
                  '0',
                  '0.00',
                ),
              ],

              const SizedBox(height: 16),

              // Extras
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'Extras:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 60),
                    Text(
                      '0',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 60),
                    Text(
                      '(b 0, lb 0, w 0, nb 0, p 0)',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Bowling Section
        Container(
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
                'BOWLING',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24),

              // Bowling Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Bowler',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        'O',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        'M',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        'R',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        'W',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        'ER',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Show different bowlers based on selected team
              if (_selectedTeamScorecard == 0) ...[
                // West Indies Bowling (against Bangladesh)
                _buildBowlerRow(
                  'Alzarri Joseph',
                  '10.0',
                  '1',
                  '48',
                  '2',
                  '4.80',
                ),
                _buildBowlerRow(
                  'Romario Shepherd',
                  '10.0',
                  '0',
                  '52',
                  '0',
                  '5.20',
                ),
                _buildBowlerRow(
                  'Gudakesh Motie',
                  '10.0',
                  '0',
                  '42',
                  '1',
                  '4.20',
                ),
                _buildBowlerRow('Akeal Hosein', '10.0', '1', '35', '1', '3.50'),
                _buildBowlerRow('Roston Chase', '6.0', '0', '24', '0', '4.00'),
                _buildBowlerRow('Keacy Carty', '4.0', '0', '12', '0', '3.00'),
              ] else ...[
                // Bangladesh Bowling (against West Indies)
                _buildBowlerRow('Nasum Ahmed', '1.0', '0', '5', '1', '5.00'),
                _buildBowlerRow(
                  'Mehidy Hasan Miraz (C)',
                  '0.1',
                  '0',
                  '0',
                  '0',
                  '0.00',
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Fall of Wickets
        Container(
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
                'FALL OF WICKETS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Batsman',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Score',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Overs',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Dynamic Fall of Wickets based on selected team
              if (_selectedTeamScorecard == 0) ...[
                // Bangladesh Fall of Wickets
                _buildFOWRow('Tamim Iqbal', '45-1', '8.2'),
                _buildFOWRow('Litton Das', '112-2', '18.4'),
                _buildFOWRow('Mahmudullah', '178-3', '28.5'),
                _buildFOWRow('Mehidy Hasan', '201-4', '34.1'),
              ] else ...[
                // West Indies Fall of Wickets
                _buildFOWRow('Brandon King', '1-1', '0.3'),
                _buildFOWRow('Shai Hope', '5-2', '2.1'),
                _buildFOWRow('Keacy Carty', '12-3', '4.5'),
              ],
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Partnership
        Container(
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
                'PARTNERSHIP',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24),

              // Dynamic Partnership based on selected team
              if (_selectedTeamScorecard == 0) ...[
                // Bangladesh Partnerships
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Batter 1',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildPartnershipWicket(
                            '1ST WICKET',
                            'Tamim Iqbal',
                            '45(52)',
                            '45 (60)',
                            '•',
                          ),
                          const SizedBox(height: 24),
                          _buildPartnershipWicket(
                            '2ND WICKET',
                            'Litton Das',
                            '32(38)',
                            '67 (78)',
                            '—',
                          ),
                          const SizedBox(height: 24),
                          _buildPartnershipWicket(
                            '3RD WICKET',
                            'Mahmudullah',
                            '15(24)',
                            '66 (65)',
                            '—',
                          ),
                          const SizedBox(height: 24),
                          _buildPartnershipWicket(
                            '4TH WICKET',
                            'Mehidy Hasan',
                            '8(12)',
                            '23 (32)',
                            '—',
                          ),
                          const SizedBox(height: 24),
                          _buildPartnershipWicket(
                            '5TH WICKET*',
                            'Mushfiqur Rahim',
                            '42(45)',
                            '12 (18)',
                            '•',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Batter 2',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildPartnershipBatter('Litton Das', '32 (38)'),
                          const SizedBox(height: 24),
                          _buildPartnershipBatter('Najmul Shanto', '67 (82)'),
                          const SizedBox(height: 24),
                          _buildPartnershipBatter('Najmul Shanto', '67 (82)'),
                          const SizedBox(height: 24),
                          _buildPartnershipBatter('Najmul Shanto', '67 (82)'),
                          const SizedBox(height: 24),
                          _buildPartnershipBatter('Afif Hossain', '4 (8)'),
                        ],
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // West Indies Partnerships
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Batter 1',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildPartnershipWicket(
                            '1ST WICKET',
                            'Alick Athanaze',
                            '0(2)',
                            '1 (3)',
                            '•',
                          ),
                          const SizedBox(height: 24),
                          _buildPartnershipWicket(
                            '2ND WICKET',
                            'Alick Athanaze',
                            '0(4)',
                            '4 (8)',
                            '—',
                          ),
                          const SizedBox(height: 24),
                          _buildPartnershipWicket(
                            '3RD WICKET*',
                            'Alick Athanaze',
                            '0(6)',
                            '7 (12)',
                            '•',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Batter 2',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildPartnershipBatter('Brandon King', '0 (1)'),
                          const SizedBox(height: 24),
                          _buildPartnershipBatter('Shai Hope', '2 (5)'),
                          const SizedBox(height: 24),
                          _buildPartnershipBatter('Keacy Carty', '3 (6)'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Yet to Bat Sidebar
        Container(
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
                'Yet to bat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              // Dynamic Yet to Bat based on selected team
              if (_selectedTeamScorecard == 0) ...[
                // Bangladesh Yet to Bat
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildYetToBatPlayer('Taskin Ahmed', 'Avg: 8.25'),
                    _buildYetToBatPlayer('Nasum Ahmed', 'Avg: 10.50'),
                    _buildYetToBatPlayer('Mustafizur Rahman', 'Avg: 7.20'),
                  ],
                ),
              ] else ...[
                // West Indies Yet to Bat
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildYetToBatPlayer('A Auguste', 'Avg: 15.33'),
                    _buildYetToBatPlayer('S Rutherford', 'Avg: 53.08'),
                    _buildYetToBatPlayer('R Chase', 'Avg: 27.43'),
                    _buildYetToBatPlayer('J Greaves', 'Avg: 29.73'),
                    _buildYetToBatPlayer('G Motie', 'Avg: 23.93'),
                    _buildYetToBatPlayer('A Hosein', 'Avg: 14.00'),
                    _buildYetToBatPlayer('R Shepherd', 'Avg: 18.50'),
                    _buildYetToBatPlayer('A Joseph', 'Avg: 9.75'),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamScoreButton(
    String team,
    String flag,
    String score,
    bool isSelected,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentBlue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accentBlue : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  team,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                Text(
                  score,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white70
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatterRow(
    String name,
    String status,
    String runs,
    String balls,
    String fours,
    String sixes,
    String sr,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$name player profile - Coming soon!'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              runs,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              balls,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              fours,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              sixes,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              sr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBowlerRow(
    String name,
    String overs,
    String maidens,
    String runs,
    String wickets,
    String er,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$name player profile - Coming soon!'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              overs,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              maidens,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              runs,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              wickets,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              er,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFOWRow(String batsman, String score, String overs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              batsman,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              score,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              overs,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnershipWicket(
    String wicket,
    String name,
    String score,
    String partnership,
    String indicator,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          wicket,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                score,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              partnership,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryOrange,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              indicator,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryOrange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPartnershipBatter(String name, String score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 19), // Align with wicket text
        Text(
          name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          score,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildYetToBatPlayer(String name, String avg) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$name player profile - Coming soon!'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: SizedBox(
        width: 150,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.accentBlue, AppColors.primaryGreen],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    avg,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBallIndicator(String ball, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        border: Border.all(color: color, width: 2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          ball,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildCommentaryCard(
    String over,
    String bowlerBatter,
    String commentary,
    String score,
    bool isWicket,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isWicket ? Colors.red.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWicket ? Colors.red.shade200 : Colors.grey.shade200,
          width: isWicket ? 2 : 1,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isWicket ? Colors.red : AppColors.accentBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  over,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              if (isWicket)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.close, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'WICKET',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                score,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            bowlerBatter,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            commentary,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
