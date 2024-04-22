// Create a notification model that stores notifications about the user's search results have been found
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final DateTime createdAt;
  final String title;
  final String description;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.createdAt,
    required this.title,
    required this.description,
    this.isRead = false,
  });

  // method to convert from Firebase DocumentSnapshot to Notification
  factory NotificationModel.fromDocumentSnapshot(DocumentSnapshot data) {
    return NotificationModel(
      id: data['id'],
      senderId: data['senderId'],
      senderName: data['senderName'],
      receiverId: data['receiverId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      title: data['title'],
      description: data['description'],
      isRead: data['isRead'],
    );
  }
  // convert a list of QueryDocumentSnapshot
  static List<NotificationModel> fromQuerySnapshot(QuerySnapshot data) {
    return data.docs
        .map((doc) => NotificationModel.fromDocumentSnapshot(doc))
        .toList();
  }

  // toMap()
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'createdAt': createdAt,
      'title': title,
      'description': description,
      'isRead': isRead,
    };
  }
}
