import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/core/helper/datetime_helper.dart';
import 'package:manager_mobile/core/helper/string_helper.dart';
import 'package:manager_mobile/interfaces/storage.dart';
import 'package:manager_mobile/repositories/evaluation_performed_service_repository.dart';
import 'package:manager_mobile/repositories/evaluation_replaced_product_repository.dart';
import 'package:manager_mobile/repositories/personcompressorcoalescent_repository.dart';
import 'package:manager_mobile/repositories/evaluation_coalescent_repository.dart';
import 'package:manager_mobile/repositories/evaluation_image_repository.dart';
import 'package:manager_mobile/repositories/evaluation_technician_repository.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/repositories/personcompressor_repository.dart';
import 'package:manager_mobile/repositories/person_repository.dart';
import 'package:manager_mobile/repositories/product_repository.dart';
import 'package:manager_mobile/repositories/service_repository.dart';
import 'package:manager_mobile/services/image_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:path/path.dart' as path;

class EvaluationRepository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;
  final Storage _storage;

  final PersonCompressorCoalescentRepository _personCompressorCoalescentRepository;
  final PersonCompressorRepository _personCompressorRepository;
  final PersonRepository _personRepository;
  final ProductRepository _productRepository;
  final ServiceRepository _serviceRepository;
  final EvaluationCoalescentRepository _evaluationCoalescentRepository;
  final EvaluationReplacedProductRepository _evaluationReplacedProductRepository;
  final EvaluationPerformedServiceRepository _evaluationPerformedServiceRepository;
  final EvaluationTechnicianRepository _evaluationTechnicianRepository;
  final EvaluationImageRepository _evaluationPhotoRepository;
  EvaluationRepository({
    required RemoteDatabase remoteDatabase,
    required LocalDatabase localDatabase,
    required Storage storage,
    required ImageService imageService,
    required PersonCompressorCoalescentRepository personCompressorCoalescentRepository,
    required PersonCompressorRepository personCompressorRepository,
    required PersonRepository personRepository,
    required ProductRepository productRepository,
    required ServiceRepository serviceRepository,
    required EvaluationCoalescentRepository evaluationCoalescentRepository,
    required EvaluationReplacedProductRepository evaluationReplacedProductRepository,
    required EvaluationPerformedServiceRepository evaluationPerformedServiceRepository,
    required EvaluationTechnicianRepository evaluationTechnicianRepository,
    required EvaluationImageRepository evaluationPhotoRepository,
  })  : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _storage = storage,
        _personCompressorCoalescentRepository = personCompressorCoalescentRepository,
        _personCompressorRepository = personCompressorRepository,
        _personRepository = personRepository,
        _productRepository = productRepository,
        _serviceRepository = serviceRepository,
        _evaluationCoalescentRepository = evaluationCoalescentRepository,
        _evaluationReplacedProductRepository = evaluationReplacedProductRepository,
        _evaluationPerformedServiceRepository = evaluationPerformedServiceRepository,
        _evaluationTechnicianRepository = evaluationTechnicianRepository,
        _evaluationPhotoRepository = evaluationPhotoRepository;

  Future<bool> get hasPendingEvaluation async {
    var result = await _localDatabase.rawQuery("""
      SELECT COUNT(*) count
      FROM evaluation
      WHERE
        signaturepath IS NULL OR 
        signaturepath = '';
      """);
    if (result.isEmpty) return false;
    if (result[0]['count'] as int > 0) return true;
    return false;
  }

  Future<DateTime> get minimumDate async {
    DateTime minDate;
    var result = await _localDatabase.rawQuery('''
      SELECT MIN(creationdate) AS oldest
      FROM evaluation;
      ''');
    if (result.isEmpty || result[0]['oldest'] == null) {
      minDate = DateTime(2000, 1, 1);
    } else {
      minDate = DateTimeHelper.fromMillisecondsSinceEpoch(result[0]['oldest'] as int);
    }
    return minDate;
  }

  Future<DateTime> get maximumDate async {
    DateTime maxDate;
    var result = await _localDatabase.rawQuery('''
      SELECT MAX(creationdate) AS newest
      FROM evaluation;
      ''');
    if (result.isEmpty || result[0]['newest'] == null) {
      maxDate = DateTime(2100, 1, 1);
    } else {
      maxDate = DateTimeHelper.fromMillisecondsSinceEpoch(result[0]['newest'] as int);
    }
    return maxDate;
  }

  Future<Map<String, Object?>> save(Map<String, Object?> data, int? visitScheduleId) async {
    var coalescentsMap = data['coalescents'] as List<Map<String, Object?>>;
    data.remove('coalescents');
    var replacedProductsMap = data['replacedproducts'] as List<Map<String, Object?>>;
    data.remove('replacedproducts');
    var performedServicesMap = data['performedservices'] as List<Map<String, Object?>>;
    data.remove('performedservices');
    var techniciansMap = data['technicians'] as List<Map<String, Object?>>;
    data.remove('technicians');
    var photosMap = data['photos'] as List<Map<String, Object?>>;
    data.remove('photos');
    data['lastupdate'] = DateTimeHelper.now().millisecondsSinceEpoch;
    var signatureMap = data['signature'] as Map<String, Object?>;
    data.remove('signature');
    data['signaturepath'] = signatureMap['localpath'] as String;
    try {
      String? id = data['id'] as String?;
      bool isInsert = (id == null || id == '');
      data['endtime'] = DateTimeHelper.formatTime(DateTimeHelper.now());
      if (isInsert) {
        id = StringHelper.getUniqueString(prefix: data['compressorid'].toString());
        data['id'] = id;
        visitScheduleId == null ? data['visitscheduleid'] = null : data['visitscheduleid'] = visitScheduleId;
        await _localDatabase.insert('evaluation', data);
      } else {
        id = data['id'] as String;
        data.remove('id');
        await _localDatabase.update('evaluation', data, where: 'id = ?', whereArgs: [id]);
      }

      await _evaluationCoalescentRepository.deleteByParentId(id);
      for (var coalescentMap in coalescentsMap) {
        coalescentMap['evaluationid'] = id;
        coalescentMap = await _evaluationCoalescentRepository.save(coalescentMap);
      }

      await _evaluationReplacedProductRepository.deleteByParentId(id);
      for (var replacedProductMap in replacedProductsMap) {
        replacedProductMap['evaluationid'] = id;
        replacedProductMap = await _evaluationReplacedProductRepository.save(replacedProductMap);
      }

      await _evaluationPerformedServiceRepository.deleteByParentId(id);
      for (var performedServiceMap in performedServicesMap) {
        performedServiceMap['evaluationid'] = id;
        performedServiceMap = await _evaluationPerformedServiceRepository.save(performedServiceMap);
      }

      await _evaluationTechnicianRepository.deleteByParentId(id);
      for (var technicianMap in techniciansMap) {
        technicianMap['evaluationid'] = id;
        technicianMap = await _evaluationTechnicianRepository.save(technicianMap);
      }

      await _evaluationPhotoRepository.deleteByParentId(id);
      for (var photoMap in photosMap) {
        photoMap['evaluationid'] = id;
        photoMap = await _evaluationPhotoRepository.save(photoMap);
      }
      data['coalescents'] = coalescentsMap;
      data['replacedproducts'] = replacedProductsMap;
      data['performedservices'] = performedServicesMap;
      data['technicians'] = techniciansMap;
      data['photos'] = photosMap;
      data = await _processEvaluation(data);

      return data;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'EVA002';
      String message = 'Erro ao salvar os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<List<Map<String, Object?>>> searchVisibles({
    required int offset,
    required int limit,
    String? search,
    DateTime? initialDate,
    DateTime? finalDate,
  }) async {
    try {
      String where = 'e.visible = ?';
      List<Object?> whereArgs = [1];

      if (search != null && search.trim().isNotEmpty) {
        where += ' AND (c.name LIKE ? OR p.shortname LIKE ? OR pc.serialnumber LIKE ? OR pc.patrimony LIKE ? OR pc.sector LIKE ?)';
        whereArgs.add('%$search%');
        whereArgs.add('%$search%');
        whereArgs.add('%$search%');
        whereArgs.add('%$search%');
        whereArgs.add('%$search%');
      }
      if (initialDate != null) {
        final start = DateTime(
          initialDate.year,
          initialDate.month,
          initialDate.day,
        );

        where += ' AND e.creationdate >= ?';
        whereArgs.add(start.millisecondsSinceEpoch);
      }

      if (finalDate != null) {
        final endExclusive = DateTime(
          finalDate.year,
          finalDate.month,
          finalDate.day + 1,
        );

        where += ' AND e.creationdate < ?';
        whereArgs.add(endExclusive.millisecondsSinceEpoch);
      }
      whereArgs.addAll([limit, offset]);

      final evaluations = await _localDatabase.rawQuery(
        '''
      SELECT e.*
      FROM evaluation e
      JOIN person p ON p.id = e.customerid
      JOIN personcompressor pc ON pc.id = e.compressorid
      JOIN compressor c ON c.id = pc.compressorid
      WHERE $where
      ORDER BY e.creationdate DESC
      LIMIT ? OFFSET ?;
      ''',
        whereArgs,
      );

      for (int i = 0; i < evaluations.length; i++) {
        evaluations[i] = await _processEvaluation(evaluations[i]);
      }

      return evaluations;
    } on LocalDatabaseException {
      rethrow;
    } catch (e, s) {
      const code = 'EVA003';
      const message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<List<Map<String, Object?>>> getAll() async {
    try {
      List<Map<String, Object?>> evaluations = await _localDatabase.query('evaluation');
      for (var evaluation in evaluations) {
        evaluation = await _processEvaluation(evaluation);
      }
      return evaluations;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'EVA004';
      String message = 'Erro ao obter os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<int> delete(dynamic id) async {
    try {
      return await _localDatabase.delete('evaluation', where: 'id = ?', whereArgs: [id as String]);
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'EVA005';
      String message = 'Erro ao deletar os dados';
      log('[$code] $message', time: DateTimeHelper.now(), error: e, stackTrace: s);
      throw RepositoryException(code, message);
    }
  }

  Future<int> synchronize(
    int lastSync, {
    void Function(String id)? onItemSynced,
  }) async {
    int count = 0;
    try {
      await _synchronizeFromLocalToCloud(
        lastSync,
        onItemSynced: onItemSynced,
      );

      count = await _synchronizeFromCloudToLocal(
        lastSync,
        onItemSynced: onItemSynced,
      );

      return count;
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } on Exception catch (e, s) {
      String code = 'EVA006';
      String message = 'Erro ao sincronizar os dados';
      log(
        '[$code] $message',
        time: DateTimeHelper.now(),
        error: e,
        stackTrace: s,
      );
      throw RepositoryException(code, message);
    }
  }

  Future<void> _synchronizeFromLocalToCloud(
    int lastSync, {
    void Function(String id)? onItemSynced,
  }) async {
    final localResult = await _localDatabase.query(
      'evaluation',
      where: 'lastupdate > ?',
      whereArgs: [lastSync],
    );

    for (var evaluationMap in localResult) {
      if (evaluationMap['signaturepath'] == null) continue;

      var cloudResult = await _remoteDatabase.get(collection: 'evaluations', filters: [RemoteDatabaseFilter(field: 'id', operator: FilterOperator.isEqualTo, value: evaluationMap['id'])]);
      var existsInCloud = cloudResult.isNotEmpty;

      if (existsInCloud) continue;

      final String evaluationId = evaluationMap['id'].toString();

      int customerId = await _localDatabase
          .query(
            'personcompressor',
            columns: ['personid'],
            where: 'id = ?',
            whereArgs: [evaluationMap['compressorid']],
          )
          .then((v) => v[0]['personid'] as int);

      String customerDocument = await _localDatabase
          .query(
            'person',
            columns: ['document'],
            where: 'id = ?',
            whereArgs: [customerId],
          )
          .then((v) => v[0]['document'].toString());

      customerDocument = customerDocument.replaceAll('.', '').replaceFirst('/', '').replaceFirst('-', '');

      String rootPath = '$customerDocument/$evaluationId';

      //Assinatura
      String signFilename = path.basename(evaluationMap['signaturepath'].toString());
      String signPath = '$rootPath/signature/$signFilename';
      Uint8List signData = await File(evaluationMap['signaturepath'].toString()).readAsBytes();
      await _storage.uploadFile(signPath, signData);
      await WakelockPlus.enable();
      evaluationMap['signaturepath'] = signPath;

      // Fotos
      var photosListMap = await _evaluationPhotoRepository.getByParentId(evaluationId);
      for (var photoMap in photosListMap) {
        String photoFilename = path.basename(photoMap['path'].toString());
        String photoPath = '$rootPath/photo/$photoFilename';
        Uint8List photoData = await File(photoMap['path'].toString()).readAsBytes();
        await _storage.uploadFile(photoPath, photoData);
        await WakelockPlus.enable();
        photoMap['path'] = photoPath;
      }
      for (final item in photosListMap) {
        item.remove('id');
      }
      evaluationMap['photos'] = photosListMap;

      // Relacionamentos
      var replacedProductsMap = await _evaluationReplacedProductRepository.getByParentId(evaluationId);
      for (final item in replacedProductsMap) {
        item.remove('id');
      }
      evaluationMap['replacedproducts'] = replacedProductsMap;

      var performedServicesMap = await _evaluationPerformedServiceRepository.getByParentId(evaluationId);
      for (final item in performedServicesMap) {
        item.remove('id');
      }
      evaluationMap['performedservices'] = performedServicesMap;

      var techniciansMap = await _evaluationTechnicianRepository.getByParentId(evaluationId);
      for (final item in techniciansMap) {
        item.remove('id');
      }
      evaluationMap['technicians'] = techniciansMap;

      var coalescentsMap = await _evaluationCoalescentRepository.getByParentId(evaluationId);
      for (final item in coalescentsMap) {
        item['ignorenextchange'] == 0 ? item['ignorenextchange'] = false : item['ignorenextchange'] = true;
        item.remove('id');
      }
      evaluationMap['coalescents'] = coalescentsMap;

      // Limpeza e ajustes
      evaluationMap.remove('importedid');
      if (evaluationMap['existsincloud'] == 0) {
        evaluationMap['info'] = {
          'importedid': null,
          'importingdate': null,
          'importingby': null,
          'importedby': null,
          'importeddate': null,
          'visitscheduleid': evaluationMap['visitscheduleid'],
          'requestprocessed': (evaluationMap['replacedproducts'] as List<Map<String, Object?>>).isEmpty ? true : false,
          'hasreplacedproducts': (evaluationMap['replacedproducts'] as List<Map<String, Object?>>).isNotEmpty,
        };
      }
      evaluationMap.remove('existsincloud');
      evaluationMap.remove('visitscheduleid');
      evaluationMap['lastupdate'] = DateTimeHelper.now().millisecondsSinceEpoch;

      // Envio para a núvem
      await _remoteDatabase.set(
        collection: 'evaluations',
        data: evaluationMap,
        id: evaluationId,
      );

      // Atualização local
      await _localDatabase.update(
        'evaluation',
        {'existsincloud': 1},
        where: 'id = ?',
        whereArgs: [evaluationId],
      );

      // Callback por item
      onItemSynced?.call(evaluationId);
    }
  }

  Future<int> _synchronizeFromCloudToLocal(int lastSync, {void Function(String id)? onItemSynced}) async {
    int count = 0;

    //Obtem as avaliações da núvem
    final remoteResult = await _remoteDatabase.get(collection: 'evaluations', filters: [
      RemoteDatabaseFilter(
        field: 'lastupdate',
        operator: FilterOperator.isGreaterThan,
        value: lastSync,
      ),
    ]);

    // Itera sobre as avaliações
    for (var evaluationMap in remoteResult) {
      final String evaluationId = evaluationMap['id'].toString();

      // Caso a avaliação já exista, apenas sincroniza o Id importado e a data da ultima atualização.
      final exists = await _localDatabase.isSaved('evaluation', id: evaluationId);
      if (exists) {
        var importedId = evaluationMap['info']['importedid'];
        var lastUpdate = evaluationMap['lastupdate'];
        await _localDatabase.update(
          'evaluation',
          {'importedid': importedId, 'lastupdate': lastUpdate},
          where: 'id = ?',
          whereArgs: [evaluationId],
        );
        continue;
      }

      // Caso seja nova avaliação, faz a transferência total
      // Filhos
      await _evaluationReplacedProductRepository.deleteByParentId(evaluationId);
      for (var replacedProduct in evaluationMap['replacedproducts']) {
        replacedProduct['evaluationid'] = evaluationId;
        await _evaluationReplacedProductRepository.save(replacedProduct);
      }
      await _evaluationPerformedServiceRepository.deleteByParentId(evaluationId);
      for (var performedService in evaluationMap['performedservices']) {
        performedService['evaluationid'] = evaluationId;
        await _evaluationPerformedServiceRepository.save(performedService);
      }
      await _evaluationTechnicianRepository.deleteByParentId(evaluationId);
      for (var technician in evaluationMap['technicians']) {
        technician['evaluationid'] = evaluationId;
        await _evaluationTechnicianRepository.save(technician);
      }
      await _evaluationCoalescentRepository.deleteByParentId(evaluationId);
      for (var coalescent in evaluationMap['coalescents']) {
        coalescent['evaluationid'] = evaluationId;
        await _evaluationCoalescentRepository.save(coalescent);
      }

      // Fotos
      await _evaluationPhotoRepository.deleteByParentId(evaluationId);
      for (var photo in evaluationMap['photos']) {
        photo['evaluationid'] = evaluationId;
        //var photoData = await _storage.downloadFile(photo['path']);
        //await WakelockPlus.enable();
        //if (photoData != null) {
        //photo['path'] = await _saveImage(photoData, photo['path'].toString().split('/').last);
        //} else {
        //photo['path'] = '';
        //}
        await _evaluationPhotoRepository.save(photo);
      }

      // ---- assinatura ----
      //var signData = await _storage.downloadFile(evaluationMap['signaturepath']);
      //await WakelockPlus.enable();
      //if (signData != null) {
      //evaluationMap['signaturepath'] = await _saveImage(
      //signData,
      //evaluationMap['signaturepath'].toString().split('/').last,
      //);
      //} else {
      ///evaluationMap['signaturepath'] = '';
      //}

      //Info
      evaluationMap['existsincloud'] = 1;
      evaluationMap['importedid'] = evaluationMap['info']['importedid'];

      // Limpeza
      evaluationMap.remove('documentid');
      evaluationMap.remove('replacedproducts');
      evaluationMap.remove('performedservices');
      evaluationMap.remove('technicians');
      evaluationMap.remove('coalescents');
      evaluationMap.remove('photos');
      evaluationMap.remove('info');

      await _localDatabase.insert('evaluation', evaluationMap);
      count++;

      // Callback por item novo
      onItemSynced?.call(evaluationId);

      log('......................$count AVALIACOES SINCRONIZADAS......................');
    }
    return count;
  }

  Future<Map<String, Object?>> _processEvaluation(Map<String, Object?> evaluationData) async {
    var customer = await _personRepository.getById(evaluationData['customerid'] as int);
    evaluationData['customer'] = customer;
    evaluationData.remove('customerid');

    var compressor = await _personCompressorRepository.getById(evaluationData['compressorid'] as int);
    evaluationData['compressor'] = compressor;
    evaluationData.remove('compressorid');
    var evaluationCoalescents = await _evaluationCoalescentRepository.getByParentId(evaluationData['id'].toString());
    for (var evaluationCoalescent in evaluationCoalescents) {
      var coalescent = await _personCompressorCoalescentRepository.getById(evaluationCoalescent['coalescentid'] as int);
      evaluationCoalescent['coalescent'] = coalescent;
      evaluationCoalescent['ignorenextchange'] == 0 ? evaluationCoalescent['ignorenextchange'] = false : evaluationCoalescent['ignorenextchange'] = true;

      evaluationCoalescent.remove('coalescentid');
    }
    evaluationData['coalescents'] = evaluationCoalescents;

    var replacedProducts = await _evaluationReplacedProductRepository.getByParentId(evaluationData['id'].toString());
    for (var replacedProduct in replacedProducts) {
      var product = await _productRepository.getById(replacedProduct['productid'] as int);
      replacedProduct['product'] = product;
      replacedProduct.remove('productid');
      replacedProduct.remove('evaluationid');
    }
    evaluationData['replacedproducts'] = replacedProducts;

    var performedServices = await _evaluationPerformedServiceRepository.getByParentId(evaluationData['id'].toString());
    for (var performedService in performedServices) {
      var service = await _serviceRepository.getById(performedService['serviceid'] as int);
      performedService['service'] = service;
      performedService.remove('serviceid');
      performedService.remove('evaluationid');
    }
    evaluationData['performedservices'] = performedServices;

    var technicians = await _evaluationTechnicianRepository.getByParentId(evaluationData['id'].toString());
    for (var technician in technicians) {
      var person = await _personRepository.getById(technician['personid'] as int);
      technician['technician'] = person;
      technician.remove('personid');
      technician.remove('evaluationid');
    }

    evaluationData['technicians'] = technicians;
    var photos = await _evaluationPhotoRepository.getByParentId(evaluationData['id'].toString());
    evaluationData['photos'] = photos;

    return evaluationData;
  }
}
