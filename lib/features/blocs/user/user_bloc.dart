import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orbitpatter/data/repositories/auth_repository.dart';
import 'package:orbitpatter/features/blocs/user/user_event.dart';
import 'package:orbitpatter/features/blocs/user/user_state.dart';

class UsersBloc extends Bloc<UserEvent, UsersState> {


  final AuthRepository _authRepository;


  UsersBloc(this._authRepository) : super(UsersInitial()) {

    on<FetchUsersEvent>(_fetchUsers);
  }

    Future<void> _fetchUsers(
    FetchUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading()); // Corrected to emit UsersLoading state
    try {
      final users = await _authRepository.getUsers();
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UsersError(e.toString())); // Corrected error state
    }
  }


}