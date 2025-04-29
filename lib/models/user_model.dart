import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? password;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    return UserModel(
      uid: doc['uid'] ?? '',
      name: doc['name'] ?? '',
      email: doc['email'] ?? '',
      password: doc['password'] ?? '',
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
}