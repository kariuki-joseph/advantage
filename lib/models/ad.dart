import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class Ad {
  String id;
  String title;
  String description;
  double lat, lng;
  String userId;
  String userName;
  DateTime createdAt;

  Ad({
    required this.id,
    required this.title,
    required this.description,
    required this.lat,
    required this.lng,
    required this.userId,
    required this.userName,
    required this.createdAt,
  });

  // hashmap to save to firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'lat': lat,
      'lng': lng,
      'userId': userId,
      'userName': userName,
      'postDate': createdAt,
    };
  }

  // get the ad data from firebase document
  static Ad fromDocument(DocumentSnapshot snapshot) {
    return Ad(
      id: snapshot.id,
      title: snapshot['title'],
      description: snapshot['description'],
      lat: snapshot['lat'],
      lng: snapshot['lng'],
      userId: snapshot['userId'],
      userName: snapshot['userName'],
      createdAt: snapshot['postDate'],
    );
  }

  // get a list of Ad objects from a QuerySnapshot
  static List<Ad> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => Ad.fromDocument(doc)).toList();
  }
}
