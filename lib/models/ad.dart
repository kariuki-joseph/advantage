import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class Ad {
  String id;
  String title;
  String description;
  List<String> tags;
  double lat, lng;
  String userId;
  String userName;
  String phoneNumber = '';
  DateTime createdAt;
  double distance = 0.0;
  double discoveryRadius;
  bool isVisible = true;

  Ad({
    required this.id,
    required this.title,
    required this.description,
    this.tags = const [],
    this.phoneNumber = '',
    required this.lat,
    required this.lng,
    required this.discoveryRadius,
    required this.userId,
    required this.userName,
    required this.createdAt,
  });

  GeoPoint get location {
    return GeoPoint(lat, lng);
  }

  // hashmap to save to firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'tags': tags,
      'lat': lat,
      'lng': lng,
      'location': GeoFirePoint(location.latitude, location.longitude).data,
      'discoveryRadius': discoveryRadius,
      'userId': userId,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
    };
  }

  // get the ad data from firebase document
  static Ad fromDocument(DocumentSnapshot snapshot) {
    return Ad(
      id: snapshot.id,
      title: snapshot['title'],
      description: snapshot['description'],
      tags: List<String>.from(snapshot['tags']),
      lat: snapshot['lat'],
      lng: snapshot['lng'],
      discoveryRadius: snapshot['discoveryRadius'],
      userId: snapshot['userId'],
      userName: snapshot['userName'],
      phoneNumber: snapshot['phoneNumber'],
      createdAt: (snapshot['createdAt'] as Timestamp).toDate(),
    );
  }

  // get a list of Ad objects from a QuerySnapshot
  static List<Ad> fromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => Ad.fromDocument(doc)).toList();
  }
}
