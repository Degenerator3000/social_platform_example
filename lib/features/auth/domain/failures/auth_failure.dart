import 'package:equatable/equatable.dart';

sealed class AuthFailure extends Equatable{
  const AuthFailure();

  const factory AuthFailure.wrongCredentials() = WrongCredentialsFailure ;
  const factory AuthFailure.network() = NetworkFailure;
  const factory AuthFailure.server(String message) = ServerFailure;
  const factory AuthFailure.refreshTokenExpired() = RefreshTokenExpiredFailure;
  const factory AuthFailure.unknown(String message) = UnknownFailure;

  String get message;
}

final class WrongCredentialsFailure extends AuthFailure {
  const WrongCredentialsFailure();
  @override
  String get message => 'Неверный логин или пароль';
  @override
  List<Object?> get props => [];
}

final class NetworkFailure extends AuthFailure {
  const NetworkFailure();
  @override
  String get message => 'Отсутствует интернет-соединение';
  @override
  List<Object?> get props => [];
}

final class ServerFailure extends AuthFailure {
  final String? details;
  const ServerFailure([this.details]);
  @override
  String get message => details ?? 'Ошибка сервера';
  @override
  List<Object?> get props => [];
}

final class RefreshTokenExpiredFailure extends AuthFailure {
  const RefreshTokenExpiredFailure();
  @override
  String get message => 'Сессия истекла, войдите завново';
  @override
  List<Object?> get props => [];
}

final class UnknownFailure extends AuthFailure {
  final String? details;
  const UnknownFailure([this.details]);
  @override
  String get message => details ?? 'Неизвестная ошибка';
  @override
  List<Object?> get props => [];
}