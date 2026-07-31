import 'package:equatable/equatable.dart';

class AuthCredentials extends Equatable {
  final String username;
  final String password;

  const AuthCredentials({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}