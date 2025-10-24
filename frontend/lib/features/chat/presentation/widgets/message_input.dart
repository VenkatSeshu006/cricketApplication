import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/models/chat_message.dart';

class MessageInput extends StatefulWidget {
  final Function(String content, MessageType type) onSendMessage;
  final Function(MessageType type) onSendAttachment;

  const MessageInput({
    super.key,
    required this.onSendMessage,
    required this.onSendAttachment,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isTyping = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    widget.onSendMessage(_controller.text.trim(), MessageType.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment Button
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: AppColors.primaryGreen,
              onPressed: () => _showAttachmentOptions(context),
            ),
            // Text Input
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.emoji_emotions_outlined),
                      color: AppColors.textSecondary,
                      iconSize: 22,
                      onPressed: () {
                        // TODO: Show emoji picker
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Emoji picker coming soon!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send/Voice Button
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  _isTyping ? Icons.send : Icons.mic,
                  color: Colors.white,
                ),
                onPressed: _isTyping
                    ? _sendMessage
                    : () {
                        // TODO: Record voice message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Voice message coming soon!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AttachmentOption(
                    icon: Icons.image,
                    label: 'Photos',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pop(context);
                      widget.onSendAttachment(MessageType.image);
                    },
                  ),
                  _AttachmentOption(
                    icon: Icons.videocam,
                    label: 'Videos',
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      widget.onSendAttachment(MessageType.video);
                    },
                  ),
                  _AttachmentOption(
                    icon: Icons.insert_drive_file,
                    label: 'Files',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(context);
                      widget.onSendAttachment(MessageType.file);
                    },
                  ),
                  _AttachmentOption(
                    icon: Icons.location_on,
                    label: 'Location',
                    color: AppColors.primaryGreen,
                    onTap: () {
                      Navigator.pop(context);
                      widget.onSendAttachment(MessageType.location);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AttachmentOption(
                    icon: Icons.sports_cricket,
                    label: 'Match',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.pop(context);
                      widget.onSendAttachment(MessageType.matchUpdate);
                    },
                  ),
                  _AttachmentOption(
                    icon: Icons.scoreboard,
                    label: 'Score',
                    color: Colors.teal,
                    onTap: () {
                      Navigator.pop(context);
                      widget.onSendAttachment(MessageType.scoreUpdate);
                    },
                  ),
                  _AttachmentOption(
                    icon: Icons.mic,
                    label: 'Audio',
                    color: Colors.deepPurple,
                    onTap: () {
                      Navigator.pop(context);
                      widget.onSendAttachment(MessageType.audio);
                    },
                  ),
                  const SizedBox(width: 80), // Spacer
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
