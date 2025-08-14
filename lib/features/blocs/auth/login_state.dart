import 'package:orbitpatter/data/models/user.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class GoogleLoginLoading extends LoginState {}

class GoogleLoginSuccess extends LoginState {
  final UserModel user;

  GoogleLoginSuccess(this.user);
}

class GoogleLoginFailure extends LoginState {
  final String error;

  GoogleLoginFailure(this.error);
}

class LoginReset extends LoginState {}

//Current User
class CurrentUserFetched extends LoginState {
  final UserModel? user;

  CurrentUserFetched(this.user);
}