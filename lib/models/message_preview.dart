class MessagePreview {
  String senderId;
  String senderName;
  int unreadCount;
  DateTime lastMessageTime;

  MessagePreview({
    required this.senderId,
    required this.senderName,
    required this.unreadCount,
    required this.lastMessageTime,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessagePreview && other.senderId == senderId;
  }

  @override
  int get hashCode => senderId.hashCode;
}
