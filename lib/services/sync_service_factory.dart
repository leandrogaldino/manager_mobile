import 'package:firebase_core/firebase_core.dart';
import 'package:manager_mobile/firebase_options.dart';
import 'package:manager_mobile/repositories/compressor_repository.dart';
import 'package:manager_mobile/repositories/evaluation_coalescent_repository.dart';
import 'package:manager_mobile/repositories/evaluation_performed_service_repository.dart';
import 'package:manager_mobile/repositories/evaluation_photo_repository.dart';
import 'package:manager_mobile/repositories/evaluation_replaced_product_repository.dart';
import 'package:manager_mobile/repositories/evaluation_repository.dart';
import 'package:manager_mobile/repositories/evaluation_technician_repository.dart';
import 'package:manager_mobile/repositories/person_repository.dart';
import 'package:manager_mobile/repositories/personcompressor_repository.dart';
import 'package:manager_mobile/repositories/personcompressorcoalescent_repository.dart';
import 'package:manager_mobile/repositories/product_repository.dart';
import 'package:manager_mobile/repositories/productcode_repository.dart';
import 'package:manager_mobile/repositories/service_repository.dart';
import 'package:manager_mobile/repositories/visit_schedule_repository.dart';
import 'package:manager_mobile/services/sync_service.dart';
import 'package:manager_mobile/services/product_service.dart';
import 'package:manager_mobile/services/productcode_service.dart';
import 'package:manager_mobile/services/service_service.dart';
import 'package:manager_mobile/services/compressor_service.dart';
import 'package:manager_mobile/services/personcompressor_service.dart';
import 'package:manager_mobile/services/personcompressorcoalescent_service.dart';
import 'package:manager_mobile/services/person_service.dart';
import 'package:manager_mobile/services/evaluation_service.dart';
import 'package:manager_mobile/services/visit_schedule_service.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/core/data/firestore_database.dart';
import 'package:manager_mobile/core/data/sqflite_database.dart';
import 'package:manager_mobile/core/data/firebase_cloud_storage.dart';

class SyncServiceFactory {
  static Future<SyncService> create() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // Bancos de dados e storage
    final remoteDb = FirestoreDatabase();
    final localDb = SqfliteDatabase();
    final storage = FirebaseCloudStorage();

    localDb.init();

    // Repositories
    final productCodeRepo = ProductCodeRepository(remoteDatabase: remoteDb, localDatabase: localDb);
    final productRepo = ProductRepository(remoteDatabase: remoteDb, localDatabase: localDb, productCodeRepository: productCodeRepo);
    final serviceRepo = ServiceRepository(remoteDatabase: remoteDb, localDatabase: localDb);
    final compressorRepo = CompressorRepository(remoteDatabase: remoteDb, localDatabase: localDb);
    final personCompressorCoalescentRepo = PersonCompressorCoalescentRepository(
      remoteDatabase: remoteDb,
      localDatabase: localDb,
      productRepository: productRepo,
    );
    final personCompressorRepo = PersonCompressorRepository(
      remoteDatabase: remoteDb,
      localDatabase: localDb,
      personRepository: PersonRepository(remoteDatabase: remoteDb, localDatabase: localDb),
      compressorRepository: compressorRepo,
      personCompressorCoalescentRepository: personCompressorCoalescentRepo,
    );
    final personRepo = PersonRepository(remoteDatabase: remoteDb, localDatabase: localDb);
    final evaluationRepo = EvaluationRepository(
      remoteDatabase: remoteDb,
      localDatabase: localDb,
      storage: storage,
      personCompressorCoalescentRepository: personCompressorCoalescentRepo,
      personCompressorRepository: personCompressorRepo,
      productRepository: productRepo,
      serviceRepository: serviceRepo,
      personRepository: personRepo,
      evaluationCoalescentRepository: EvaluationCoalescentRepository(localDatabase: localDb),
      evaluationReplacedProductRepository: EvaluationReplacedProductRepository(localDatabase: localDb),
      evaluationPerformedServiceRepository: EvaluationPerformedServiceRepository(localDatabase: localDb),
      evaluationTechnicianRepository: EvaluationTechnicianRepository(localDatabase: localDb),
      evaluationPhotoRepository: EvaluationPhotoRepository(localDatabase: localDb),
    );
    final visitScheduleRepo = VisitScheduleRepository(
      remoteDatabase: remoteDb,
      localDatabase: localDb,
      compressorRepository: personCompressorRepo,
      personRepository: personRepo,
    );

    // Services
    final productService = ProductService(productRepository: productRepo);
    final productCodeService = ProductCodeService(productCodeRepository: productCodeRepo);
    final serviceService = ServiceService(serviceRepository: serviceRepo);
    final compressorService = CompressorService(compressorRepository: compressorRepo);
    final personCompressorCoalescentService = PersonCompressorCoalescentService(coalescentRepository: personCompressorCoalescentRepo);
    final personCompressorService = PersonCompressorService(personCompressorRepository: personCompressorRepo);
    final personService = PersonService(personRepository: personRepo);
    final evaluationService = EvaluationService(evaluationRepository: evaluationRepo);
    final visitScheduleService = VisitScheduleService(scheduleRepository: visitScheduleRepo);

    // AppPreferences
    final appPreferences = AppPreferences(database: localDb);

    // SyncService
    return SyncService(
      productService: productService,
      productCodeService: productCodeService,
      serviceService: serviceService,
      compressorService: compressorService,
      personCompressorcoalescentService: personCompressorCoalescentService,
      personCompressorService: personCompressorService,
      personService: personService,
      visitScheduleService: visitScheduleService,
      evaluationService: evaluationService,
      appPreferences: appPreferences,
    );
  }
}
