import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../domain/models/chat.dart';
import 'chat_detail_page.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({super.key});

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  // Sample contacts
  final List<Contact> _allContacts = [
    Contact(
      id: 'user_1',
      name: 'Shakib Al Hasan',
      role: 'All-rounder',
      avatar: 'https://via.placeholder.com/150',
      isOnline: true,
    ),
    Contact(
      id: 'user_2',
      name: 'Tamim Iqbal',
      role: 'Batsman',
      avatar: 'https://via.placeholder.com/150',
      isOnline: true,
    ),
    Contact(
      id: 'user_3',
      name: 'Mushfiqur Rahim',
      role: 'Wicket-keeper',
      avatar: 'https://via.placeholder.com/150',
      isOnline: false,
    ),
    Contact(
      id: 'user_4',
      name: 'Mashrafe Mortaza',
      role: 'Bowler',
      avatar: 'https://via.placeholder.com/150',
      isOnline: true,
    ),
    Contact(
      id: 'user_5',
      name: 'Mahmudullah Hassan',
      role: 'All-rounder',
      avatar: 'https://via.placeholder.com/150',
      isOnline: false,
    ),
  ];

  // Sample groups
  final List<GroupInfo> _groups = [
    GroupInfo(
      id: 'group_1',
      name: 'Cricket Enthusiasts',
      memberCount: 24,
      avatar: 'https://via.placeholder.com/150',
    ),
    GroupInfo(
      id: 'group_2',
      name: 'Weekend Players',
      memberCount: 12,
      avatar: 'https://via.placeholder.com/150',
    ),
  ];

  // Sample teams
  final List<TeamInfo> _teams = [
    TeamInfo(
      id: 'team_1',
      name: 'Dhaka Warriors',
      memberCount: 15,
      avatar: 'https://via.placeholder.com/150',
    ),
    TeamInfo(
      id: 'team_2',
      name: 'Chittagong Challengers',
      memberCount: 18,
      avatar: 'https://via.placeholder.com/150',
    ),
  ];

  List<Contact> get _filteredContacts {
    if (_searchQuery.isEmpty) return _allContacts;
    return _allContacts
        .where(
          (c) =>
              c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              c.role.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  List<GroupInfo> get _filteredGroups {
    if (_searchQuery.isEmpty) return _groups;
    return _groups
        .where((g) => g.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<TeamInfo> get _filteredTeams {
    if (_searchQuery.isEmpty) return _teams;
    return _teams
        .where((t) => t.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        title: const Text(
          'New Chat',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search contacts...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.surfaceColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              // Tabs
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primaryGreen,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primaryGreen,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(text: 'Contacts'),
                  Tab(text: 'Groups'),
                  Tab(text: 'Teams'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildContactsList(), _buildGroupsList(), _buildTeamsList()],
      ),
    );
  }

  Widget _buildContactsList() {
    return ListView(
      padding: ResponsiveHelper.getPagePadding(context),
      children: [
        const SizedBox(height: 16),
        _filteredContacts.isEmpty
            ? _buildEmptyState('No contacts found')
            : Column(
                children: _filteredContacts
                    .map((contact) => _buildContactTile(contact))
                    .toList(),
              ),
      ],
    );
  }

  Widget _buildGroupsList() {
    return ListView(
      padding: ResponsiveHelper.getPagePadding(context),
      children: [
        const SizedBox(height: 16),
        Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.group_add, color: AppColors.primaryGreen),
            ),
            title: const Text(
              'Create New Group',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('Create a group chat'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showCreateGroupDialog(),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'EXISTING GROUPS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        _filteredGroups.isEmpty
            ? _buildEmptyState('No groups found')
            : Column(
                children: _filteredGroups
                    .map((group) => _buildGroupTile(group))
                    .toList(),
              ),
      ],
    );
  }

  Widget _buildTeamsList() {
    return ListView(
      padding: ResponsiveHelper.getPagePadding(context),
      children: [
        const SizedBox(height: 16),
        _filteredTeams.isEmpty
            ? _buildEmptyState('No teams found')
            : Column(
                children: _filteredTeams
                    .map((team) => _buildTeamTile(team))
                    .toList(),
              ),
      ],
    );
  }

  Widget _buildContactTile(Contact contact) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
              child: Text(
                contact.name[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
            if (contact.isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          contact.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(contact.role),
        trailing: const Icon(
          Icons.chat_bubble_outline,
          color: AppColors.primaryGreen,
        ),
        onTap: () => _startChat(contact),
      ),
    );
  }

  Widget _buildGroupTile(GroupInfo group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue.withValues(alpha: 0.1),
          child: const Icon(Icons.group, color: Colors.blue),
        ),
        title: Text(
          group.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text('${group.memberCount} members'),
        trailing: const Icon(Icons.chat_bubble_outline, color: Colors.blue),
        onTap: () => _openGroupChat(group),
      ),
    );
  }

  Widget _buildTeamTile(TeamInfo team) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.orange.withValues(alpha: 0.1),
          child: const Icon(Icons.shield, color: Colors.orange),
        ),
        title: Text(
          team.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text('${team.memberCount} members'),
        trailing: const Icon(Icons.chat_bubble_outline, color: Colors.orange),
        onTap: () => _openTeamChat(team),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startChat(Contact contact) {
    final chat = Chat(
      id: 'chat_${contact.id}',
      name: contact.name,
      type: ChatType.direct,
      participantIds: ['current_user', contact.id],
      participantNames: ['You', contact.name],
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChatDetailPage(chat: chat)),
    );
  }

  void _openGroupChat(GroupInfo group) {
    final chat = Chat(
      id: group.id,
      name: group.name,
      type: ChatType.group,
      participantIds: ['current_user'], // Add other participant IDs
      participantNames: ['You'], // Add other participant names
      description: 'Group chat',
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChatDetailPage(chat: chat)),
    );
  }

  void _openTeamChat(TeamInfo team) {
    final chat = Chat(
      id: team.id,
      name: team.name,
      type: ChatType.team,
      participantIds: ['current_user'], // Add team member IDs
      participantNames: ['You'], // Add team member names
      description: 'Team chat',
      teamId: team.id,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ChatDetailPage(chat: chat)),
    );
  }

  void _showCreateGroupDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                hintText: 'Enter group name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'You can add members after creating the group',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                Navigator.pop(context);
                final newGroup = GroupInfo(
                  id: 'group_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text,
                  memberCount: 1,
                  avatar: 'https://via.placeholder.com/150',
                );
                _openGroupChat(newGroup);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class Contact {
  final String id;
  final String name;
  final String role;
  final String avatar;
  final bool isOnline;

  Contact({
    required this.id,
    required this.name,
    required this.role,
    required this.avatar,
    this.isOnline = false,
  });
}

class GroupInfo {
  final String id;
  final String name;
  final int memberCount;
  final String avatar;

  GroupInfo({
    required this.id,
    required this.name,
    required this.memberCount,
    required this.avatar,
  });
}

class TeamInfo {
  final String id;
  final String name;
  final int memberCount;
  final String avatar;

  TeamInfo({
    required this.id,
    required this.name,
    required this.memberCount,
    required this.avatar,
  });
}
