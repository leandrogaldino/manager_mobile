import 'dart:io';
import 'dart:typed_data';

import 'package:manager_mobile/interfaces/deletable.dart';
import 'package:manager_mobile/interfaces/storage.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';
import 'package:manager_mobile/interfaces/writable.dart';
import 'package:manager_mobile/repositories/evaluation_coalescent_repository.dart';
import 'package:manager_mobile/repositories/evaluation_info_repository.dart';
import 'package:manager_mobile/repositories/evaluation_photo_repository.dart';
import 'package:manager_mobile/repositories/evaluation_technician_repository.dart';
import 'package:manager_mobile/interfaces/local_database.dart';
import 'package:manager_mobile/interfaces/remote_database.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';
import 'package:manager_mobile/repositories/compressor_repository.dart';
import 'package:manager_mobile/repositories/person_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class EvaluationRepository implements Readable<Map<String, Object?>>, Writable<Map<String, Object?>>, Deletable, Syncronizable {
  final RemoteDatabase _remoteDatabase;
  final LocalDatabase _localDatabase;
  final Storage _storage;
  final CompressorRepository _compressorRepository;
  final PersonRepository _personRepository;
  final EvaluationCoalescentRepository _evaluationCoalescentRepository;
  final EvaluationTechnicianRepository _evaluationTechnicianRepository;
  final EvaluationPhotoRepository _evaluationPhotoRepository;
  final EvaluationInfoRepository _evaluationInfoRepository;
  EvaluationRepository(
      {required RemoteDatabase remoteDatabase,
      required LocalDatabase localDatabase,
      required Storage storage,
      required CompressorRepository compressorRepository,
      required PersonRepository personRepository,
      required EvaluationCoalescentRepository evaluationCoalescentRepository,
      required EvaluationTechnicianRepository evaluationTechnicianRepository,
      required EvaluationPhotoRepository evaluationPhotoRepository,
      required EvaluationInfoRepository evaluationInfoRepository})
      : _remoteDatabase = remoteDatabase,
        _localDatabase = localDatabase,
        _storage = storage,
        _compressorRepository = compressorRepository,
        _personRepository = personRepository,
        _evaluationCoalescentRepository = evaluationCoalescentRepository,
        _evaluationTechnicianRepository = evaluationTechnicianRepository,
        _evaluationPhotoRepository = evaluationPhotoRepository,
        _evaluationInfoRepository = evaluationInfoRepository;

  @override
  Future<int> delete(dynamic id) async {
    return await _localDatabase.delete('evaluation', where: 'id = ?', whereArgs: [id as String]);
  }

  @override
  Future<List<Map<String, Object?>>> getAll() async {
    var evaluations = await _localDatabase.query('evaluation');
    for (var evaluation in evaluations) {
      var compressor = await _compressorRepository.getById(evaluation['compressorid'] as int);
      evaluation['compressor'] = compressor;

      var customer = await _personRepository.getById(evaluation['customerid'] as int);
      evaluation['customer'] = customer;

      var coalescents = await _evaluationCoalescentRepository.getByParentId(evaluation['id'] as int);
      evaluation['coalescents'] = coalescents;

      var technicians = await _evaluationTechnicianRepository.getByParentId(evaluation['id'] as int);
      evaluation['technicians'] = technicians;

      var photos = await _evaluationPhotoRepository.getByParentId(evaluation['id'] as int);
      evaluation['photospaths'] = photos;

      var info = await _evaluationInfoRepository.getByParentId(evaluation['id'] as int).then((i) => i.first);
      evaluation['info'] = info;
    }

    return evaluations;
  }

  Future<String> _saveImage(Uint8List imageData, String fileName) async {
    try {
      // Obtém o diretório apropriado para salvar o arquivo
      final directory = await getApplicationDocumentsDirectory();

      // Cria o caminho completo para o arquivo
      final filePath = '${directory.path}/$fileName';

      // Cria e escreve os dados no arquivo
      final file = File(filePath);
      await file.writeAsBytes(imageData);

      print('Imagem salva em: $filePath');
      return filePath;
    } catch (e) {
      print('Erro ao salvar a imagem: $e');
      throw Exception('Falha ao salvar a imagem no disco.');
    }
  }

  @override
  Future<SyncronizeResultModel> syncronize() async {
    int downloadedData = 0;
    int uploadedData = 0;
    bool exists = false;
    final lastSyncResult = await _localDatabase.query('preferences', columns: ['value'], where: 'key = ?', whereArgs: ['lastsync']);
    int lastSync = int.parse(lastSyncResult[0]['value'].toString());

    //TODO Terminar de fazer LOCAL PARA A NUVEM
    //DO LOCAL PARA A NUVEM
    final localResult = await _localDatabase.query('evaluation', where: 'lastupdate > ?', whereArgs: [lastSync]);
    for (var evaluationMap in localResult) {}

    //DA NUVEM PARA LOCAL
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

      var signature = await _storage.downloadFile(evaluationMap['signatureurl']);
      if (signature != null) {
        evaluationMap['signaturepath'] = await _saveImage(signature, evaluationMap['signatureurl'].toString().split('/').last);
      } else {
        evaluationMap['signaturepath'] = '';
      }

      evaluationMap.remove('signatureurl');

      evaluationMap['importedid'] = evaluationMap['info']['importedid'];
      evaluationMap['importedby'] = evaluationMap['info']['importedby'];
      evaluationMap['importeddate'] = evaluationMap['info']['importeddate'];

      evaluationMap.remove('info');

      exists = await _localDatabase.isSaved('evaluation', id: evaluationMap['id']);
      if (exists) {
        await _localDatabase.update('evaluation', evaluationMap, where: 'id = ?', whereArgs: [evaluationMap['id']]);
      } else {
        await _localDatabase.insert('evaluation', evaluationMap);
      }

      downloadedData += 1;
    }

    return SyncronizeResultModel(uploaded: uploadedData, downloaded: downloadedData);
  }

  @override
  Future<Map<String, Object?>> getById(int id) async {
    final Map<String, Object?> person = await _localDatabase.query('person', where: 'id = ?', whereArgs: [id]).then((list) {
      if (list.isEmpty) return {};
      return list[0];
    });
    var compressors = await _compressorRepository.getByParentId(person['id'] as int);
    person['compressors'] = compressors;
    return person;
  }

  @override
  Future<List<Map<String, Object?>>> getByLastUpdate(DateTime lastUpdate) async {
    var persons = await _localDatabase.query('person', where: 'lastupdate = ?', whereArgs: [lastUpdate]);
    for (var person in persons) {
      var compressors = await _compressorRepository.getByParentId(person['id'] as int);
      person['compressors'] = compressors;
    }
    return persons;
  }

  @override
  Future<int> save(Map<String, Object?> data) async {
    if (data['id'] == 0) {
      return await _localDatabase.insert('person', data);
    } else {
      await _localDatabase.update('person', data, where: 'id = ?', whereArgs: [data['id']]);
      return data['id'] as int;
    }
  }

  String _getEvaluationId(Map<String, Object?> data) {
    String id = '';
    id = '${data['customerid']}${data['compressorid']}${DateTime.now().millisecondsSinceEpoch.toString()}${Uuid().v4()}';
    return id;
  }
}
