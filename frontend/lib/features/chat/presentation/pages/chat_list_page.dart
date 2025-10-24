import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../domain/models/chat.dart';
import '../../domain/models/chat_message.dart';
import 'chat_detail_page.dart';
import 'new_chat_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  // Sample chat data
  final List<Chat> _allChats = [
    Chat(
      id: '1',
      name: 'Shakib Al Hasan',
      avatar: 'https://via.placeholder.com/150',
      type: ChatType.direct,
      participantIds: ['current_user', 'user_1'],
      participantNames: ['You', 'Shakib Al Hasan'],
      lastMessage: ChatMessage(
        id: 'm1',
        chatId: '1',
        senderId: 'user_1',
        senderName: 'Shakib Al Hasan',
        senderAvatar: 'https://via.placeholder.com/150',
        content: 'Great match today! See you at practice tomorrow.',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
      unreadCount: 2,
      lastActivity: DateTime.now().subtract(const Duration(minutes: 15)),
      isPinned: true,
    ),
    Chat(
      id: '2',
      name: 'Dhaka Warriors',
      avatar: 'https://via.placeholder.com/150',
      type: ChatType.team,
      participantIds: ['current_user', 'user_1', 'user_2', 'user_3'],
      participantNames: ['You', 'Shakib', 'Tamim', 'Mushfiq'],
      lastMessage: ChatMessage(
        id: 'm2',
        chatId: '2',
        senderId: 'user_2',
        senderName: 'Tamim Iqbal',
        senderAvatar: 'https://via.placeholder.com/150',
        content: 'Team meeting at 5 PM tomorrow',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      unreadCount: 0,
      lastActivity: DateTime.now().subtract(const Duration(hours: 1)),
      description: 'Official team chat',
      teamId: 'team_1',
    ),
    Chat(
      id: '3',
      name: 'Cricket Enthusiasts',
      avatar: 'https://via.placeholder.com/150',
      type: ChatType.group,
      participantIds: ['current_user', 'user_4', 'user_5', 'user_6', 'user_7'],
      participantNames: ['You', 'Rahim', 'Karim', 'Nasir', 'Afif'],
      lastMessage: ChatMessage(
        id: 'm3',
        chatId: '3',
        senderId: 'user_4',
        senderName: 'Rahim',
        senderAvatar: 'https://via.placeholder.com/150',
        content: 'Who\'s up for a game this weekend?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      unreadCount: 5,
      lastActivity: DateTime.now().subtract(const Duration(hours: 3)),
      description: 'Group for cricket lovers',
    ),
    Chat(
      id: '4',
      name: 'Mashrafe Mortaza',
      avatar: 'https://via.placeholder.com/150',
      type: ChatType.direct,
      participantIds: ['current_user', 'user_8'],
      participantNames: ['You', 'Mashrafe Mortaza'],
      lastMessage: ChatMessage(
        id: 'm4',
        chatId: '4',
        senderId: 'current_user',
        senderName: 'You',
        senderAvatar: 'https://via.placeholder.com/150',
        content: 'Thanks for the coaching session!',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      unreadCount: 0,
      lastActivity: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Chat(
      id: '5',
      name: 'Tournament Updates',
      avatar: 'https://via.placeholder.com/150',
      type: ChatType.channel,
      participantIds: ['admin', 'current_user'],
      participantNames: ['Admin', 'You'],
      lastMessage: ChatMessage(
        id: 'm5',
        chatId: '5',
        senderId: 'admin',
        senderName: 'Tournament Admin',
        senderAvatar: 'https://via.placeholder.com/150',
        content: 'Quarter-final matches scheduled for next week',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        isRead: false,
      ),
      unreadCount: 3,
      lastActivity: DateTime.now().subtract(const Duration(hours: 6)),
      description: 'Official tournament announcements',
    ),
    Chat(
      id: '6',
      name: 'Chittagong Challengers',
      avatar: 'https://via.placeholder.com/150',
      type: ChatType.team,
      participantIds: ['current_user', 'user_9', 'user_10'],
      participantNames: ['You', 'Mahmudullah', 'Liton Das'],
      lastMessage: ChatMessage(
        id: 'm6',
        chatId: '6',
        senderId: 'user_9',
        senderName: 'Mahmudullah',
        senderAvatar: 'https://via.placeholder.com/150',
        content: '📷 Image',
        type: MessageType.image,
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
        isRead: true,
      ),
      unreadCount: 0,
      lastActivity: DateTime.now().subtract(const Duration(hours: 12)),
      teamId: 'team_2',
    ),
  ];

  List<Chat> get _filteredChats {
    if (_searchQuery.isEmpty) {
      return _allChats;
    }
    return _allChats
        .where(
          (chat) =>
              chat.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              chat.lastMessage?.content.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ==
                  true,
        )
        .toList();
  }

  List<Chat> get _directChats =>
      _filteredChats.where((c) => c.type == ChatType.direct).toList();
  List<Chat> get _groupChats =>
      _filteredChats.where((c) => c.type == ChatType.group).toList();
  List<Chat> get _teamChats =>
      _filteredChats.where((c) => c.type == ChatType.team).toList();
  List<Chat> get _channelChats =>
      _filteredChats.where((c) => c.type == ChatType.channel).toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        // Search Bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search chats...',
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
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryGreen,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primaryGreen,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            tabs: [
              Tab(text: 'All (${_filteredChats.length})'),
              Tab(text: 'Direct (${_directChats.length})'),
              Tab(text: 'Groups (${_groupChats.length + _teamChats.length})'),
              Tab(text: 'Channels (${_channelChats.length})'),
            ],
          ),
        ),
        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildChatList(_filteredChats),
              _buildChatList(_directChats),
              _buildChatList([..._groupChats, ..._teamChats]),
              _buildChatList(_channelChats),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatList(List<Chat> chats) {
    if (chats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty ? 'No chats yet' : 'No chats found',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewChatPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Start a conversation'),
              ),
            ],
          ],
        ),
      );
    }

    // Separate pinned and unpinned chats
    final pinnedChats = chats.where((c) => c.isPinned).toList();
    final unpinnedChats = chats.where((c) => !c.isPinned).toList();

    return ListView(
      padding: ResponsiveHelper.getPagePadding(context),
      children: [
        if (pinnedChats.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.push_pin, size: 16, color: AppColors.textSecondary),
                SizedBox(width: 8),
                Text(
                  'PINNED',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ...pinnedChats.map((chat) => _buildChatTile(chat)),
          if (unpinnedChats.isNotEmpty) const Divider(height: 24),
        ],
        ...unpinnedChats.map((chat) => _buildChatTile(chat)),
      ],
    );
  }

  Widget _buildChatTile(Chat chat) {
    return Dismissible(
      key: Key(chat.id),
      background: Container(
        color: AppColors.primaryGreen,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.archive, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmation(context, chat);
        }
        return true;
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: chat.hasUnread
                ? AppColors.primaryGreen.withValues(alpha: 0.3)
                : AppColors.border.withValues(alpha: 0.1),
          ),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailPage(chat: chat),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar with online indicator
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primaryGreen.withValues(
                        alpha: 0.1,
                      ),
                      child: _buildChatAvatar(chat),
                    ),
                    if (chat.type == ChatType.direct)
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
                const SizedBox(width: 12),
                // Chat info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat.displayName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: chat.hasUnread
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (chat.isPinned)
                            const Icon(
                              Icons.push_pin,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                          const SizedBox(width: 4),
                          if (chat.isMuted)
                            const Icon(
                              Icons.volume_off,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat.lastMessagePreview,
                              style: TextStyle(
                                fontSize: 14,
                                color: chat.hasUnread
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontWeight: chat.hasUnread
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTime(chat.lastActivity),
                            style: TextStyle(
                              fontSize: 12,
                              color: chat.hasUnread
                                  ? AppColors.primaryGreen
                                  : AppColors.textSecondary,
                              fontWeight: chat.hasUnread
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Unread badge
                if (chat.hasUnread) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      chat.unreadCount > 99 ? '99+' : '${chat.unreadCount}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatAvatar(Chat chat) {
    IconData icon;
    switch (chat.type) {
      case ChatType.direct:
        icon = Icons.person;
        break;
      case ChatType.group:
        icon = Icons.group;
        break;
      case ChatType.team:
        icon = Icons.shield;
        break;
      case ChatType.channel:
        icon = Icons.campaign;
        break;
    }

    return Icon(icon, color: AppColors.primaryGreen, size: 28);
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context, Chat chat) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: Text('Are you sure you want to delete "${chat.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
