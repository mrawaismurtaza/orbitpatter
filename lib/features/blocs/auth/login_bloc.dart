import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orbitpatter/data/repositories/auth_repository.dart';
import 'package:orbitpatter/features/blocs/auth/login_event.dart';
import 'package:orbitpatter/features/blocs/auth/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<ResetLoginEvent>(_onResetLogin);
    on<FetchCurrentUserEvent>(_onFetchCurrentUser);
  }

  Future<void> _onLoginWithGoogle(LoginWithGoogleEvent event, Emitter<LoginState> emit) async {
    emit(GoogleLoginLoading());
    try {
      final user = await authRepository.signInWithGoogle();
      emit(GoogleLoginSuccess(user));
    } catch (e) {
      emit(GoogleLoginFailure(e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString()));
    }
  }

  Future<void> _onResetLogin(ResetLoginEvent event, Emitter<LoginState> emit) async {
    try {
      await authRepository.signOut();
      emit(LoginReset()); 
    } catch (e) {
      emit(GoogleLoginFailure(e.toString()));
    }
  }

  Future<void> _onFetchCurrentUser(FetchCurrentUserEvent event, Emitter<LoginState> emit) async {
    try {
      final user = await authRepository.getCurrentUser();
      emit(CurrentUserFetched(user));
    } catch (e) {
      emit(GoogleLoginFailure(e.toString()));
    }
  }

}