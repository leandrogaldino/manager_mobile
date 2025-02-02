import 'package:manager_mobile/models/person_model.dart';

abstract class Auth {
  Future<void> signIn({required String email, required String password});
  Future<void> signOut();
  Future<PersonModel?> get currentLoggedUser;
}
