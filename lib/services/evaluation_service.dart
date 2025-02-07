import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:manager_mobile/core/exceptions/service_exception.dart';
import 'package:manager_mobile/interfaces/deletable.dart';
import 'package:manager_mobile/interfaces/readable.dart';
import 'package:manager_mobile/interfaces/syncronizable.dart';
import 'package:manager_mobile/interfaces/writable.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/syncronize_result_model.dart';
import 'package:manager_mobile/repositories/evaluation_repository.dart';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class EvaluationService implements Readable<EvaluationModel>, Writable<EvaluationModel>, Deletable, Syncronizable {
  final EvaluationRepository _evaluationRepository;

  EvaluationService({
    required EvaluationRepository evaluationRepository,
  }) : _evaluationRepository = evaluationRepository;

  Future<String> saveSignature(Uint8List signatureBytes) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = '${Uuid().v4()}_${DateFormat('ddMMyyyy_HHmmssSSS').format(DateTime.now())}.png';
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(signatureBytes);
      return filePath;
    } catch (e) {
      throw Exception('Erro ao salvar a imagem: $e');
    }
  }

  @override
  Future<int> delete(dynamic id) async {
    return await _evaluationRepository.delete(id as int);
  }

  @override
  Future<List<EvaluationModel>> getAll() async {
    final data = await _evaluationRepository.getAll();
    return data.map((item) => EvaluationModel.fromMap(item)).toList();
  }

  @override
  Future<EvaluationModel> getById(dynamic id) async {
    final data = await _evaluationRepository.getById(id);
    if (data.isNotEmpty) {
      return EvaluationModel.fromMap(data);
    } else {
      throw ServiceException('Avaliação com o id $id não encontrada.');
    }
  }

  @override
  Future<List<EvaluationModel>> getByLastUpdate(DateTime lastUpdate) async {
    final data = await _evaluationRepository.getByLastUpdate(lastUpdate);
    return data.map((item) => EvaluationModel.fromMap(item)).toList();
  }

  @override
  Future<EvaluationModel> save(EvaluationModel model) async {
    final evaluationMap = model.toMap();
    var savedMap = await _evaluationRepository.save(evaluationMap);
    return EvaluationModel.fromMap(savedMap);
  }

  @override
  Future<SyncronizeResultModel> syncronize(lastSync) async {
    return _evaluationRepository.syncronize(lastSync);
  }
}
