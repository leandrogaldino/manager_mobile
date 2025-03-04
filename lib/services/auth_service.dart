import 'package:firebase_auth/firebase_auth.dart';
import 'package:manager_mobile/core/exceptions/auth_exception.dart';
import 'package:manager_mobile/core/locator.dart';
import 'package:manager_mobile/interfaces/auth.dart';

import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/services/person_service.dart';

class AuthService implements Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RemoteDatabase _remoteDatabase = Locator.get<RemoteDatabase>();
  final PersonService _personService = Locator.get<PersonService>();

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw AuthException('AUT001', 'Usuário inválido');
        case 'invalid-credential':
          throw AuthException('AUT002', 'Usuário e/ou senha incorretos');
        case 'too-many-requests':
          throw AuthException('AUT003', 'O número máximo de requisições foi excedido, aguarde alguns minuitos e tente novamente.');
        case 'user-disabled':
          throw AuthException('AUT004', 'Usuário desativado');
        default:
          throw AuthException('AUT005', 'Erro: ${e.code}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException('AUT006', 'Erro ao sair: ${e.toString()}');
    }
  }

  @override
  Future<PersonModel?> get currentLoggedUser async {
    if (_auth.currentUser == null) return null;
    String userId = _auth.currentUser!.uid;
    var result = await _remoteDatabase.get(collection: 'users', filters: [RemoteDatabaseFilter(field: 'userid', operator: FilterOperator.isEqualTo, value: userId)]);
    if (result.isEmpty) throw Exception('Usuario não vinculado com a pessoa.');
    var personId = int.parse(result[0]['personid']);
    return _personService.getById(personId);
  }
}
