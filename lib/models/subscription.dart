import 'package:cloud_firestore/cloud_firestore.dart';

class Subscription {
  String id;
  final String userId;
  final String keyword;

  Subscription({
    required this.userId,
    required this.keyword,
    this.id = '',
  });

  factory Subscription.fromDocumentSnapshot(DocumentSnapshot data) {
    return Subscription(
      id: data.id,
      userId: data['userId'],
      keyword: data['keyword'],
    );
  }
  // from QuerySnapshot
  static List<Subscription> fromQuerySnapshot(QuerySnapshot data) {
    return data.docs
        .map((doc) => Subscription.fromDocumentSnapshot(doc))
        .toList();
  }

  // toMap()
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'keyword': keyword,
    };
  }
}
