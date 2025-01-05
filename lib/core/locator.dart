import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/data/storage_file.dart';
import 'package:manager_mobile/interfaces/auth.dart';
import 'package:manager_mobile/interfaces/connection.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/interfaces/storage.dart';
import 'package:manager_mobile/repositories/coalescent_repository.dart';
import 'package:manager_mobile/repositories/compressor_repository.dart';
import 'package:manager_mobile/repositories/evaluation_coalescent_repository.dart';
import 'package:manager_mobile/repositories/evaluation_info_repository.dart';
import 'package:manager_mobile/repositories/evaluation_photo_repository.dart';
import 'package:manager_mobile/repositories/evaluation_repository.dart';
import 'package:manager_mobile/repositories/evaluation_technician_repository.dart';
import 'package:manager_mobile/repositories/person_repository.dart';
import 'package:manager_mobile/services/auth_service.dart';
import 'package:manager_mobile/core/util/network_connection.dart';
import 'package:manager_mobile/core/data/firestore_database.dart';
import 'package:manager_mobile/core/data/sqflite_database.dart';
import 'package:manager_mobile/services/coalescent_service.dart';
import 'package:manager_mobile/services/compressor_service.dart';
import 'package:manager_mobile/services/person_service.dart';

class Locator {
  Locator._();
  static final GetIt getIt = GetIt.instance;

  static void setup() {
    getIt.registerLazySingleton<RemoteDatabase>(
      () => FirestoreDatabase(),
    );

    getIt.registerLazySingleton<Storage>(
      () => StorageFile(),
    );

    getIt.registerLazySingleton<LocalDatabase>(
      () => SqfliteDatabase(),
    );

    getIt.registerLazySingleton<Auth>(
      () => AuthService(),
    );

    getIt.registerLazySingleton<Connection>(
      () => NetworkConnection(),
    );

    getIt.registerLazySingleton<LoginController>(
      () => LoginController(
        service: GetIt.I<Auth>(),
        connection: GetIt.I<Connection>(),
      ),
    );

    getIt.registerLazySingleton(
      () => CoalescentRepository(
        remoteDatabase: GetIt.I<RemoteDatabase>(),
        localDatabase: GetIt.I<LocalDatabase>(),
      ),
    );

    getIt.registerLazySingleton(
      () => CoalescentService(
        repository: GetIt.I<CoalescentRepository>(),
      ),
    );

    getIt.registerLazySingleton(
      () => CompressorRepository(
        remoteDatabase: GetIt.I<RemoteDatabase>(),
        localDatabase: GetIt.I<LocalDatabase>(),
        coalescentRepository: GetIt.I<CoalescentRepository>(),
      ),
    );

    getIt.registerLazySingleton(
      () => CompressorService(
        repository: GetIt.I<CompressorRepository>(),
      ),
    );

    getIt.registerLazySingleton(
      () => PersonRepository(
        remoteDatabase: GetIt.I<RemoteDatabase>(),
        localDatabase: GetIt.I<LocalDatabase>(),
        compressorRepository: GetIt.I<CompressorRepository>(),
      ),
    );

    getIt.registerLazySingleton(
      () => PersonService(
        repository: GetIt.I<PersonRepository>(),
      ),
    );

    getIt.registerLazySingleton(
      () => EvaluationCoalescentRepository(
        localDatabase: GetIt.I<LocalDatabase>(),
      ),
    );

    getIt.registerLazySingleton(
      () => EvaluationTechnicianRepository(
        localDatabase: GetIt.I<LocalDatabase>(),
      ),
    );

    getIt.registerLazySingleton(
      () => EvaluationPhotoRepository(
        localDatabase: GetIt.I<LocalDatabase>(),
      ),
    );

    getIt.registerLazySingleton(
      () => EvaluationInfoRepository(
        localDatabase: GetIt.I<LocalDatabase>(),
      ),
    );

    getIt.registerLazySingleton(
      () => EvaluationRepository(
        remoteDatabase: GetIt.I<RemoteDatabase>(),
        localDatabase: GetIt.I<LocalDatabase>(),
        storage: GetIt.I<Storage>(),
        compressorRepository: GetIt.I<CompressorRepository>(),
        personRepository: GetIt.I<PersonRepository>(),
        evaluationCoalescentRepository: GetIt.I<EvaluationCoalescentRepository>(),
        evaluationTechnicianRepository: GetIt.I<EvaluationTechnicianRepository>(),
        evaluationPhotoRepository: GetIt.I<EvaluationPhotoRepository>(),
        evaluationInfoRepository: GetIt.I<EvaluationInfoRepository>(),
      ),
    );

    getIt.registerLazySingleton<AppController>(
      () => AppController(
        localDatabase: GetIt.I<LocalDatabase>(),
        coalescentService: GetIt.I<CoalescentService>(),
        compressorService: GetIt.I<CompressorService>(),
        personService: GetIt.I<PersonService>(),
      ),
    );
  }
}
