import 'chat_message.dart';

class Chat {
  final String id;
  final String name;
  final String? avatar;
  final ChatType type;
  final List<String> participantIds;
  final List<String> participantNames;
  final ChatMessage? lastMessage;
  final int unreadCount;
  final DateTime? lastActivity;
  final bool isPinned;
  final bool isMuted;
  final String? description;
  final String? teamId;

  Chat({
    required this.id,
    required this.name,
    this.avatar,
    required this.type,
    required this.participantIds,
    required this.participantNames,
    this.lastMessage,
    this.unreadCount = 0,
    this.lastActivity,
    this.isPinned = false,
    this.isMuted = false,
    this.description,
    this.teamId,
  });

  bool get hasUnread => unreadCount > 0;

  String get displayName {
    if (type == ChatType.direct && participantNames.length == 2) {
      // For direct chats, show the other person's name
      return participantNames.firstWhere(
        (name) => name != 'You', // TODO: Get current user name
        orElse: () => name,
      );
    }
    return name;
  }

  String get lastMessagePreview {
    if (lastMessage == null) return 'No messages yet';

    String prefix = '';
    if (type == ChatType.group || type == ChatType.team) {
      prefix = '${lastMessage!.senderName}: ';
    }

    switch (lastMessage!.type) {
      case MessageType.text:
        return '$prefix${lastMessage!.content}';
      case MessageType.image:
        return '$prefix📷 Image';
      case MessageType.video:
        return '$prefix🎥 Video';
      case MessageType.audio:
        return '$prefix🎵 Audio';
      case MessageType.file:
        return '$prefix📎 File';
      case MessageType.location:
        return '$prefix📍 Location';
      case MessageType.matchUpdate:
        return '$prefix🏏 Match Update';
      case MessageType.scoreUpdate:
        return '$prefix📊 Score Update';
    }
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      type: ChatType.values.firstWhere(
        (e) => e.toString() == 'ChatType.${json['type']}',
        orElse: () => ChatType.direct,
      ),
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      participantNames: (json['participantNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastMessage: json['lastMessage'] != null
          ? ChatMessage.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      lastActivity: json['lastActivity'] != null
          ? DateTime.parse(json['lastActivity'] as String)
          : null,
      isPinned: json['isPinned'] as bool? ?? false,
      isMuted: json['isMuted'] as bool? ?? false,
      description: json['description'] as String?,
      teamId: json['teamId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'type': type.toString().split('.').last,
      'participantIds': participantIds,
      'participantNames': participantNames,
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'lastActivity': lastActivity?.toIso8601String(),
      'isPinned': isPinned,
      'isMuted': isMuted,
      'description': description,
      'teamId': teamId,
    };
  }
}

enum ChatType {
  direct, // One-on-one chat
  group, // Group chat
  team, // Team chat
  channel, // Broadcast channel
}
