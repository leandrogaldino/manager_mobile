import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:manager_mobile/core/exceptions/local_database_exception.dart';
import 'package:manager_mobile/core/exceptions/remote_database_exception.dart';
import 'package:manager_mobile/core/exceptions/repository_exception.dart';
import 'package:manager_mobile/core/helper/string_helper.dart';
import 'package:manager_mobile/interfaces/storage.dart';
import 'package:manager_mobile/repositories/personcompressorcoalescent_repository.dart';
import 'package:manager_mobile/repositories/evaluation_coalescent_repository.dart';
import 'package:manager_mobile/repositories/evaluation_photo_repository.dart';
import 'package:manager_mobile/repositories/evaluation_technician_repository.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/repositories/personcompressor_repository.dart';
import 'package:manager_mobile/repositories/person_repository.dart';
import 'package:path_provider/path_provider.dart';

class EvaluationRepository {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;
  final Storage _storage;
  final PersonCompressorCoalescentRepository _coalescentRepository;
  final PersonCompressorRepository _compressorRepository;
  final PersonRepository _personRepository;
  final EvaluationCoalescentRepository _evaluationCoalescentRepository;
  final EvaluationTechnicianRepository _evaluationTechnicianRepository;
  final EvaluationPhotoRepository _evaluationPhotoRepository;
  EvaluationRepository({
    required RemoteDatabase remoteDatabase,
    required LocalDatabase localDatabase,
    required Storage storage,
    required PersonCompressorCoalescentRepository coalescentRepository,
    required PersonCompressorRepository compressorRepository,
    required PersonRepository personRepository,
    required EvaluationCoalescentRepository evaluationCoalescentRepository,
    required EvaluationTechnicianRepository evaluationTechnicianRepository,
    required EvaluationPhotoRepository evaluationPhotoRepository,
  })  : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _storage = storage,
        _coalescentRepository = coalescentRepository,
        _compressorRepository = compressorRepository,
        _personRepository = personRepository,
        _evaluationCoalescentRepository = evaluationCoalescentRepository,
        _evaluationTechnicianRepository = evaluationTechnicianRepository,
        _evaluationPhotoRepository = evaluationPhotoRepository;

  Future<Map<String, Object?>> save(Map<String, Object?> data) async {
    try {
      data['endtime'] = '${TimeOfDay.now().hour.toString()}:${TimeOfDay.now().minute.toString()}';
      data['lastupdate'] = DateTime.now().millisecondsSinceEpoch;
      var coalescentsMap = data['coalescents'] as List<Map<String, Object?>>;
      data.remove('coalescents');
      var techniciansMap = data['technicians'] as List<Map<String, Object?>>;
      data.remove('technicians');
      var photosMap = data['photos'] as List<Map<String, Object?>>;
      data.remove('photos');
      if (data['id'] == null || data['id'] == '') {
        data['id'] = StringHelper.getUniqueString(prefix: data['personcompressorid'].toString());
        await _localDatabase.insert('evaluation', data);
        for (var coalescentMap in coalescentsMap) {
          coalescentMap['evaluationid'] = data['id'];
          coalescentMap = await _evaluationCoalescentRepository.save(coalescentMap);
        }
        for (var technicianMap in techniciansMap) {
          technicianMap['evaluationid'] = data['id'];
          technicianMap = await _evaluationTechnicianRepository.save(technicianMap);
        }
        for (var photoMap in photosMap) {
          photoMap['evaluationid'] = data['id'];
          photoMap = await _evaluationPhotoRepository.save(photoMap);
        }
        data['coalescents'] = coalescentsMap;
        data['technicians'] = techniciansMap;
        data['photos'] = photosMap;
        data = await _processEvaluation(data);

        return data;
      } else {
        throw RepositoryException('EVA001', 'Essa avaliação já foi salva.');
      }
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('EVA002', 'Erro ao salvar os dados: $e');
    }
  }

