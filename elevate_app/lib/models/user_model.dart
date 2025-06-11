import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String username;
  final String? photoUrl;
  final String? phoneNumber;
  final String? displayName;
  final DateTime createdTime;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    this.photoUrl,
    this.phoneNumber,
    this.displayName,
    required this.createdTime,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      photoUrl: data['photo_url'],
      phoneNumber: data['phone_number'],
      displayName: data['display_name'],
      createdTime: (data['created_time'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'photo_url': photoUrl,
      'phone_number': phoneNumber,
      'display_name': displayName,
      'created_time': Timestamp.fromDate(createdTime),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? photoUrl,
    String? phoneNumber,
    String? displayName,
    DateTime? createdTime,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      createdTime: createdTime ?? this.createdTime,
    );
  }
}