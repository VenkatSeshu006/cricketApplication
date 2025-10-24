import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Leaderboard category selection state
  String _selectedBattingCategory = 'Overall';
  String _selectedBowlingCategory = 'Overall';
  String _selectedFieldingCategory = 'Overall';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
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
                    padding: EdgeInsets.all(
                      ResponsiveHelper.getValue(
                        context,
                        mobile: 12,
                        tablet: 14,
                        desktop: 16,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(
                        ResponsiveHelper.getBorderRadius(
                          context,
                          size: 'medium',
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.people,
                      color: Colors.white,
                      size: ResponsiveHelper.getIconSize(
                        context,
                        size: 'large',
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
                        Text(
                          'Community',
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
                          'Connect, Share & Compete',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getBody(context),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Open create post dialog
                      _showCreatePostDialog();
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                      size: 28,
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
                decoration: InputDecoration(
                  hintText: 'Search posts, challenges...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getBorderRadius(context, size: 'medium'),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ],
          ),
        ),

        // Tabs
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: AppColors.primaryGreen,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primaryGreen,
            tabs: const [
              Tab(text: 'Feed'),
              Tab(text: 'News'),
              Tab(text: 'Challenges'),
              Tab(text: 'Leaderboards'),
              Tab(text: 'Looking For'),
            ],
          ),
        ),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildFeedTab(),
              _buildNewsTab(),
              _buildChallengesTab(),
              _buildLeaderboardsTab(),
              _buildLookingForTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeedTab() {
    return ListView.builder(
      padding: EdgeInsets.all(
        ResponsiveHelper.getValue(context, mobile: 16, tablet: 20, desktop: 24),
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildPostCard(
          authorName: 'Shakib Al Hasan',
          authorRole: 'Professional Player',
          timeAgo: '2 hours ago',
          content:
              'Great practice session today! Working on my spin variations. Who else is training this weekend? 🏏',
          likes: 234,
          comments: 45,
          shares: 12,
        );
      },
    );
  }

  Widget _buildNewsTab() {
    return ListView.builder(
      padding: EdgeInsets.all(
        ResponsiveHelper.getValue(context, mobile: 16, tablet: 20, desktop: 24),
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return _buildNewsCard(
          title: 'Bangladesh Cricket Team Announces Squad for Asia Cup',
          source: 'CricNet News',
          timeAgo: '4 hours ago',
          image: null,
        );
      },
    );
  }

  Widget _buildChallengesTab() {
    return ListView(
      padding: EdgeInsets.all(
        ResponsiveHelper.getValue(context, mobile: 16, tablet: 20, desktop: 24),
      ),
      children: [
        // Active Challenges
        _buildSectionHeader('Your Active Challenges'),
        SizedBox(height: ResponsiveHelper.getSpacing(context, size: 'medium')),
        _buildChallengeCard(
          title: '100 Runs Challenge',
          description: 'Score 100+ runs in next 5 matches',
          participants: 24,
          daysLeft: 12,
          progress: 0.6,
          category: 'Leather Ball',
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, size: 'medium')),

        // Available Challenges
        _buildSectionHeader('Available Challenges'),
        SizedBox(height: ResponsiveHelper.getSpacing(context, size: 'medium')),
        _buildChallengeCard(
          title: '5 Wickets Challenge',
          description: 'Take 5+ wickets in next 3 matches',
          participants: 18,
          daysLeft: 8,
          progress: null,
          category: 'Box Cricket',
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, size: 'medium')),
        _buildChallengeCard(
          title: 'Fielding Master',
          description: 'Make 10 catches in next 7 matches',
          participants: 32,
          daysLeft: 15,
          progress: null,
          category: 'Tennis Ball',
        ),
      ],
    );
  }

  Widget _buildLeaderboardsTab() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: AppColors.primaryGreen,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primaryGreen,
              tabs: [
                Tab(text: 'Batting'),
                Tab(text: 'Bowling'),
                Tab(text: 'Fielding'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildLeaderboardList(
                  type: 'Batting',
                  selectedCategory: _selectedBattingCategory,
                  onCategoryChanged: (category) {
                    setState(() {
                      _selectedBattingCategory = category;
                    });
                  },
                ),
                _buildLeaderboardList(
                  type: 'Bowling',
                  selectedCategory: _selectedBowlingCategory,
                  onCategoryChanged: (category) {
                    setState(() {
                      _selectedBowlingCategory = category;
                    });
                  },
                ),
                _buildLeaderboardList(
                  type: 'Fielding',
                  selectedCategory: _selectedFieldingCategory,
                  onCategoryChanged: (category) {
                    setState(() {
                      _selectedFieldingCategory = category;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList({
    required String type,
    required String selectedCategory,
    required Function(String) onCategoryChanged,
  }) {
    return ListView(
      padding: EdgeInsets.all(
        ResponsiveHelper.getValue(context, mobile: 16, tablet: 20, desktop: 24),
      ),
      children: [
        // Category Filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategoryChip(
                'Overall',
                selectedCategory == 'Overall',
                onCategoryChanged,
              ),
              SizedBox(
                width: ResponsiveHelper.getSpacing(context, size: 'small'),
              ),
              _buildCategoryChip(
                'Leather Ball',
                selectedCategory == 'Leather Ball',
                onCategoryChanged,
              ),
              SizedBox(
                width: ResponsiveHelper.getSpacing(context, size: 'small'),
              ),
              _buildCategoryChip(
                'Tennis Ball',
                selectedCategory == 'Tennis Ball',
                onCategoryChanged,
              ),
              SizedBox(
                width: ResponsiveHelper.getSpacing(context, size: 'small'),
              ),
              _buildCategoryChip(
                'Box Cricket',
                selectedCategory == 'Box Cricket',
                onCategoryChanged,
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, size: 'large')),

        // Category info header
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
            color: AppColors.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(
              ResponsiveHelper.getBorderRadius(context, size: 'medium'),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primaryGreen,
                size: ResponsiveHelper.getIconSize(context, size: 'small'),
              ),
              SizedBox(
                width: ResponsiveHelper.getSpacing(context, size: 'small'),
              ),
              Expanded(
                child: Text(
                  'Showing $type leaderboard for $selectedCategory',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getCaption(context),
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context, size: 'large')),

        // Leaderboard entries
        ...List.generate(10, (index) {
          // Generate different stats based on category
          String stats;
          int points;

          if (selectedCategory == 'Overall') {
            stats = type == 'Batting'
                ? '${1250 - (index * 100)} runs'
                : type == 'Bowling'
                ? '${45 - (index * 3)} wickets'
                : '${23 - (index * 2)} catches';
            points = 1250 - (index * 100);
          } else if (selectedCategory == 'Leather Ball') {
            stats = type == 'Batting'
                ? '${980 - (index * 80)} runs'
                : type == 'Bowling'
                ? '${38 - (index * 2)} wickets'
                : '${18 - (index * 1)} catches';
            points = 980 - (index * 80);
          } else if (selectedCategory == 'Tennis Ball') {
            stats = type == 'Batting'
                ? '${1520 - (index * 120)} runs'
                : type == 'Bowling'
                ? '${52 - (index * 4)} wickets'
                : '${28 - (index * 2)} catches';
            points = 1520 - (index * 120);
          } else {
            // Box Cricket
            stats = type == 'Batting'
                ? '${2100 - (index * 150)} runs'
                : type == 'Bowling'
                ? '${65 - (index * 5)} wickets'
                : '${35 - (index * 3)} catches';
            points = 2100 - (index * 150);
          }

          return _buildLeaderboardEntry(
            rank: index + 1,
            name: index == 0
                ? 'Tamim Iqbal'
                : index == 1
                ? 'Mushfiqur Rahim'
                : index == 2
                ? 'Shakib Al Hasan'
                : 'Player ${index + 1}',
            stats: stats,
            points: points,
            isCurrentUser: index == 4,
            category: selectedCategory,
          );
        }),
      ],
    );
  }

  Widget _buildLookingForTab() {
    return ListView.builder(
      padding: EdgeInsets.all(
        ResponsiveHelper.getValue(context, mobile: 16, tablet: 20, desktop: 24),
      ),
      itemCount: 15,
      itemBuilder: (context, index) {
        return _buildLookingForCard(
          authorName: 'Cricket Club Dhaka',
          role: 'Club Manager',
          timeAgo: '1 day ago',
          lookingFor: 'Opening Batsman',
          description:
              'Looking for an experienced opening batsman for upcoming tournament. Must have min 2 years experience.',
          location: 'Dhaka, Bangladesh',
          requirements: [
            'Min 2 years experience',
            'Available weekends',
            'Own equipment',
          ],
        );
      },
    );
  }

  Widget _buildPostCard({
    required String authorName,
    required String authorRole,
    required String timeAgo,
    required String content,
    required int likes,
    required int comments,
    required int shares,
  }) {
    return Card(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getSpacing(context, size: 'medium'),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context, size: 'medium'),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveHelper.getValue(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author info
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryGreen,
                  child: Text(
                    authorName[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
                      Text(
                        authorName,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getHeadline(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$authorRole • $timeAgo',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getCaption(context),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ],
            ),
            SizedBox(
              height: ResponsiveHelper.getSpacing(context, size: 'medium'),
            ),

            // Content
            Text(
              content,
              style: TextStyle(fontSize: ResponsiveHelper.getBody(context)),
            ),
            SizedBox(
              height: ResponsiveHelper.getSpacing(context, size: 'medium'),
            ),

            // Actions
            Row(
              children: [
                _buildActionButton(Icons.thumb_up_outlined, '$likes'),
                SizedBox(
                  width: ResponsiveHelper.getSpacing(context, size: 'large'),
                ),
                _buildActionButton(Icons.comment_outlined, '$comments'),
                SizedBox(
                  width: ResponsiveHelper.getSpacing(context, size: 'large'),
                ),
                _buildActionButton(Icons.share_outlined, '$shares'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String source,
    required String timeAgo,
    String? image,
  }) {
    return Card(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getSpacing(context, size: 'medium'),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context, size: 'medium'),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (image != null)
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    ResponsiveHelper.getBorderRadius(context, size: 'medium'),
                  ),
                  topRight: Radius.circular(
                    ResponsiveHelper.getBorderRadius(context, size: 'medium'),
                  ),
                ),
              ),
              child: const Center(child: Icon(Icons.article, size: 48)),
            ),
          Padding(
            padding: EdgeInsets.all(
              ResponsiveHelper.getValue(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getHeadline(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: ResponsiveHelper.getSpacing(context, size: 'small'),
                ),
                Text(
                  '$source • $timeAgo',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getCaption(context),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard({
    required String title,
    required String description,
    required int participants,
    required int daysLeft,
    double? progress,
    required String category,
  }) {
    return Card(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getSpacing(context, size: 'medium'),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context, size: 'medium'),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveHelper.getValue(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getHeadline(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveHelper.getSpacing(
                          context,
                          size: 'small',
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getBody(context),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
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
                    color: AppColors.accentBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      ResponsiveHelper.getBorderRadius(context, size: 'small'),
                    ),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getCaption(context),
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentBlue,
                    ),
                  ),
                ),
              ],
            ),

            if (progress != null) ...[
              SizedBox(
                height: ResponsiveHelper.getSpacing(context, size: 'medium'),
              ),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGreen,
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              SizedBox(
                height: ResponsiveHelper.getSpacing(context, size: 'small'),
              ),
              Text(
                '${(progress * 100).toInt()}% Complete',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getCaption(context),
                  color: AppColors.textSecondary,
                ),
              ),
            ],

            SizedBox(
              height: ResponsiveHelper.getSpacing(context, size: 'medium'),
            ),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: AppColors.textSecondary),
                SizedBox(
                  width: ResponsiveHelper.getSpacing(context, size: 'small'),
                ),
                Text(
                  '$participants participants',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getCaption(context),
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                SizedBox(
                  width: ResponsiveHelper.getSpacing(context, size: 'small'),
                ),
                Text(
                  '$daysLeft days left',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getCaption(context),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            if (progress == null) ...[
              SizedBox(
                height: ResponsiveHelper.getSpacing(context, size: 'medium'),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveHelper.getValue(
                        context,
                        mobile: 12,
                        tablet: 14,
                        desktop: 16,
                      ),
                    ),
                  ),
                  child: const Text('Join Challenge'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardEntry({
    required int rank,
    required String name,
    required String stats,
    required int points,
    bool isCurrentUser = false,
    String? category,
  }) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getSpacing(context, size: 'small'),
      ),
      padding: EdgeInsets.all(
        ResponsiveHelper.getValue(context, mobile: 12, tablet: 14, desktop: 16),
      ),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppColors.primaryGreen.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context, size: 'medium'),
        ),
        border: Border.all(
          color: isCurrentUser
              ? AppColors.primaryGreen
              : AppColors.border.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: rank <= 3 ? Colors.amber : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getHeadline(context),
                  fontWeight: FontWeight.bold,
                  color: rank <= 3 ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context, size: 'medium')),

          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.accentBlue,
            child: Text(
              name[0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: ResponsiveHelper.getSpacing(context, size: 'medium')),

          // Name and stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getBody(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  stats,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getCaption(context),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Points
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$points',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getHeadline(context),
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              Text(
                'points',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getCaption(context),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLookingForCard({
    required String authorName,
    required String role,
    required String timeAgo,
    required String lookingFor,
    required String description,
    required String location,
    required List<String> requirements,
  }) {
    return Card(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.getSpacing(context, size: 'medium'),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context, size: 'medium'),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveHelper.getValue(
            context,
            mobile: 16,
            tablet: 18,
            desktop: 20,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author info
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryOrange,
                  child: Text(
                    authorName[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
                      Text(
                        authorName,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getHeadline(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$role • $timeAgo',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getCaption(context),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ResponsiveHelper.getSpacing(context, size: 'medium'),
            ),

            // Looking for badge
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
                  mobile: 8,
                  tablet: 9,
                  desktop: 10,
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(context, size: 'medium'),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.search,
                    color: AppColors.primaryGreen,
                    size: 20,
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getSpacing(context, size: 'small'),
                  ),
                  Text(
                    'Looking for: $lookingFor',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getBody(context),
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ResponsiveHelper.getSpacing(context, size: 'medium'),
            ),

            // Description
            Text(
              description,
              style: TextStyle(fontSize: ResponsiveHelper.getBody(context)),
            ),
            SizedBox(
              height: ResponsiveHelper.getSpacing(context, size: 'medium'),
            ),

            // Location
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                SizedBox(
                  width: ResponsiveHelper.getSpacing(context, size: 'small'),
                ),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getCaption(context),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ResponsiveHelper.getSpacing(context, size: 'medium'),
            ),

            // Requirements
            Wrap(
              spacing: ResponsiveHelper.getSpacing(context, size: 'small'),
              runSpacing: ResponsiveHelper.getSpacing(context, size: 'small'),
              children: requirements
                  .map(
                    (req) => Chip(
                      label: Text(
                        req,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getCaption(context),
                        ),
                      ),
                      backgroundColor: Colors.grey[200],
                    ),
                  )
                  .toList(),
            ),
            SizedBox(
              height: ResponsiveHelper.getSpacing(context, size: 'medium'),
            ),

            // Action button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          SizedBox(width: ResponsiveHelper.getSpacing(context, size: 'small')),
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getCaption(context),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: ResponsiveHelper.getHeadline(context),
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildCategoryChip(
    String label,
    bool isSelected,
    Function(String) onSelected,
  ) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          onSelected(label);
        }
      },
      backgroundColor: Colors.white,
      selectedColor: AppColors.primaryGreen,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontSize: ResponsiveHelper.getCaption(context),
      ),
    );
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Post'),
        content: const TextField(
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Share your thoughts...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Create post logic
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
