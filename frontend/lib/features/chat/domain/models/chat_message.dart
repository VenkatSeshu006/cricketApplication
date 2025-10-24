class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final String? replyToId;
  final List<String>? attachments;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.replyToId,
    this.attachments,
  });

  bool get isMyMessage => senderId == 'current_user'; // TODO: Get from auth

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatar: json['senderAvatar'] as String,
      content: json['content'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      replyToId: json['replyToId'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'content': content,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'replyToId': replyToId,
      'attachments': attachments,
    };
  }
}

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
  location,
  matchUpdate,
  scoreUpdate,
}
