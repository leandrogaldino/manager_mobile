import 'dart:developer';
import 'package:flutter_test/flutter_test.dart';
import 'package:manager_mobile/core/data/sqflite_database.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/models/coalescent_model.dart';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/repositories/coalescent_repository.dart';
import 'package:manager_mobile/repositories/compressor_repository.dart';
import 'package:manager_mobile/repositories/person_repository.dart';
import 'package:manager_mobile/services/coalescent_service.dart';
import 'package:manager_mobile/services/person_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../fake_firestore_database.dart';

void main() {
  late LocalDatabase localDatabase;
  late RemoteDatabase remoteDatabase;
  late PersonService personService;
  setUp(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    localDatabase = SqfliteDatabase();
    await localDatabase.init(inMemory: true);
    remoteDatabase = FakeFirestoreDatabase();
    CoalescentRepository coalescentRepository = CoalescentRepository(remoteDatabase: remoteDatabase, localDatabase: localDatabase);
    CompressorRepository compressorRepository = CompressorRepository(remoteDatabase: remoteDatabase, localDatabase: localDatabase, coalescentRepository: coalescentRepository);
    PersonRepository personRepository = PersonRepository(remoteDatabase: remoteDatabase, localDatabase: localDatabase, compressorRepository: compressorRepository);
    personService = PersonService(repository: personRepository);
    log('Configurações iniciais concluídas');
  });
  testWidgets('coalescent service ...', (tester) async {
    CoalescentModel coalescent1 = CoalescentModel(id: 1, statusId: 0, coalescentName: 'EFS 70U', lastUpdate: DateTime.now());
    CoalescentModel coalescent2 = CoalescentModel(id: 2, statusId: 0, coalescentName: 'EFS 70H', lastUpdate: DateTime.now());
    CoalescentModel coalescent3 = CoalescentModel(id: 3, statusId: 0, coalescentName: 'EFS 125U', lastUpdate: DateTime.now());
    CoalescentModel coalescent4 = CoalescentModel(id: 4, statusId: 0, coalescentName: 'EFS 125H', lastUpdate: DateTime.now());
    CompressorModel compressor1 = CompressorModel(id: 1, statusId: 0, compressorId: 1, compressorName: 'SRP 4015', lastUpdate: DateTime.now(), serialNumber: '123', coalescents: [coalescent1, coalescent2]);
    CompressorModel compressor2 = CompressorModel(id: 1, statusId: 0, compressorId: 1, compressorName: 'SRP 4030', lastUpdate: DateTime.now(), serialNumber: '456', coalescents: [coalescent3, coalescent4]);
    PersonModel model = PersonModel(id: 1, statusId: 0, document: '01653915102', isCustomer: true, isTechnician: true, lastUpdate: DateTime.now(), shortName: 'Leandro', compressors: [compressor1, compressor2]);
    var id = await personService.save(model);
    var c = await personService.getById(1);

    expect(id, 1);
  });
}
