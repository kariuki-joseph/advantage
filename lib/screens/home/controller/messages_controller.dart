import 'package:advantage/models/message_model.dart';
import 'package:advantage/models/conversation.dart';
import 'package:advantage/models/user_model.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesController extends GetxController {
  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<MessageModel> userMessages = <MessageModel>[].obs;
  final RxSet<Conversation> messagePreviews = RxSet<Conversation>();
  final UserModel loggedInUser = Get.find<AuthController>().user.value;
  final Set<String> listenedConversations = {};
  final Map<String, UserModel> chatUsers = {};
  final UserModel receiver = UserModel();

  @override
  void onInit() async {
    super.onInit();

    await getUserConversations();
  }

  Future<void> getUserConversations() async {
    // get conversations the current user is involved in
    _db.ref("conversations").onChildAdded.listen((event) async {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value == null) {
        return;
      }

      // check snapshot for the current user id and add to messagePreviews
      if (snapshot.key!.contains(loggedInUser.id)) {
        Conversation conversation = Conversation.fromRealtimeSnapshot(snapshot);
        // extract the receiver id from the conversation id
        String receiverId =
            snapshot.key!.replaceAll(loggedInUser.id, "").replaceAll("-", "");
        if (receiverId.isEmpty) {
          receiverId = loggedInUser.id;
        }

        await fetchReceiver(receiverId);

        messagePreviews.add(conversation);
        // only listen for messages once
        if (!listenedConversations.contains(snapshot.key!)) {
          listenForMessages(snapshot.key!);
          listenedConversations.add(snapshot.key!);
        }
      }
    });
  }

  // listen for messages in a conversation
  void listenForMessages(String conversationId) {
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

// fetch the receiver of the message from firestore
  Future<void> fetchReceiver(String receiverId) async {
    DocumentSnapshot snapshot =
        await _firestore.collection("users").doc(receiverId).get();

    if (snapshot.exists) {
      UserModel receiver = UserModel.fromDocument(snapshot);
      debugPrint("Received user ${receiver.username}");
      chatUsers[receiverId] = receiver;
    }
  }

  Future<void> sendMessage(String message, String receiverId) async {
    // Determine the conversation ID
    String conversationId;
    if (loggedInUser.id.compareTo(receiverId) < 0) {
      conversationId = '${loggedInUser.id}-$receiverId';
    } else {
      conversationId = '$receiverId-${loggedInUser.id}';
    }

    // Generate a new message ID
    String? messageId = _db
            .ref("messages")
            .child(conversationId.isNotEmpty ? conversationId : "temp")
            .push()
            .key ??
        "randomId";

    // Create a new message
    MessageModel messageModel = MessageModel(
      id: messageId,
      senderId: loggedInUser.id,
      senderName: loggedInUser.username,
      receiverId: receiverId,
      message: message,
      createdAt: DateTime.now(),
    );

    // Add the message to the messages node
    await _db
        .ref("messages")
        .child(conversationId)
        .child(messageId)
        .set(messageModel.toJson());

    // Update the conversation in the conversations node
    Conversation conversation = Conversation(
      otherName: chatUsers[receiverId]?.username ?? "Unknown",
      lastMessageId: messageId,
      lastMessageText: message,
      unreadCount: 2,
      lastMessageTime: DateTime.now(),
    );

    await _db
        .ref("conversations")
        .child(conversationId)
        .update(conversation.toJson());
  }
}
