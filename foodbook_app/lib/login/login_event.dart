abstract class LoginEvent  {}

class loginUsernameChanged extends LoginEvent {
  final String username;

  loginUsernameChanged({required this.username});
}

class loginPasswordChanged extends LoginEvent {
  final String password;

  loginPasswordChanged({required this.password});
}

class loginSubmitted extends LoginEvent {
  final String username;
  final String password;

  loginSubmitted({required this.username, required this.password});
}