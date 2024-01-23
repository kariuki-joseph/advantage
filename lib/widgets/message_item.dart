import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage("images/user_avatar.png"),
      ),
      title: Text(
        "User Name",
        style: TextStyle(fontSize: 16),
      ),
      subtitle: Text(
        "2 new messages",
        style: TextStyle(fontSize: 12),
      ),
      trailing: Text(
        "16 Oct",
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
