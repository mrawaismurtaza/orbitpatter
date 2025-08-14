abstract class LoginEvent {}

class LoginWithGoogleEvent extends LoginEvent {}

class ResetLoginEvent extends LoginEvent {}

class FetchCurrentUserEvent extends LoginEvent {}

class FetchUserByIdEvent extends LoginEvent {
  final String uid;

  FetchUserByIdEvent(this.uid);
}
