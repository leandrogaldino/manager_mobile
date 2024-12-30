import 'package:flutter/material.dart';
import 'package:manager_mobile/interfaces/auth.dart';
import 'package:manager_mobile/interfaces/connection.dart';
import 'package:manager_mobile/states/login_state.dart';

class LoginController {
  final Auth _authService;
  final Connection _connection;
  LoginController({required Auth service, required Connection connection})
      : _authService = service,
        _connection = connection;

  final ValueNotifier<LoginState> _state = ValueNotifier<LoginState>(LoginStateInitial());
  ValueNotifier<LoginState> get state => _state;
  void _setState(LoginState newState) => _state.value = newState;

  final _obscurePassword = ValueNotifier<bool>(true);
  ValueNotifier<bool> get obscurePassword => _obscurePassword;
  void toggleObscurePassword() => _obscurePassword.value = !_obscurePassword.value;

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
      _setState(LoginStateError('Erro ao fazer login: ${e.toString()}'));
    }
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 2));
    return _authService.signOut();
  }
}
