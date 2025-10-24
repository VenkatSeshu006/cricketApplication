import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../domain/models/chat.dart';
import '../../domain/models/chat_message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ChatDetailPage extends StatefulWidget {
  final Chat chat;

  const ChatDetailPage({super.key, required this.chat});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    // Sample messages for demonstration
    _messages.addAll([
      ChatMessage(
        id: 'm1',
        chatId: widget.chat.id,
        senderId: 'user_1',
        senderName: widget.chat.participantNames.first,
        senderAvatar: 'https://via.placeholder.com/150',
        content: 'Hey! How are you doing?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      ChatMessage(
        id: 'm2',
        chatId: widget.chat.id,
        senderId: 'current_user',
        senderName: 'You',
        senderAvatar: 'https://via.placeholder.com/150',
        content: 'I\'m doing great! Just finished practice.',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 55),
        ),
        isRead: true,
      ),
      ChatMessage(
        id: 'm3',
        chatId: widget.chat.id,
        senderId: 'user_1',
        senderName: widget.chat.participantNames.first,
        senderAvatar: 'https://via.placeholder.com/150',
        content: 'That\'s awesome! Are you ready for the match tomorrow?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 50),
        ),
        isRead: true,
      ),
      ChatMessage(
        id: 'm4',
        chatId: widget.chat.id,
        senderId: 'current_user',
        senderName: 'You',
        senderAvatar: 'https://via.placeholder.com/150',
        content: 'Yes! I\'ve been working on my batting. Feeling confident.',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 45),
        ),
        isRead: true,
      ),
      if (widget.chat.type == ChatType.team) ...[
        ChatMessage(
          id: 'm5',
          chatId: widget.chat.id,
          senderId: 'user_2',
          senderName: 'Tamim Iqbal',
          senderAvatar: 'https://via.placeholder.com/150',
          content: 'Team, remember we have practice at 5 PM today!',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          isRead: true,
        ),
        ChatMessage(
          id: 'm6',
          chatId: widget.chat.id,
          senderId: 'user_3',
          senderName: 'Mushfiqur Rahim',
          senderAvatar: 'https://via.placeholder.com/150',
          content: 'Got it! See you all there.',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
          isRead: true,
        ),
      ],
      ChatMessage(
        id: 'm7',
        chatId: widget.chat.id,
        senderId: 'user_1',
        senderName: widget.chat.participantNames.first,
        senderAvatar: 'https://via.placeholder.com/150',
        content: widget.chat.lastMessage?.content ?? 'Great match today!',
        type: MessageType.text,
        timestamp:
            widget.chat.lastActivity ??
            DateTime.now().subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
    ]);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        titleSpacing: 0,
        title: InkWell(
          onTap: () => _showChatInfo(),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                child: _buildChatIcon(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chat.displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _getSubtitle(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (widget.chat.type == ChatType.direct) ...[
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Voice call feature coming soon!'),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.videocam),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Video call feature coming soon!'),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
              },
            ),
          ],
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showChatOptions(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: ResponsiveHelper.getPagePadding(
                context,
              ).copyWith(top: 16, bottom: 16),
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final previousMessage = index > 0 ? _messages[index - 1] : null;
                final showDate = _shouldShowDate(message, previousMessage);
                final showSender = _shouldShowSender(message, previousMessage);

                return Column(
                  children: [
                    if (showDate) _buildDateDivider(message.timestamp),
                    MessageBubble(
                      message: message,
                      showSender: showSender,
                      chatType: widget.chat.type,
                    ),
                  ],
                );
              },
            ),
          ),
          // Message Input
          MessageInput(
            onSendMessage: (content, type) => _sendMessage(content, type),
            onSendAttachment: (type) => _handleAttachment(type),
          ),
        ],
      ),
    );
  }

  Widget _buildChatIcon() {
    IconData icon;
    switch (widget.chat.type) {
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
    return Icon(icon, color: AppColors.primaryGreen, size: 24);
  }

  String _getSubtitle() {
    switch (widget.chat.type) {
      case ChatType.direct:
        return 'Online'; // TODO: Get actual online status
      case ChatType.group:
        return '${widget.chat.participantIds.length} members';
      case ChatType.team:
        return '${widget.chat.participantIds.length} team members';
      case ChatType.channel:
        return '${widget.chat.participantIds.length} subscribers';
    }
  }

  bool _shouldShowDate(ChatMessage message, ChatMessage? previousMessage) {
    if (previousMessage == null) return true;

    final messageDate = DateTime(
      message.timestamp.year,
      message.timestamp.month,
      message.timestamp.day,
    );
    final previousDate = DateTime(
      previousMessage.timestamp.year,
      previousMessage.timestamp.month,
      previousMessage.timestamp.day,
    );

    return messageDate != previousDate;
  }

  bool _shouldShowSender(ChatMessage message, ChatMessage? previousMessage) {
    if (message.isMyMessage) return false;
    if (widget.chat.type == ChatType.direct) return false;
    if (previousMessage == null) return true;

    return message.senderId != previousMessage.senderId;
  }

  Widget _buildDateDivider(DateTime date) {
    String dateText;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      dateText = 'Today';
    } else if (messageDate == yesterday) {
      dateText = 'Yesterday';
    } else {
      dateText = '${date.day}/${date.month}/${date.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                dateText,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  void _sendMessage(String content, MessageType type) {
    if (content.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: 'm${_messages.length + 1}',
      chatId: widget.chat.id,
      senderId: 'current_user',
      senderName: 'You',
      senderAvatar: 'https://via.placeholder.com/150',
      content: content,
      type: type,
      timestamp: DateTime.now(),
      isRead: false,
    );

    setState(() {
      _messages.add(newMessage);
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _handleAttachment(MessageType type) {
    String typeText = type.toString().split('.').last;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sending $typeText...'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  void _showChatInfo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryGreen.withValues(
                    alpha: 0.1,
                  ),
                  child: Icon(
                    widget.chat.type == ChatType.direct
                        ? Icons.person
                        : widget.chat.type == ChatType.team
                        ? Icons.shield
                        : Icons.group,
                    color: AppColors.primaryGreen,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.chat.displayName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getSubtitle(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (widget.chat.description != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    widget.chat.description!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                if (widget.chat.type != ChatType.direct) ...[
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('View members'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pop(context);
                      // Show members list
                    },
                  ),
                ],
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('Media, links, and docs'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pop(context);
                    // Show media
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Search in conversation'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pop(context);
                    // Show search
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                widget.chat.isMuted ? Icons.volume_up : Icons.volume_off,
              ),
              title: Text(widget.chat.isMuted ? 'Unmute' : 'Mute'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.chat.isMuted ? 'Chat unmuted' : 'Chat muted',
                    ),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.clear),
              title: const Text('Clear chat'),
              onTap: () {
                Navigator.pop(context);
                _showClearChatConfirmation();
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Block', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showBlockConfirmation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearChatConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear all messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _messages.clear());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chat cleared'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showBlockConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Block User'),
        content: Text(
          'Are you sure you want to block ${widget.chat.displayName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to chat list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User blocked'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Block'),
          ),
        ],
      ),
    );
  }
}
