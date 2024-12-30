abstract class LoginState {}

class LoginStateInitial extends LoginState {}

class LoginStateError extends LoginState {
  final String message;
  LoginStateError(this.message);
}
