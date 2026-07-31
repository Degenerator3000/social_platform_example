import 'package:equatable/equatable.dart';

class AuthToken extends Equatable{
  final String value;
  const AuthToken({required this.value});

  @override
  List<Object> get props => [value];
}