import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInit extends AuthState {}

class AuthLoading extends AuthState {}

class AuthHasToken extends AuthState {
  final String token;
  AuthHasToken({this.token});

  @override
  List<Object> get props => [token];
}

class AuthFailed extends AuthState {}

class AuthData extends AuthState {
  final int id;
  final String name;
  final String email;
  final int peminjamId;

  AuthData({this.id, this.name, this.email, this.peminjamId});
  @override
  List<Object> get props => [id, name, email, peminjamId];
}

class LoginInit extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginFailed extends AuthState {
  final String error;
  LoginFailed(this.error);

  @override
  List<Object> get props => [error];
}

class LogoutSuccess extends AuthState {}
