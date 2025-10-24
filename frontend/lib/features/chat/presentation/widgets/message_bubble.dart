import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/models/chat.dart';
import '../../domain/models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showSender;
  final ChatType chatType;

  const MessageBubble({
    super.key,
    required this.message,
    required this.showSender,
    required this.chatType,
  });

  @override
  Widget build(BuildContext context) {
    final isMyMessage = message.isMyMessage;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMyMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMyMessage &&
              (chatType == ChatType.group || chatType == ChatType.team))
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                child: Text(
                  message.senderName[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            )
          else if (!isMyMessage)
            const SizedBox(width: 40),
          Flexible(
            child: Column(
              crossAxisAlignment: isMyMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (showSender && !isMyMessage)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 4),
                    child: Text(
                      message.senderName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMyMessage ? AppColors.primaryGreen : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMyMessage ? 16 : 4),
                      bottomRight: Radius.circular(isMyMessage ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.replyToId != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (isMyMessage ? Colors.white : Colors.grey)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Replying to message...',
                            style: TextStyle(
                              fontSize: 12,
                              color: isMyMessage
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      _buildMessageContent(isMyMessage),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatTime(message.timestamp),
                            style: TextStyle(
                              fontSize: 11,
                              color: isMyMessage
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : AppColors.textSecondary,
                            ),
                          ),
                          if (isMyMessage) ...[
                            const SizedBox(width: 4),
                            Icon(
                              message.isRead ? Icons.done_all : Icons.done,
                              size: 14,
                              color: message.isRead
                                  ? Colors.blue[300]
                                  : Colors.white.withValues(alpha: 0.8),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isMyMessage) const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildMessageContent(bool isMyMessage) {
    switch (message.type) {
      case MessageType.text:
        return Text(
          message.content,
          style: TextStyle(
            fontSize: 15,
            color: isMyMessage ? Colors.white : AppColors.textPrimary,
            height: 1.3,
          ),
        );
      case MessageType.image:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 200,
                height: 200,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 64),
              ),
            ),
            if (message.content.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                message.content,
                style: TextStyle(
                  fontSize: 15,
                  color: isMyMessage ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ],
        );
      case MessageType.video:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.videocam, size: 64),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
            if (message.content.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                message.content,
                style: TextStyle(
                  fontSize: 15,
                  color: isMyMessage ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ],
        );
      case MessageType.audio:
        return Row(
          children: [
            Icon(
              Icons.play_arrow,
              color: isMyMessage ? Colors.white : AppColors.primaryGreen,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color:
                          (isMyMessage ? Colors.white : AppColors.primaryGreen)
                              .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '0:00 / 1:23',
                    style: TextStyle(
                      fontSize: 12,
                      color: isMyMessage
                          ? Colors.white.withValues(alpha: 0.8)
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case MessageType.file:
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isMyMessage ? Colors.white : AppColors.primaryGreen)
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.insert_drive_file,
                color: isMyMessage ? Colors.white : AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isMyMessage ? Colors.white : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '2.5 MB',
                    style: TextStyle(
                      fontSize: 12,
                      color: isMyMessage
                          ? Colors.white.withValues(alpha: 0.8)
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      case MessageType.location:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 200,
                height: 150,
                color: Colors.grey[300],
                child: const Icon(Icons.map, size: 64),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message.content,
              style: TextStyle(
                fontSize: 14,
                color: isMyMessage ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        );
      case MessageType.matchUpdate:
      case MessageType.scoreUpdate:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (isMyMessage ? Colors.white : AppColors.primaryGreen)
                .withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.sports_cricket,
                color: isMyMessage ? Colors.white : AppColors.primaryGreen,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message.content,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isMyMessage ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
