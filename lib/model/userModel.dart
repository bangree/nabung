import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? id;
  final String? email;
  final String? username;

  const UserModel({
    this.id,
    this.email,
    this.username,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      email: data['email'],
      username: data['username'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
    };
  }

  @override
  List<Object?> get props => [
        id,
        email,
        username,
      ];
}
