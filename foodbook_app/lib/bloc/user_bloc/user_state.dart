abstract class UserState {}

class UserAuthInitial extends UserState {}

class AuthenticatedUserState extends UserState {
  final String email;
  AuthenticatedUserState(this.email);
}

class UnauthenticatedUserState extends UserState {}