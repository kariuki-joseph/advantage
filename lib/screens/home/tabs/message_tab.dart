import 'package:advantage/widgets/message_item.dart';
import 'package:flutter/material.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Messages"),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: ((context, index) {
          return const MessageItem();
        }),
      ),
    ));
  }
}
