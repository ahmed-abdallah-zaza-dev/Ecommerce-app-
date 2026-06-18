import 'package:flutter_application_1/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.token,
    super.fullName,
    super.phoneNumber,
    super.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String token) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'],
      username: json['username'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      photoUrl: json['photoUrl'],
      token: token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'token': token,
    };
  }
}
