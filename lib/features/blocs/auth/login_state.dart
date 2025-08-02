import 'package:orbitpatter/data/models/user.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class GoogleLoginLoading extends LoginState {}

class GoogleLoginSuccess extends LoginState {
  final User user;

  GoogleLoginSuccess(this.user);
}

class GoogleLoginFailure extends LoginState {
  final String error;

  GoogleLoginFailure(this.error);
}

class LoginReset extends LoginState {}