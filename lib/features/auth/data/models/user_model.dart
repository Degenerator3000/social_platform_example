import 'package:social_platform_example/features/auth/domain/entities/user.dart';

class UserModel {
  final String id;
  final String username;
  final String? email;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.username,
    this.email,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
        id: json['id'] as String,
        username: json['username'] as String,
      email: json['email'] as String?,
      avatarUrl:  json['avatarUrl'] as String?
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'username': username,
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    };
  }

  User toEntity(){
    return User(
      id: id,
      username: username,
      email: email,
      avatarUrl: avatarUrl,
    );
  }

}