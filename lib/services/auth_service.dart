import 'package:firebase_auth/firebase_auth.dart';
import 'package:manager_mobile/core/exceptions/auth_exception.dart';
import 'package:manager_mobile/interfaces/auth.dart';

class AuthService implements Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw AuthException('Usuário inválido');
        case 'invalid-credential':
          throw AuthException('Usuário e/ou senha incorretos');
        case 'too-many-requests':
          throw AuthException('O número máximo de requisições foi excedido, aguarde alguns minuitos e tente novamente.');
        case 'user-disabled':
          throw AuthException('Usuário desativado');
        default:
          throw AuthException('Erro: ${e.code}');
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
      throw AuthException('Erro ao sair: ${e.toString()}');
    }
  }
}
