import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String? bio;
  final DateTime createdAt;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    this.bio,
    required this.createdAt,
  });

  // Factory method to create a User from a Map
  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      bio: data['bio'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Method to convert a User to a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'createdAt': createdAt,
    };
  }
}