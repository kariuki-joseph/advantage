import 'package:advantage/screens/chat/chat_facebook_screen.dart';
import 'package:advantage/screens/home/controller/messages_controller.dart';
import 'package:advantage/widgets/conversation_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesTab extends StatelessWidget {
  MessagesTab({super.key});
  final MessagesController messagesController = Get.find<MessagesController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: messagesController.showChat.value,
        replacement: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text("Messages"),
            ),
            body: ListView.builder(
              itemCount: messagesController.messagePreviews.length,
              itemBuilder: ((context, index) {
                return ConversationWidget(
                  messagePreview:
                      messagesController.messagePreviews.elementAt(index),
                  onTap: () {
                    // navigate to chat screen
                    messagesController.receiverId.value = messagesController
                        .messagePreviews
                        .elementAt(index)
                        .otherId;
                    messagesController.receiverName.value = messagesController
                        .messagePreviews
                        .elementAt(index)
                        .otherName;
                    messagesController.showChat.value = true;
                  },
                );
              }),
            ),
          ),
        ),
        child: const ChatFacebookScreen(),
      ),
    );
  }
}