  Future<List<Map<String, Object?>>> getVisibles() async {
    try {
      List<Map<String, Object?>> evaluations = await _localDatabase.query('evaluation', where: 'visible = ?', whereArgs: [1], orderBy: 'creationdate DESC');
      for (var evaluation in evaluations) {
        evaluation = await _processEvaluation(evaluation);
      }
      return evaluations;
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('EVA003', 'Erro ao obter os dados: $e');
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
    } on Exception catch (e) {
      throw RepositoryException('EVA004', 'Erro ao obter os dados: $e');
    }
  }

  Future<int> delete(dynamic id) async {
    try {
      return await _localDatabase.delete('evaluation', where: 'id = ?', whereArgs: [id as String]);
    } on LocalDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('EVA005', 'Erro ao deletar os dados: $e');
    }
  }

  Future<void> synchronize(int lastSync) async {
    try {
      await _synchronizeFromLocalToCloud(lastSync);
      await _synchronizeFromCloudToLocal(lastSync);
    } on LocalDatabaseException {
      rethrow;
    } on RemoteDatabaseException {
      rethrow;
    } on Exception catch (e) {
      throw RepositoryException('EVA006', 'Erro ao sincronizar os dados: $e');
    }
  }

  Future<String> _saveImage(Uint8List imageData, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(imageData);
      return filePath;
    } catch (e) {
      throw RepositoryException('EVA007', 'Falha ao salvar a imagem no dispositivo.');
    }
  }

  Future<void> _synchronizeFromLocalToCloud(int lastSync) async {
    final localResult = await _localDatabase.query('evaluation', where: 'lastupdate > ?', whereArgs: [lastSync]);
    for (var evaluationMap in localResult) {
      int customerId = await _localDatabase.query('compressor', columns: ['personid'], where: 'id = ?', whereArgs: [evaluationMap['personcompressorid']]).then((v) => v[0]['personid'] as int);
      String customerDocument = await _localDatabase.query('person', columns: ['document'], where: 'id = ?', whereArgs: [customerId]).then((v) => v[0]['document'].toString());
      customerDocument = customerDocument.replaceAll('.', '').replaceFirst('/', '').replaceFirst('-', '');
      String rootPath = '$customerDocument/${evaluationMap['id']}';
      String signFilename = evaluationMap['signaturepath'].toString().split('/').last;
      String signPath = '$rootPath/signature/$signFilename';
      Uint8List signData = await File(evaluationMap['signaturepath'].toString()).readAsBytes();
      await _storage.uploadFile(signPath, signData);
      evaluationMap['signaturepath'] = signPath;

      var photosListMap = await _localDatabase.query('evaluationphoto', columns: ['id', 'path'], where: 'evaluationid = ?', whereArgs: [evaluationMap['id']]);
      for (var photoMap in photosListMap) {
        String photoFilename = photoMap['path'].toString().split('/').last;
        String photoPath = '$rootPath/photo/$photoFilename';
        Uint8List photoData = await File(photoMap['path'].toString()).readAsBytes();
        await _storage.uploadFile(photoPath, photoData);
        photoMap['path'] = photoPath;
      }
      evaluationMap['photos'] = photosListMap;
      var techniciansMap = await _localDatabase.query('evaluationtechnician', columns: ['id', 'ismain', 'personid'], where: 'evaluationid = ?', whereArgs: [evaluationMap['id']]);
      evaluationMap['technicians'] = techniciansMap;
      var coalescentsMap = await _localDatabase.query('evaluationcoalescent', columns: ['id', 'coalescentid', 'nextchange'], where: 'evaluationid = ?', whereArgs: [evaluationMap['id']]);
      evaluationMap['coalescents'] = coalescentsMap;
      evaluationMap.remove('existsincloud');
      evaluationMap.remove('importedid');
      evaluationMap['info'] = {
        'importedid': null,
        'importingdate': null,
        'importingby': null,
        'importedby': null,
        'importeddate': null,
      };
      await _remoteDatabase.set(collection: 'evaluations', data: evaluationMap, id: evaluationMap['id'].toString());
    }
  }

  Future<void> _synchronizeFromCloudToLocal(int lastSync) async {
    bool exists = false;
    final remoteResult = await _remoteDatabase.get(collection: 'evaluations', filters: [RemoteDatabaseFilter(field: 'lastupdate', operator: FilterOperator.isGreaterThan, value: lastSync)]);
    for (var evaluationMap in remoteResult) {
      var technicians = evaluationMap['technicians'];
      for (var technician in technicians) {
        exists = await _localDatabase.isSaved('evaluationtechnician', id: technician['id'] as int);
        technician['evaluationid'] = evaluationMap['id'];
        if (exists) {
          await _localDatabase.update('evaluationtechnician', technician, where: 'id = ?', whereArgs: [evaluationMap['id']]);
        } else {
          await _localDatabase.insert('evaluationtechnician', technician);
        }
      }
      var coalescents = evaluationMap['coalescents'];
      for (var coalescent in coalescents) {
        exists = await _localDatabase.isSaved('evaluationcoalescent', id: coalescent['id'] as int);
        coalescent['evaluationid'] = evaluationMap['id'];
        if (exists) {
          await _localDatabase.update('evaluationcoalescent', coalescent, where: 'id = ?', whereArgs: [evaluationMap['id']]);
        } else {
          await _localDatabase.insert('evaluationcoalescent', coalescent);
        }
      }
      var photos = evaluationMap['photos'];
      for (var photo in photos) {
        exists = await _localDatabase.isSaved('evaluationphoto', id: photo['id'] as int);
        photo['evaluationid'] = evaluationMap['id'];
        var photoData = await _storage.downloadFile(photo['path']);
        if (photoData != null) {
          photo['path'] = await _saveImage(photoData, photo['path'].toString().split('/').last);
        } else {
          photo['path'] = '';
        }
        if (exists) {
          await _localDatabase.update('evaluationphoto', photo, where: 'id = ?', whereArgs: [evaluationMap['id']]);
        } else {
          await _localDatabase.insert('evaluationphoto', photo);
        }
      }
      evaluationMap.remove('documentid');
      evaluationMap.remove('technicians');
      evaluationMap.remove('coalescents');
      evaluationMap.remove('photos');
      var signData = await _storage.downloadFile(evaluationMap['signaturepath']);
      if (signData != null) {
        evaluationMap['signaturepath'] = await _saveImage(signData, evaluationMap['signaturepath'].toString().split('/').last);
      } else {
        evaluationMap['signaturepath'] = '';
      }
      evaluationMap['existsincloud'] = 1;

      evaluationMap['importedid'] = evaluationMap['info']['importedid'];
      evaluationMap.remove('info');

      exists = await _localDatabase.isSaved('evaluation', id: evaluationMap['id']);
      if (exists) {
        await _localDatabase.update('evaluation', evaluationMap, where: 'id = ?', whereArgs: [evaluationMap['id']]);
      } else {
        await _localDatabase.insert('evaluation', evaluationMap);
      }
    }
  }

  Future<Map<String, Object?>> _processEvaluation(Map<String, Object?> evaluationData) async {
    var compressor = await _compressorRepository.getById(evaluationData['personcompressorid'] as int);
    evaluationData['compressor'] = compressor;
    evaluationData.remove('personcompressorid');
    var evaluationCoalescents = await _evaluationCoalescentRepository.getByParentId(evaluationData['id'].toString());
    for (var evaluationCoalescent in evaluationCoalescents) {
      var coalescent = await _coalescentRepository.getById(evaluationCoalescent['coalescentid'] as int);
      evaluationCoalescent['coalescent'] = coalescent;
      evaluationCoalescent.remove('coalescentid');
    }
    evaluationData['coalescents'] = evaluationCoalescents;
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
