import 'package:equatable/equatable.dart';
import 'package:social_platform_example/features/auth/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState{
  const AuthInitial();
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  const AuthLoading();
  @override
  List<Object> get props => [];
}

class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated({required this.user});
  @override
  List<Object> get props => [user];
}

class AuthError  extends AuthState {
  final String message;
  const AuthError ({required this.message});
  @override
  List<Object> get props => [message];
}