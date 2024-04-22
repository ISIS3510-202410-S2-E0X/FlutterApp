abstract class UserState {
  String get email => '';
}

class UserAuthInitial extends UserState {}

class AuthenticatedUserState extends UserState {
  @override
  final String displayName;
  AuthenticatedUserState(this.displayName);
}

class UnauthenticatedUserState extends UserState {}