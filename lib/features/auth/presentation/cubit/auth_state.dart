import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState{
  const AuthInitial();
  @override
  List<Object> get props => [];
}

final class AuthLoading extends AuthState {
  const AuthLoading();
  @override
  List<Object> get props => [];
}

final class Authenticated extends AuthState {
  @override
  List<Object> get props => [];
}

final class Unauthenticated extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthError  extends AuthState {
  final String message;
  const AuthError ({required this.message});
  @override
  List<Object> get props => [message];
}