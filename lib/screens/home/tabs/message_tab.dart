import 'package:advantage/routes/app_routes.dart';
import 'package:advantage/screens/home/controller/messages_controller.dart';
import 'package:advantage/widgets/conversation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesTab extends StatelessWidget {
  MessagesTab({super.key});
  final MessagesController messagesController = Get.find<MessagesController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Messages"),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: messagesController.messagePreviews.length,
          itemBuilder: ((context, index) {
            return ConversationWidget(
              messagePreview:
                  messagesController.messagePreviews.elementAt(index),
              onTap: () {
                // navigate to chat screen
                Get.toNamed(
                  AppRoutes.chat,
                  arguments: messagesController.messagePreviews
                      .elementAt(index)
                      .lastMessageId,
                );
              },
            );
          }),
        ),
      ),
    ));
  }
}
