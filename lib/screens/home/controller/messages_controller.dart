import 'package:advantage/models/message_model.dart';
import 'package:advantage/models/conversation.dart';
import 'package:advantage/models/user_model.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesController extends GetxController {
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final RxList<MessageModel> userMessages = <MessageModel>[].obs;
  final RxSet<Conversation> messagePreviews = RxSet<Conversation>();
  final UserModel loggedInUser = Get.find<AuthController>().user.value;
  final RxString receiverId = "".obs;
  final RxString receiverName = "".obs;
  final RxBool showChat = false.obs;
  final Set<String> listenedConversations = {};

  @override
  void onInit() async {
    super.onInit();
    await _getUserConversations();
  }

  Future<void> _getUserConversations() async {
    // get conversations the current user is involved in
    _db.ref("conversations").onChildAdded.listen((event) async {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value == null) {
        return;
      }

      if (snapshot.key!.contains(loggedInUser.id)) {
        Conversation conversation = Conversation.fromRealtimeSnapshot(snapshot);
        // extract the receiver id from the conversation id
        String receiverId =
            snapshot.key!.replaceAll(loggedInUser.id, "").replaceAll("-", "");
        if (receiverId.isEmpty) {
          receiverId = loggedInUser.id;
        }

        messagePreviews.add(conversation);
        // only listen for messages once
        if (!listenedConversations.contains(snapshot.key!)) {
          _listenForMessages(snapshot.key!);
          listenedConversations.add(snapshot.key!);
        }
      }
    });
  }

  // listen for messages in a conversation
  void _listenForMessages(String conversationId) {
    debugPrint("Listening for messages in $conversationId");

    _db.ref("messages").child(conversationId).onChildAdded.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value == null) {
        return;
      }

      MessageModel message = MessageModel.fromRealtimeSnapshot(snapshot);

      userMessages.add(message);
    });
  }

  Future<void> sendMessage(String message) async {
    // Determine the conversation ID
    String conversationId;
    if (loggedInUser.id.compareTo(receiverId.value) < 0) {
      conversationId = '${loggedInUser.id}-$receiverId';
    } else {
      conversationId = '$receiverId-${loggedInUser.id}';
    }

    // Generate a new message ID
    String messageId = _db.ref("messages").child(conversationId).push().key ??
        "defaultMessageId";

    MessageModel messageModel = MessageModel(
      id: messageId,
      senderId: loggedInUser.id,
      senderName: loggedInUser.username,
      receiverId: receiverId.value,
      message: message,
      createdAt: DateTime.now(),
    );

    Conversation conversation = Conversation(
      otherName: receiverName.value,
      otherId: receiverId.value,
      lastMessageId: messageId,
      lastMessageText: message,
      unreadCount: 2,
      lastMessageTime: DateTime.now(),
    );

    String path = "messages/$conversationId/$messageId";
    try {
      await _db.ref().child(path).set(messageModel.toJson());
      await _db
          .ref("conversations")
          .child(conversationId)
          .update(conversation.toJson());
    } on Exception catch (e) {
      debugPrint("Error sending message: ${e.toString()}");
    }
  }

  void fetchMessages() async {
    userMessages.clear();

    // Determine the conversation ID
    String conversationId;
    if (loggedInUser.id.compareTo(receiverId.value) < 0) {
      conversationId = '${loggedInUser.id}-$receiverId';
    } else {
      conversationId = '$receiverId-${loggedInUser.id}';
    }

    _db.ref("messages").child(conversationId).onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value == null) {
        return;
      }

      _db.ref("messages").child(conversationId).onValue.listen((event) {
        DataSnapshot snapshot = event.snapshot;
        if (snapshot.value == null) {
          return;
        }

        Map<dynamic, dynamic> messages =
            snapshot.value as Map<dynamic, dynamic>;

        // Convert each message to a MessageModel
        List<MessageModel> messageModels = messages.entries.map((entry) {
          MessageModel messageModel =
              MessageModel.fromJson(entry.value as Map<dynamic, dynamic>);
          return messageModel;
        }).toList();

        userMessages.assignAll(messageModels);
      });
    });
  }
}
