import 'package:firebase_database/firebase_database.dart';

class Conversation {
  String otherName; // name of the other party
  String otherId; // id of the other party
  String lastMessageId;
  String lastMessageText;
  int unreadCount;
  DateTime lastMessageTime;

  Conversation({
    required this.otherName,
    required this.otherId,
    required this.lastMessageId,
    required this.lastMessageText,
    required this.unreadCount,
    required this.lastMessageTime,
  });

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'senderName': otherName,
      'senderId': otherId,
      'lastMessageId': lastMessageId,
      'lastMessageText': lastMessageText,
      'unreadCount': unreadCount,
      'lastMessageTime': lastMessageTime.toIso8601String(),
    };
  }

  // from realtime snapshot
  factory Conversation.fromRealtimeSnapshot(DataSnapshot data) {
    // get the data as a Map
    if (data.value == null) {
      throw Exception('Data Snapshot is null in message model');
    }
    Map<dynamic, dynamic> dataMap = data.value as Map<dynamic, dynamic>;

    return Conversation(
      otherName: dataMap['senderName'] as String,
      otherId: dataMap['senderId'] as String,
      lastMessageId: dataMap['lastMessageId'] as String,
      lastMessageText: dataMap['lastMessageText'] as String,
      unreadCount: dataMap['unreadCount'] as int,
      lastMessageTime: DateTime.parse(dataMap['lastMessageTime'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Conversation && other.lastMessageId == lastMessageId;
  }

  @override
  int get hashCode => lastMessageId.hashCode;
}
