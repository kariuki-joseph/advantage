import 'package:advantage/models/conversation.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ConversationWidget extends StatelessWidget {
  final Conversation messagePreview;
  final Function()? onTap;
  const ConversationWidget({
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
          messagePreview.otherName,
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
