abstract class UserState {
  String get email => '';
}

class UserAuthInitial extends UserState {}

class AuthenticatedUserState extends UserState {
  @override
  final String email;
  AuthenticatedUserState(this.email);
}

class UnauthenticatedUserState extends UserState {}