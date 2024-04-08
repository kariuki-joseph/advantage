import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? _username;
  String? _email;
  String? _phone;
  String? _pin;
  String? _id;

  UserModel({
    String? id,
    String? username,
    String? email,
    String? phone,
    String? pin,
  })  : _id = id,
        _username = username,
        _email = email,
        _phone = phone,
        _pin = pin;

  // Setters
  set id(String value) {
    _id = value;
  }

  set username(String value) {
    _username = value;
  }

  set email(String value) {
    _email = value;
  }

  set phone(String value) {
    _phone = value;
  }

  set pin(String value) {
    _pin = value;
  }

  // Getters
  String get id => _id ?? '';
  String get username => _username ?? '';
  String get email => _email ?? '';
  String get phone => _phone ?? '';
  String get pin => _pin ?? '';

  // hashmap to save to firestore
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'username': _username,
      'email': _email,
      'phone': _phone,
      'pin': _pin,
    };
  }

  // factory to create user from firestore
  factory UserModel.fromDocument(DocumentSnapshot snapshot) {
    return UserModel(
      id: snapshot.id,
      username: snapshot['username'],
      email: snapshot['email'],
      phone: snapshot['phone'],
      pin: snapshot['pin'],
    );
  }

  // list of users from firestore
  static List<UserModel> fromQuery(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
  }
}
