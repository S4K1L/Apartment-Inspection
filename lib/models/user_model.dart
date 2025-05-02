import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
   String? uid;
   String? name;
   String? email;
   String? password;
   String? imageUrl;
   String? role;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.password,
    this.imageUrl,
    this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'imageUrl': imageUrl,
      'role': role,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    return UserModel(
      uid: doc['uid'] ?? '',
      name: doc['name'] ?? '',
      email: doc['email'] ?? '',
      password: doc['password'] ?? '',
      imageUrl: doc['imageUrl'] ?? '',
      role: doc['role'] ?? '',
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      role: map['role'] ?? '',
    );
  }
}