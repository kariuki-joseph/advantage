import 'package:advantage/models/message_preview.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PreviewMessageWidget extends StatelessWidget {
  final MessagePreview messagePreview;
  final Function()? onTap;
  const PreviewMessageWidget({
    super.key,
    required this.messagePreview,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage("images/user_avatar.png"),
        ),
        title: Text(
          messagePreview.senderName,
          style: const TextStyle(fontSize: 16),
        ),
        subtitle: Text(
          "${messagePreview.unreadCount} new messages",
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Text(
          timeago.format(messagePreview.lastMessageTime),
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
