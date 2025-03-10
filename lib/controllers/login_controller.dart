import 'package:flutter/material.dart';
import 'package:manager_mobile/interfaces/auth.dart';
import 'package:manager_mobile/interfaces/connection.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/states/login_state.dart';

class LoginController extends ChangeNotifier {
  LoginController({required Auth service, required Connection connection})
      : _authService = service,
        _connection = connection;

  final Auth _authService;
  final Connection _connection;

  LoginState _state = LoginStateInitial();
  LoginState get state => _state;

  void _setState(LoginState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<PersonModel?> get currentLoggedUser async {
    return await _authService.currentLoggedUser;
  }

  Future<void> singIn(String email, String password) async {
    await Future.delayed(Duration(seconds: 2));
    try {
      final hasConnection = await _connection.hasConnection();
      if (!hasConnection) {
        _setState(LoginStateError('Sem conexão com a internet.'));
        return;
      }
      await _authService.signIn(email: email, password: password);
    } catch (e) {
      _setState(LoginStateError(e.toString()));
    }
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 2));
    _authService.signOut();
    _setState(LoginStateInitial());
  }
}
