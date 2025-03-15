import 'dart:io';
import 'dart:typed_data';
import 'package:manager_mobile/core/exceptions/service_exception.dart';
import 'package:manager_mobile/core/helper/string_helper.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/evaluation_photo_model.dart';
import 'package:manager_mobile/repositories/evaluation_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class EvaluationService {
  final EvaluationRepository _evaluationRepository;

  EvaluationService({
    required EvaluationRepository evaluationRepository,
  }) : _evaluationRepository = evaluationRepository;

  Future<String> saveSignature({required Uint8List signatureBytes, required bool asTemporary}) async {
    try {
      final rootDirectory = asTemporary ? await getTemporaryDirectory() : await getApplicationDocumentsDirectory();

      final signatureDirectory = asTemporary ? rootDirectory : Directory('${rootDirectory.path}/signatures');
      if (!await signatureDirectory.exists()) {
        await signatureDirectory.create(recursive: true);
      }
      final String fileName = StringHelper.getUniqueString(suffix: '.png');
      final filePath = '${signatureDirectory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(signatureBytes);
      return filePath;
    } catch (e) {
      throw ServiceException('EVA008', 'Erro ao salvar a imagem: $e');
    }
  }

  Future<EvaluationPhotoModel> savePhoto({required Uint8List photoBytes}) async {
    try {
      final rootDirectory = await getApplicationDocumentsDirectory();
      final photosDirectory = Directory('${rootDirectory.path}/photos');
      if (!await photosDirectory.exists()) {
        await photosDirectory.create(recursive: true);
      }
      img.Image? image = img.decodeImage(photoBytes);
      if (image == null) throw Exception('Não foi possível processar a imagem');
      if (image.width > 1024 || image.height > 768) {
        image = img.copyResize(image, width: 1024, height: 768, maintainAspect: true);
      }
      final Uint8List resizedBytes = Uint8List.fromList(img.encodeJpg(image, quality: 85));
      final String fileName = StringHelper.getUniqueString(suffix: '.jpg');
      final filePath = '${photosDirectory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(resizedBytes);
      return EvaluationPhotoModel(path: file.path);
    } catch (e) {
      throw ServiceException('EVA009', 'Erro ao salvar a imagem: $e');
    }
  }

  Future<int> delete(dynamic id) async {
    return await _evaluationRepository.delete(id as int);
  }

  Future<List<EvaluationModel>> getAll() async {
    final data = await _evaluationRepository.getAll();
    return data.map((item) => EvaluationModel.fromMap(item)).toList();
  }

  Future<List<EvaluationModel>> getVisibles() async {
    final data = await _evaluationRepository.getVisibles();
    return data.map((item) => EvaluationModel.fromMap(item)).toList();
  }

  Future<EvaluationModel> save(EvaluationModel model) async {
    final evaluationMap = model.toMap();
    var savedMap = await _evaluationRepository.save(evaluationMap);
    return EvaluationModel.fromMap(savedMap);
  }

  Future<void> synchronize(lastSync) async {
    await _evaluationRepository.synchronize(lastSync);
  }
}
