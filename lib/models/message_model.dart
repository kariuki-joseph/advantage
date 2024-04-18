import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final String senderName;
  bool isRead = false;
  DateTime createdAt = DateTime.now();

  MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.message,
    DateTime? createdAt,
    bool? isRead,
  }) {
    if (createdAt != null) {
      createdAt = createdAt;
    }
  }
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      receiverId: json['receiverId'],
      message: json['message'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      isRead: json['isRead'],
    );
  }

  factory MessageModel.fromDocumentSnapshot(DocumentSnapshot data) {
    return MessageModel(
      id: data['id'],
      senderId: data['senderId'],
      senderName: data['senderName'],
      receiverId: data['receiverId'],
      message: data['message'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isRead: data['isRead'],
    );
  }

  // from QuerySnapshot
  static List<MessageModel> fromQuerySnapshot(QuerySnapshot data) {
    return data.docs
        .map((doc) => MessageModel.fromDocumentSnapshot(doc))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'message': message,
      'createdAt': createdAt,
      'isRead': isRead,
    };
  }
}
