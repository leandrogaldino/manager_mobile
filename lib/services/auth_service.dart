import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/core/exceptions/auth_exception.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/interfaces/auth.dart';

import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/services/person_service.dart';

class AuthService implements Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RemoteDatabase _remoteDatabase = Locator.get<RemoteDatabase>();
  final PersonService _personService = Locator.get<PersonService>();
  final AppPreferences _appPreferences = Locator.get<AppPreferences>();
  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (_auth.currentUser == null) return;
      String userId = _auth.currentUser!.uid;
      var result = await _remoteDatabase.get(collection: 'users', filters: [RemoteDatabaseFilter(field: 'userid', operator: FilterOperator.isEqualTo, value: userId)]);
      if (result.isEmpty) {
        String code = 'AUT001';
        String message = 'Usuário não vinculado com a pessoa';
        log('[$code] $message', time: DateTimeHelper.now());
        throw Exception(message);
      }
      var personId = int.parse(result[0]['personid']); 
      await _appPreferences.setLoggedTechnicianId(personId);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          String code = 'AUT002';
          String message = 'Usuário inválido';
          log('[$code] $message', time: DateTimeHelper.now());
          throw AuthException(code, message);
        case 'invalid-credential':
          String code = 'AUT003';
          String message = 'Usuário e/ou senha incorretos';
          log('[$code] $message', time: DateTimeHelper.now());
          throw AuthException(code, message);
        case 'too-many-requests':
          String code = 'AUT004';
          String message = 'O número máximo de requisições foi excedido, aguarde alguns minutos e tente novamente';
          log('[$code] $message', time: DateTimeHelper.now());
          throw AuthException(code, message);
        case 'user-disabled':
          String code = 'AUT005';
          String message = 'Usuário desativado';
          log('[$code] $message', time: DateTimeHelper.now());
          throw AuthException(code, message);
        default:
          String code = 'AUT006';
          String message = 'Erro: ${e.code}';
          log('[$code] $message', time: DateTimeHelper.now());
          throw AuthException(code, message);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _appPreferences.setLoggedTechnicianId(0);
    } catch (e) {
      throw AuthException('AUT006', 'Erro ao sair: ${e.toString()}');
    }
  }

  @override
  Future<PersonModel?> get currentLoggedUser async {
    return await _personService.getById(await _appPreferences.loggedTechnicianId);
  }
}
