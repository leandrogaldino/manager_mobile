import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/interfaces/auth.dart';

import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/states/login_state.dart';

class LoginController extends ChangeNotifier {
  final Auth _authService;

  LoginController({
    required Auth service,
    required AppPreferences appPreferences,
  }) : _authService = service;

  LoginState _state = LoginStateInitial();
  LoginState get state => _state;

  void _setState(LoginState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<PersonModel?> get currentLoggedUser async {
    return await _authService.currentLoggedUser;
  }

  Future<void> signIn(String email, String password) async {
    _setState(LoginStateLoading());
    try {
      final hasConnection = await InternetConnection().hasInternetAccess;
      if (!hasConnection) {
        _setState(LoginStateError('Sem conexão com a internet.'));
        return;
      }
      await _authService.signIn(email: email, password: password);
      _setState(LoginStateSuccess());
    } catch (e) {
      _setState(LoginStateError(e.toString()));
    }
  }

  Future<void> signOut() async {
    _setState(LoginStateLoading());
    await _authService.signOut();
    _setState(LoginStateInitial());
  }
}
