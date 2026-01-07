abstract class AppState {}

class AppStateInitial extends AppState {}

class AppStateSuccess extends AppState {}

class AppStateError extends AppState {
  final String message;
  AppStateError(this.message);
}