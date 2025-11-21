import 'package:get_it/get_it.dart';
import 'package:manager_mobile/controllers/app_controller.dart';
import 'package:manager_mobile/controllers/data_controller.dart';
import 'package:manager_mobile/controllers/evaluation_controller.dart';
import 'package:manager_mobile/controllers/filter_controller.dart';
import 'package:manager_mobile/controllers/home_controller.dart';
import 'package:manager_mobile/controllers/login_controller.dart';
import 'package:manager_mobile/controllers/sync_controller.dart';
import 'package:manager_mobile/core/data/storage_file.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/interfaces/auth.dart';
import 'package:manager_mobile/interfaces/connection.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/interfaces/storage.dart';
import 'package:manager_mobile/repositories/compressor_repository.dart';
import 'package:manager_mobile/repositories/personcompressorcoalescent_repository.dart';
import 'package:manager_mobile/repositories/personcompressor_repository.dart';
import 'package:manager_mobile/repositories/evaluation_coalescent_repository.dart';
import 'package:manager_mobile/repositories/evaluation_photo_repository.dart';
import 'package:manager_mobile/repositories/evaluation_repository.dart';
import 'package:manager_mobile/repositories/evaluation_technician_repository.dart';
import 'package:manager_mobile/repositories/person_repository.dart';
import 'package:manager_mobile/repositories/product_repository.dart';
import 'package:manager_mobile/repositories/productcode_repository.dart';
import 'package:manager_mobile/repositories/visit_schedule_repository.dart';
import 'package:manager_mobile/repositories/service_repository.dart';
import 'package:manager_mobile/services/auth_service.dart';
import 'package:manager_mobile/core/util/network_connection.dart';
import 'package:manager_mobile/core/data/firestore_database.dart';
import 'package:manager_mobile/core/data/sqflite_database.dart';
import 'package:manager_mobile/services/compressor_service.dart';
import 'package:manager_mobile/services/personcompressorcoalescent_service.dart';
import 'package:manager_mobile/services/personcompressor_service.dart';

import 'package:manager_mobile/services/evaluation_service.dart';
import 'package:manager_mobile/services/person_service.dart';
import 'package:manager_mobile/services/product_service.dart';
import 'package:manager_mobile/services/productcode_service.dart';
import 'package:manager_mobile/services/visit_schedule_service.dart';
import 'package:manager_mobile/services/service_service.dart';

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
        appPreferences: _getIt.get<AppPreferences>(),
      ),
    );

    _getIt.registerLazySingleton(() => ProductRepository(
          remoteDatabase: _getIt.get<RemoteDatabase>(),
          localDatabase: _getIt.get<LocalDatabase>(),
          productCodeRepository: _getIt.get<ProductCodeRepository>(),
        ));

    _getIt.registerLazySingleton(
      () => ProductService(
        productRepository: _getIt.get<ProductRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => ProductCodeRepository(
        remoteDatabase: _getIt.get<RemoteDatabase>(),
        localDatabase: _getIt.get<LocalDatabase>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => ProductCodeService(
        productCodeRepository: _getIt.get<ProductCodeRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => ServiceRepository(
        remoteDatabase: _getIt.get<RemoteDatabase>(),
        localDatabase: _getIt.get<LocalDatabase>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => ServiceService(
        serviceRepository: _getIt.get<ServiceRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => CompressorRepository(
        remoteDatabase: _getIt.get<RemoteDatabase>(),
        localDatabase: _getIt.get<LocalDatabase>(),
      ),
    );
    _getIt.registerLazySingleton(
      () => CompressorService(
        compressorRepository: _getIt.get<CompressorRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => PersonCompressorCoalescentRepository(
        remoteDatabase: _getIt.get<RemoteDatabase>(),
        localDatabase: _getIt.get<LocalDatabase>(),
        productRepository: _getIt.get<ProductRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => PersonCompressorCoalescentService(
        coalescentRepository: _getIt.get<PersonCompressorCoalescentRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => PersonCompressorRepository(
        remoteDatabase: _getIt.get<RemoteDatabase>(),
        localDatabase: _getIt.get<LocalDatabase>(),
        personRepository: _getIt.get<PersonRepository>(),
        compressorRepository: _getIt.get<CompressorRepository>(),
        personCompressorCoalescentRepository: _getIt.get<PersonCompressorCoalescentRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => PersonCompressorService(
        personCompressorRepository: _getIt.get<PersonCompressorRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => PersonRepository(
        remoteDatabase: _getIt.get<RemoteDatabase>(),
        localDatabase: _getIt.get<LocalDatabase>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => PersonService(
        personRepository: _getIt.get<PersonRepository>(),
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
        coalescentRepository: _getIt.get<PersonCompressorCoalescentRepository>(),
        compressorRepository: _getIt.get<PersonCompressorRepository>(),
        personRepository: _getIt.get<PersonRepository>(),
        evaluationCoalescentRepository: _getIt.get<EvaluationCoalescentRepository>(),
        evaluationTechnicianRepository: _getIt.get<EvaluationTechnicianRepository>(),
        evaluationPhotoRepository: _getIt.get<EvaluationPhotoRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => EvaluationService(
        evaluationRepository: _getIt.get<EvaluationRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => VisitScheduleRepository(
        remoteDatabase: _getIt.get<RemoteDatabase>(),
        localDatabase: _getIt.get<LocalDatabase>(),
        compressorRepository: _getIt.get<PersonCompressorRepository>(),
        personRepository: _getIt.get<PersonRepository>(),
      ),
    );

    _getIt.registerLazySingleton(
      () => VisitScheduleService(scheduleRepository: _getIt.get<VisitScheduleRepository>()),
    );

    _getIt.registerLazySingleton<AppController>(() => AppController(
          appPreferences: _getIt.get<AppPreferences>(),
        ));

    _getIt.registerLazySingleton<DataController>(
      () => DataController(
        visitScheduleService: _getIt.get<VisitScheduleService>(),
        evaluationService: _getIt.get<EvaluationService>(),
        personService: _getIt.get<PersonService>(),
        compressorService: _getIt.get<PersonCompressorService>(),
      ),
    );

    _getIt.registerLazySingleton<SyncController>(() => SyncController(
          productService: _getIt.get<ProductService>(),
          productCodeService: _getIt.get<ProductCodeService>(),
          serviceService: _getIt.get<ServiceService>(),
          compressorService: _getIt.get<CompressorService>(),
          personCompressorcoalescentService: _getIt.get<PersonCompressorCoalescentService>(),
          personCompressorService: _getIt.get<PersonCompressorService>(),
          personService: _getIt.get<PersonService>(),
          appPreferences: _getIt.get<AppPreferences>(),
          visitScheduleService: _getIt.get<VisitScheduleService>(),
          evaluationService: _getIt.get<EvaluationService>(),
          personController: _getIt.get<DataController>(),
          filterController: _getIt.get<FilterController>(),
        ));

    _getIt.registerLazySingleton<HomeController>(() => HomeController(
          syncController: _getIt.get<SyncController>(),
          dataController: _getIt.get<DataController>(),
          filterController: _getIt.get<FilterController>(),
        ));

    _getIt.registerLazySingleton<FilterController>(() => FilterController());

    _getIt.registerLazySingleton<EvaluationController>(
      () => EvaluationController(
        evaluationService: _getIt.get<EvaluationService>(),
        scheduleService: _getIt.get<VisitScheduleService>(),
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
