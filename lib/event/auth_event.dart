import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class AuthCheck extends AuthEvent {}

class GetDataWithToken extends AuthEvent {
  final String token;

  GetDataWithToken(this.token);

  @override
  List<Object> get props => [token];
}

class LoggedOut extends AuthEvent {}

class LoginProcess extends AuthEvent {
  final String nipnim;
  final String password;

  LoginProcess({this.nipnim, this.password});

  @override
  List<Object> get props => [nipnim, password];
}
