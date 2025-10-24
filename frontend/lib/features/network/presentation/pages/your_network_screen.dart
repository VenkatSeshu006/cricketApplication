import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';

class YourNetworkScreen extends StatefulWidget {
  const YourNetworkScreen({super.key});

  @override
  State<YourNetworkScreen> createState() => _YourNetworkScreenState();
}

class _YourNetworkScreenState extends State<YourNetworkScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedRoleFilter = 'All';

  final List<String> _roleFilters = [
    'All',
    'Players',
    'Coaches',
    'Umpires',
    'Organizers',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _connections = [
    {
      'name': 'Shakib Al Hasan',
      'role': 'Player',
      'designation': 'All-rounder',
      'location': 'Dhaka, Bangladesh',
      'mutualConnections': 45,
      'isConnected': true,
      'profileImage': null,
      'bio': 'Professional cricketer, Captain Bangladesh National Team',
    },
    {
      'name': 'Tamim Iqbal',
      'role': 'Player',
      'designation': 'Opening Batsman',
      'location': 'Chittagong, Bangladesh',
      'mutualConnections': 38,
      'isConnected': true,
      'profileImage': null,
      'bio': 'ODI specialist, Former Bangladesh captain',
    },
    {
      'name': 'Chandika Hathurusingha',
      'role': 'Coach',
      'designation': 'Head Coach',
      'location': 'Colombo, Sri Lanka',
      'mutualConnections': 28,
      'isConnected': true,
      'profileImage': null,
      'bio': 'Bangladesh National Team Head Coach',
    },
  ];

  final List<Map<String, dynamic>> _suggestions = [
    {
      'name': 'Mushfiqur Rahim',
      'role': 'Player',
      'designation': 'Wicket-keeper Batsman',
      'location': 'Dhaka, Bangladesh',
      'mutualConnections': 32,
      'isConnected': false,
      'profileImage': null,
      'bio': 'Experienced wicket-keeper, Test specialist',
    },
    {
      'name': 'Mashrafe Mortaza',
      'role': 'Player',
      'designation': 'Fast Bowler',
      'location': 'Narail, Bangladesh',
      'mutualConnections': 41,
      'isConnected': false,
      'profileImage': null,
      'bio': 'Former ODI Captain, Bangladesh legend',
    },
    {
      'name': 'Sohail Tanvir',
      'role': 'Coach',
      'designation': 'Bowling Coach',
      'location': 'Rawalpindi, Pakistan',
      'mutualConnections': 15,
      'isConnected': false,
      'profileImage': null,
      'bio': 'Former Pakistani cricketer, Specialized in T20 coaching',
    },
    {
      'name': 'Sharfuddoula Saikat',
      'role': 'Umpire',
      'designation': 'ICC Panel Umpire',
      'location': 'Dhaka, Bangladesh',
      'mutualConnections': 22,
      'isConnected': false,
      'profileImage': null,
      'bio': 'International umpire, BPL regular',
    },
    {
      'name': 'Nazmul Hassan Papon',
      'role': 'Organizer',
      'designation': 'BCB President',
      'location': 'Dhaka, Bangladesh',
      'mutualConnections': 67,
      'isConnected': false,
      'profileImage': null,
      'bio': 'Bangladesh Cricket Board President',
    },
  ];

  final List<Map<String, dynamic>> _requests = [
    {
      'name': 'Mahmudullah Riyad',
      'role': 'Player',
      'designation': 'All-rounder',
      'location': 'Mymensingh, Bangladesh',
      'mutualConnections': 25,
      'isConnected': false,
      'profileImage': null,
      'bio': 'T20 specialist, Bangladesh veteran',
      'requestDate': 'Oct 20, 2024',
    },
    {
      'name': 'Akram Khan',
      'role': 'Coach',
      'designation': 'Youth Coach',
      'location': 'Khulna, Bangladesh',
      'mutualConnections': 18,
      'isConnected': false,
      'profileImage': null,
      'bio': 'Former Bangladesh captain, U19 coach',
      'requestDate': 'Oct 18, 2024',
    },
  ];

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
                colors: [AppColors.accentBlue, AppColors.primaryGreen],
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
                      width: ResponsiveHelper.getSpacing(
                        context,
                        size: 'medium',
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Network',
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
                            '${_connections.length} connections',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getBody(context),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Pending Requests Badge
                    if (_requests.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.getValue(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 20,
                          ),
                          vertical: ResponsiveHelper.getValue(
                            context,
                            mobile: 8,
                            tablet: 9,
                            desktop: 10,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.getBorderRadius(
                              context,
                              size: 'large',
                            ),
                          ),
                        ),
                        child: Text(
                          '${_requests.length} Requests',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.getCaption(context),
                          ),
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
                    hintText: 'Search your network...',
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

        // Tab Bar
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(24),
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
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.accentBlue,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.accentBlue,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Connections'),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_connections.length}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Suggestions'),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_suggestions.length}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Requests'),
                      const SizedBox(width: 8),
                      if (_requests.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_requests.length}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Tab Content
        SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildConnectionsTab(),
              _buildSuggestionsTab(),
              _buildRequestsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionsTab() {
    return CustomScrollView(
      slivers: [
        // Role Filters
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _roleFilters.map((filter) {
                  final isSelected = _selectedRoleFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(filter),
                      onSelected: (selected) {
                        setState(() {
                          _selectedRoleFilter = filter;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedColor: AppColors.accentBlue,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.accentBlue
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

        // Connections List - Responsive Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                    final connection = _connections[index];
                    return _buildNetworkCard(connection, true);
                  }, childCount: _connections.length),
                );
              } else {
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final connection = _connections[index];
                    return _buildNetworkCard(connection, true);
                  }, childCount: _connections.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionsTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate number of columns based on screen width
        int crossAxisCount = 1; // Default for mobile
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 3; // Desktop - 3 columns
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 2; // Tablet - 2 columns
        }

        if (crossAxisCount == 1) {
          // Mobile layout - use Column with SingleChildScrollView
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: _suggestions.map((suggestion) {
                return _buildNetworkCard(
                  suggestion,
                  false,
                  showConnectButton: true,
                );
              }).toList(),
            ),
          );
        } else {
          // Web/Tablet layout - use GridView
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = _suggestions[index];
              return _buildNetworkCard(
                suggestion,
                false,
                showConnectButton: true,
              );
            },
          );
        }
      },
    );
  }

  Widget _buildRequestsTab() {
    if (_requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No pending requests',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate number of columns based on screen width
        int crossAxisCount = 1; // Default for mobile
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 3; // Desktop - 3 columns
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 2; // Tablet - 2 columns
        }

        if (crossAxisCount == 1) {
          // Mobile layout - use Column with SingleChildScrollView
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: _requests.map((request) {
                return _buildNetworkCard(request, false, isRequest: true);
              }).toList(),
            ),
          );
        } else {
          // Web/Tablet layout - use GridView
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: _requests.length,
            itemBuilder: (context, index) {
              final request = _requests[index];
              return _buildNetworkCard(request, false, isRequest: true);
            },
          );
        }
      },
    );
  }

  Widget _buildNetworkCard(
    Map<String, dynamic> person,
    bool isConnected, {
    bool showConnectButton = false,
    bool isRequest = false,
  }) {
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getRoleColor(person['role']),
                        _getRoleColor(person['role']).withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      person['name'].substring(0, 1),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Person Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        person['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        person['designation'],
                        style: TextStyle(
                          fontSize: 14,
                          color: _getRoleColor(person['role']),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              person['location'],
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${person['mutualConnections']} mutual connections',
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
                // Connection Status Badge
                if (isConnected)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.success),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Connected',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Bio
            Text(
              person['bio'],
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isRequest) ...[
              const SizedBox(height: 8),
              Text(
                'Requested: ${person['requestDate']}',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 16),
            // Action Buttons
            Row(
              children: [
                if (isRequest) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _requests.remove(person);
                          _connections.add(person);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Accepted connection from ${person['name']}',
                            ),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _requests.remove(person);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Declined request from ${person['name']}',
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                ] else if (showConnectButton) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Connection request sent to ${person['name']}',
                            ),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_add, size: 18),
                      label: const Text('Connect'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile viewed')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View'),
                  ),
                ] else ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Message feature coming soon!'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.message, size: 18),
                      label: const Text('Message'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accentBlue,
                        side: BorderSide(color: AppColors.accentBlue),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile viewed')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Player':
        return AppColors.primaryGreen;
      case 'Coach':
        return AppColors.accentBlue;
      case 'Umpire':
        return AppColors.primaryOrange;
      case 'Organizer':
        return Colors.purple;
      default:
        return AppColors.textPrimary;
    }
  }
}
