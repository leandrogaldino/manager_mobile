import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/controllers/person_controller.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/filter_controller.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/core/data/storage_file.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/interfaces/auth.dart';
import 'package:manager_mobile/interfaces/connection.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/interfaces/storage.dart';
import 'package:manager_mobile/repositories/coalescent_repository.dart';
import 'package:manager_mobile/repositories/compressor_repository.dart';
import 'package:manager_mobile/repositories/evaluation_coalescent_repository.dart';
import 'package:manager_mobile/repositories/evaluation_photo_repository.dart';
import 'package:manager_mobile/repositories/evaluation_repository.dart';
import 'package:manager_mobile/repositories/evaluation_technician_repository.dart';
import 'package:manager_mobile/repositories/person_repository.dart';
import 'package:manager_mobile/repositories/schedule_repository.dart';
import 'package:manager_mobile/services/auth_service.dart';
import 'package:manager_mobile/core/util/network_connection.dart';
import 'package:manager_mobile/core/data/firestore_database.dart';
import 'package:manager_mobile/core/data/sqflite_database.dart';
import 'package:manager_mobile/services/coalescent_service.dart';
import 'package:manager_mobile/services/compressor_service.dart';
import 'package:manager_mobile/services/evaluation_coalescent_service.dart';
import 'package:manager_mobile/services/evaluation_photo_service.dart';
import 'package:manager_mobile/services/evaluation_service.dart';
import 'package:manager_mobile/services/evaluation_technician_service.dart';
import 'package:manager_mobile/services/person_service.dart';
import 'package:manager_mobile/services/schedule_service.dart';

class Locator {
  Locator._();
  static final GetIt _getIt = GetIt.instance;

  static T get<T extends Object>() {
    return _getIt.get<T>();
  }

  static void setup() {
    _getIt.registerLazySingleton<RemoteDatabase>(
      () => FirestoreDatabase(),
    );

    _getIt.registerLazySingleton<Storage>(
      () => StorageFile(),
    );

    _getIt.registerLazySingleton<LocalDatabase>(
      () => SqfliteDatabase(),
    );

    _getIt.registerLazySingleton<Auth>(
      () => AuthService(),
    );

    _getIt.registerLazySingleton<Connection>(
      () => NetworkConnection(),
    );

    _getIt.registerLazySingleton<LoginController>(
      () => LoginController(
        service: _getIt.get<Auth>(),
        connection: _getIt.get<Connection>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => CoalescentRepository(
        remoteDatabase: _getIt.get<RemoteDatabase>(),
        localDatabase: _getIt.get<LocalDatabase>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => CoalescentService(
        repository: _getIt.get<CoalescentRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => CompressorRepository(
        remoteDatabase: _getIt.get<RemoteDatabase>(),
        localDatabase: _getIt.get<LocalDatabase>(),
        coalescentRepository: _getIt.get<CoalescentRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => CompressorService(
        repository: _getIt.get<CompressorRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => PersonRepository(
        remoteDatabase: _getIt.get<RemoteDatabase>(),
        localDatabase: _getIt.get<LocalDatabase>(),
        compressorRepository: _getIt.get<CompressorRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => PersonService(
        repository: _getIt.get<PersonRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => EvaluationCoalescentRepository(
        localDatabase: _getIt.get<LocalDatabase>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => EvaluationTechnicianRepository(
        localDatabase: _getIt.get<LocalDatabase>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => EvaluationPhotoRepository(
        localDatabase: _getIt.get<LocalDatabase>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => EvaluationRepository(
        remoteDatabase: _getIt.get<RemoteDatabase>(),
        localDatabase: _getIt.get<LocalDatabase>(),
        storage: _getIt.get<Storage>(),
        coalescentRepository: _getIt.get<CoalescentRepository>(),
        compressorRepository: _getIt.get<CompressorRepository>(),
        personRepository: _getIt.get<PersonRepository>(),
        evaluationCoalescentRepository: _getIt.get<EvaluationCoalescentRepository>(),
        evaluationTechnicianRepository: _getIt.get<EvaluationTechnicianRepository>(),
        evaluationPhotoRepository: _getIt.get<EvaluationPhotoRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => EvaluationCoalescentService(
        repository: _getIt.get<EvaluationCoalescentRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => EvaluationTechnicianService(
        repository: _getIt.get<EvaluationTechnicianRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => EvaluationPhotoService(
        repository: _getIt.get<EvaluationPhotoRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => EvaluationService(
        evaluationRepository: _getIt.get<EvaluationRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => ScheduleRepository(
        remoteDatabase: _getIt.get<RemoteDatabase>(),
        localDatabase: _getIt.get<LocalDatabase>(),
        compressorRepository: _getIt.get<CompressorRepository>(),
        personRepository: _getIt.get<PersonRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => ScheduleService(repository: _getIt.get<ScheduleRepository>()),
    );

    _getIt.registerLazySingleton<AppController>(() => AppController(
          appPreferences: _getIt.get<AppPreferences>(),
        ));

    _getIt.registerLazySingleton<PersonController>(
      () => PersonController(
        personService: _getIt.get<PersonService>(),
      ),
    );

    _getIt.registerLazySingleton<HomeController>(() => HomeController(
          coalescentService: _getIt.get<CoalescentService>(),
          compressorService: _getIt.get<CompressorService>(),
          personService: _getIt.get<PersonService>(),
          scheduleService: _getIt.get<ScheduleService>(),
          evaluationService: _getIt.get<EvaluationService>(),
          appPreferences: _getIt.get<AppPreferences>(),
          customerController: _getIt.get<PersonController>(),
        ));

    _getIt.registerLazySingleton<FilterController>(() => FilterController());

    _getIt.registerLazySingleton<EvaluationController>(
      () => EvaluationController(
        evaluationService: _getIt.get<EvaluationService>(),
        scheduleService: _getIt.get<ScheduleService>(),
        personService: _getIt.get<PersonService>(),
      ),
    );

    _getIt.registerLazySingleton<AppPreferences>(
      () => AppPreferences(
        database: _getIt.get<LocalDatabase>(),
      ),
    );
  }
}
