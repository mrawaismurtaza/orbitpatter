import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String? bio;
  final DateTime createdAt;
  final List<String> fcmtTokens;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    this.bio,
    required this.createdAt,
    required this.fcmtTokens,
  });

  // Factory method to create a UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      bio: data['bio'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      fcmtTokens: List<String>.from(data['fcmtTokens'] ?? []),
    );
  }

  // Method to convert a UserModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'createdAt': createdAt,
      'fcmtTokens': fcmtTokens,
    };
  }
}