import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? fullName;
  final String? phoneNumber;
  final String? photoUrl;
  final String token;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.token,
    this.fullName,
    this.phoneNumber,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    username,
    token,
    fullName,
    phoneNumber,
    photoUrl,
  ];
}
