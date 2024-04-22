import 'package:firebase_database/firebase_database.dart';

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
      this.createdAt = createdAt;
    }
    if (isRead != null) {
      this.isRead = isRead;
    }
  }

  factory MessageModel.fromRealtimeSnapshot(DataSnapshot data) {
    // get the data as a Map
    if (data.value == null) {
      throw Exception('Data Snapshot is null in message model');
    }
    Map<dynamic, dynamic> dataMap = data.value as Map<dynamic, dynamic>;

    return MessageModel(
      id: data.key!,
      senderId: dataMap['senderId'] as String,
      senderName: dataMap['senderName'] as String,
      receiverId: dataMap['receiverId'] as String,
      message: dataMap['message'] as String,
      createdAt: DateTime.parse(dataMap['createdAt']!),
      isRead: dataMap['isRead'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }

  static MessageModel fromJson(Map<dynamic, dynamic> value) {
    return MessageModel(
      id: value['id'] as String,
      senderId: value['senderId'] as String,
      senderName: value['senderName'] as String,
      receiverId: value['receiverId'] as String,
      message: value['message'] as String,
      createdAt: DateTime.parse(value['createdAt'] as String),
      isRead: value['isRead'] as bool,
    );
  }
}
