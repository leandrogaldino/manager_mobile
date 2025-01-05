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

  @override
  Future<Map<String, Object?>> getById(int id) async {
    final Map<String, Object?> evaluation = await _localDatabase.query('evaluation', where: 'id = ?', whereArgs: [id]).then((list) {
      if (list.isEmpty) return {};
      return list[0];
    });
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
    return evaluation;
  }

  @override
  Future<List<Map<String, Object?>>> getByLastUpdate(DateTime lastUpdate) async {
    var evaluations = await _localDatabase.query('evaluation', where: 'lastupdate = ?', whereArgs: [lastUpdate]);
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

  @override
  Future<String> save(Map<String, Object?> data) async {
    if (data['id'] == '') {
      data['id'] = _getEvaluationId(data);
      return await _localDatabase.insert('evaluation', data);
    } else {
      await _localDatabase.update('evaluation', data, where: 'id = ?', whereArgs: [data['id']]);
      return data['id'].toString();
    }
  }

  @override
  Future<SyncronizeResultModel> syncronize(int lastSync) async {
    int uploaded = await _syncronizeFromLocalToCloud(lastSync);
    int downloaded = await _syncronizeFromCloudToLocal(lastSync);
    return SyncronizeResultModel(uploaded: uploaded, downloaded: downloaded);
  }

  String _getEvaluationId(Map<String, Object?> data) {
    String id = '';
    id = '${data['customerid']}${data['compressorid']}${DateTime.now().millisecondsSinceEpoch.toString()}${Uuid().v4()}';
    return id;
  }

  Future<String> _saveImage(Uint8List imageData, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(imageData);
      return filePath;
    } catch (e) {
      throw FileSystemException('Falha ao salvar a imagem no disco.');
    }
  }

  Future<int> _syncronizeFromLocalToCloud(int lastSync) async {
    int uploadedData = 0;
    //MOCK
    /*
        var evaluationId = '${75}${104}${DateTime.now().millisecondsSinceEpoch.toString()}${Uuid().v4()}';
        await _localDatabase.insert('evaluation', {
      'id': evaluationId,
      'compressorid': 104,
      'creationdate': DateTime.now().millisecondsSinceEpoch.toString(),
      'starttime': '07:00',
      'endtime': '09:00',
      'horimeter': '13412',
      'airfilter': '1245',
      'oilfilter': '1245',
      'oil': '3245',
      'separator': '3245',
      'responsible': 'Fulano',
      'advice': 'Sem parecer técnico',
      'signaturepath': '/data/user/0/br.com.lgcodecrafter.manager_mobile/files/file.png',
      'lastupdate': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    await _localDatabase.insert('evaluationcoalescent', {
      'coalescentid': 1986,
      'evaluationid': evaluationId,
      'nextchange': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    await _localDatabase.insert('evaluationtechnician', {
      'personid': 5,
      'evaluationid': evaluationId,
    });
    await _localDatabase.insert('evaluationphoto', {
      'path': '/data/user/0/br.com.lgcodecrafter.manager_mobile/files/file.png',
      'evaluationid': evaluationId,
    });
    await _localDatabase.insert('evaluationinfo', {
      'evaluationid': evaluationId,
      'imported': 0,
      'importedby': '',
      'importeddate': 0,
      'importedid': 0,
      'importingby': '',
      'importingdate': 0,
    });*/
    final localResult = await _localDatabase.query('evaluation', where: 'lastupdate > ?', whereArgs: [lastSync]);
    for (var evaluationMap in localResult) {
      int customerId = await _localDatabase.query('compressor', columns: ['personid'], where: 'id = ?', whereArgs: [evaluationMap['compressorid']]).then((v) => v[0]['personid'] as int);
      String customerDocument = await _localDatabase.query('person', columns: ['document'], where: 'id = ?', whereArgs: [customerId]).then((v) => v[0]['document'].toString());
      customerDocument = customerDocument.replaceAll('.', '').replaceFirst('/', '').replaceFirst('-', '');
      String rootPath = '$customerDocument/${evaluationMap['id']}';
      String signFilename = evaluationMap['signaturepath'].toString().split('/').last;
      String signPath = '$rootPath/signature/$signFilename';
      Uint8List signData = await File(evaluationMap['signaturepath'].toString()).readAsBytes();
      await _storage.uploadFile(signPath, signData);
      evaluationMap['signaturepath'] = signPath;
      var infoMap = await _localDatabase.query('evaluationinfo', columns: ['id', 'imported', 'importedby', 'importeddate', 'importedid', 'importingby', 'importingdate'], where: 'evaluationid = ?', whereArgs: [evaluationMap['id']]).then((v) => v.first);
      evaluationMap['info'] = infoMap;
      var photosListMap = await _localDatabase.query('evaluationphoto', columns: ['id', 'path'], where: 'evaluationid = ?', whereArgs: [evaluationMap['id']]);
      for (var photoMap in photosListMap) {
        String photoFilename = photoMap['path'].toString().split('/').last;
        String photoPath = '$rootPath/photo/$photoFilename';
        Uint8List photoData = await File(photoMap['path'].toString()).readAsBytes();
        await _storage.uploadFile(photoPath, photoData);
        photoMap['path'] = photoPath;
      }
      evaluationMap['photos'] = photosListMap;
      var techniciansMap = await _localDatabase.query('evaluationtechnician', columns: ['id', 'personid'], where: 'evaluationid = ?', whereArgs: [evaluationMap['id']]);
      evaluationMap['technicians'] = techniciansMap;
      var coalescentsMap = await _localDatabase.query('evaluationcoalescent', columns: ['id', 'coalescentid', 'nextchange'], where: 'evaluationid = ?', whereArgs: [evaluationMap['id']]);
      evaluationMap['coalescents'] = coalescentsMap;
      await _remoteDatabase.set(collection: 'evaluations', data: evaluationMap, id: evaluationMap['id'].toString());
      uploadedData += 1;
    }
    return uploadedData;
  }

  Future<int> _syncronizeFromCloudToLocal(int lastSync) async {
    int downloadedData = 0;
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
    return downloadedData;
  }
}
