//временно не нужный файл. Пригодится в будущем
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:social_platform_example/features/auth/domain/entities/auth_credentials.dart';
import 'package:social_platform_example/features/auth/data/models/user_model.dart';

class InMemoryAuthDataSource{

  final List<Map<String, dynamic>> _fakeUsers = [
    {
      'id': '1',
      'username': 'я',
      'email': 'alice@example.com',
      'password': sha256.convert(utf8.encode("нуя")).toString(),   // в реальном проекте здесь должен быть хеш
    },
    {
      'id': '2',
      'username': 'bob',
      'email': null,               // у Боба нет email — проверяем nullable
      'password': sha256.convert(utf8.encode('secureBob')).toString(),
    },
    {
      'id': '3',
      'username': 'charlie',
      'email': 'charlie.dev@example.com',
      'password': sha256.convert(utf8.encode('charliePass')).toString(),
    },
    {
      'id': '4',
      'username': 'demo',
      'email': 'demo@social.local',
      'password': sha256.convert(utf8.encode('demo')).toString(),
    },
  ];

  String _hash(String string){
    return sha256.convert(utf8.encode(string)).toString();
  }

  Future<UserModel?> login(AuthCredentials credentials) async{
    await Future.delayed(Duration(seconds: 1));
    final userJson = _fakeUsers.where(
            (x) => x['username'] == credentials.username &&
        x['password'] == _hash(credentials.password)
    ).firstOrNull;
    if (userJson != null){
      return UserModel.fromJson(userJson);
    }
    return null;
  }

  Future<UserModel?> getUserById(String id) async{
    await Future.delayed(Duration(seconds: 1));
    final userJson = _fakeUsers.where((x) => x['id'] == id).firstOrNull;
    if (userJson != null){
      return UserModel.fromJson(userJson);
    }
    return null;
  }

}