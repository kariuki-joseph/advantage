import 'package:advantage/models/message_model.dart';
import 'package:advantage/models/message_preview.dart';
import 'package:advantage/models/user_model.dart';
import 'package:advantage/screens/auth/controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MessagesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<MessageModel> userMessages = <MessageModel>[].obs;
  final RxSet<MessagePreview> messagePreviews = RxSet<MessagePreview>();
  final UserModel loggedInUser = Get.find<AuthController>().user.value;

  @override
  void onInit() async {
    super.onInit();

    await getUserMessages();
  }

  Future<void> getUserMessages() async {
    QuerySnapshot snapshot = await _firestore
        .collection("messages")
        .where("receiverId", isEqualTo: loggedInUser.id)
        .orderBy("createdAt",
            descending: true) // Sorting by createdAt in descending order
        .get();

    List<MessageModel> messages = MessageModel.fromQuerySnapshot(snapshot);
    // create message previews (Group messages from same user)
    for (var message in messages) {
      MessagePreview preview = MessagePreview(
          senderId: message.senderId,
          senderName: message.senderName,
          unreadCount: 1,
          lastMessageTime: message.createdAt);

      if (!messagePreviews.contains(preview)) {
        messagePreviews.add(preview);
      } else {
        // If the preview already exists, update the unread count and last message time
        messagePreviews
            .firstWhere((element) => element == preview)
            .unreadCount = messagePreviews
                .firstWhere((element) => element == preview)
                .unreadCount +
            1;
      }
    }
    // add to messages observable list
    userMessages.assignAll(messages);
  }

  Future<void> sendMessage(MessageModel message) async {
    await _firestore.collection("messages").add(message.toJson());
  }

  // creae a message
  MessageModel createMessage(String message, UserModel receiver) {
    return MessageModel(
      id: _firestore.collection("messages").doc().id,
      senderId: loggedInUser.id,
      senderName: loggedInUser.username,
      receiverId: receiver.id,
      message: message,
    );
  }
}
