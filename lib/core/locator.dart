import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/interfaces/auth.dart';
import 'package:manager_mobile/interfaces/connection.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/repositories/coalescent_repository.dart';
import 'package:manager_mobile/services/auth_service.dart';
import 'package:manager_mobile/core/util/network_connection.dart';
import 'package:manager_mobile/core/data/firestore_database.dart';
import 'package:manager_mobile/core/data/sqflite_database.dart';
import 'package:manager_mobile/services/coalescent_service.dart';

class Locator {
  Locator._();
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    getIt.registerLazySingleton<RemoteDatabase>(() => FirestoreDatabase());
    getIt.registerLazySingleton<LocalDatabase>(() => SqfliteDatabase());
    getIt.registerLazySingleton<Auth>(() => AuthService());
    getIt.registerLazySingleton<Connection>(() => NetworkConnection());
    getIt.registerLazySingleton<AppController>(() => AppController(localDatabase: GetIt.I<LocalDatabase>()));
    getIt.registerLazySingleton<LoginController>(() => LoginController(service: GetIt.I<Auth>(), connection: GetIt.I<Connection>()));

    getIt.registerLazySingleton(() => CoalescentRepository(remoteDatabase: GetIt.I<RemoteDatabase>(), localDatabase: GetIt.I<LocalDatabase>()));
    getIt.registerLazySingleton(() => CoalescentService(repository: GetIt.I<CoalescentRepository>()));
  }
}
