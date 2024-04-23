
abstract class UserState {
  String get email => '';
}

class UserAuthInitial extends UserState {}

class AuthenticatedUserState extends UserState {
  @override
  final String displayName;
  @override
  final String email;
  final String profileImageUrl ;
  AuthenticatedUserState(this.displayName, this.email,this.profileImageUrl);
}

class UnauthenticatedUserState extends UserState {}