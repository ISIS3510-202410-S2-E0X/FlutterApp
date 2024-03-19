import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/user_bloc/user_event.dart';
import 'package:foodbook_app/bloc/user_bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserBloc() : super(UserAuthInitial()) {
    on<GetCurrentUser>((event, emit) async {
      try {
        final user = _firebaseAuth.currentUser;
        print('User: $user');
        if (user != null) {
          emit(AuthenticatedUserState(user.email!));
        } else {
          emit(UnauthenticatedUserState());
        }
      } catch (_) {
        emit(UnauthenticatedUserState());
      }
    });
  }
}
