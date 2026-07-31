import 'package:equatable/equatable.dart';
import 'auth_token.dart';
import 'user.dart';


class LoginResult extends Equatable {
  final User user;
  final AuthToken token;

  const LoginResult({required this.user, required this.token});

  @override
  List<Object> get props => [user, token];
}