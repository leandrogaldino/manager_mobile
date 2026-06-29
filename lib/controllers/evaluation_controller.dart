import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:manager_mobile/core/enums/call_types.dart';
import 'package:manager_mobile/core/enums/image_types.dart';
import 'package:manager_mobile/core/enums/oil_types.dart';
import 'package:manager_mobile/models/evaluation_performed_service_model.dart';
import 'package:manager_mobile/models/evaluation_replaced_product_model.dart';
import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/models/evaluation_coalescent_model.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/evaluation_photo_model.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/visitschedule_model.dart';
import 'package:manager_mobile/core/enums/source_types.dart';
import 'package:manager_mobile/services/evaluation_service.dart';
import 'package:manager_mobile/services/image_service.dart';
import 'package:manager_mobile/services/visit_schedule_service.dart';
import 'package:path/path.dart' as path;

class EvaluationController extends ChangeNotifier {
  final EvaluationService _evaluationService;
  final VisitScheduleService _visitScheduleService;
  final ImageService _imageService;

  EvaluationController({
    required EvaluationService evaluationService,
    required VisitScheduleService visitScheduleService,
    required ImageService imageService,
  })  : _evaluationService = evaluationService,
        _visitScheduleService = visitScheduleService,
        _imageService = imageService;

  EvaluationModel? _evaluation;
  EvaluationModel? get evaluation => _evaluation;
  SourceTypes? _source;
  SourceTypes? get source => _source;
  EvaluationModel? shadow;

  Future<void> downloadSignature() async {
    final cloudPath = evaluation!.signatureCloudPath!;
    final imageData = await _evaluationService.downloadImage(cloudPath);
    final localPath = await _imageService.savePermanentFromBytes(type: ImageTypes.signature, filename: path.basename(cloudPath), imageBytes: imageData);
    evaluation!.signatureTempPath = null;
    evaluation!.signatureLocalPath = localPath;
    await _evaluationService.updateSignatureWithLocalPath(evaluation!.id!, localPath);
    notifyListeners();
  }

  Future<String> saveTempPhoto({required String path}) async {
    var tempPath = await _imageService.saveTemporaryFromPath(type: ImageTypes.photo, tempImagePath: path);
    return tempPath;
  }

  Future<void> saveTempSignature({Uint8List? signatureBytes}) async {
    if (signatureBytes == null) {
      evaluation!.signatureTempPath = null;
    } else {
      evaluation!.signatureTempPath = await _imageService.saveTemporaryFromBytes(ImageTypes.signature, signatureBytes);
      _evaluation!.signatureLocalPath = null;
      _evaluation!.signatureCloudPath = null;
    }
    notifyListeners();
  }

  Future<void> _savePermanentPhoto(EvaluationPhotoModel photo) async {
    if (photo.tempPath != null && await File(photo.tempPath!).exists()) {
      final photoPath = await _imageService.savePermanentFromPath(type: ImageTypes.photo, tempImagePath: photo.tempPath!);
      photo.localPath = photoPath;
      photo.tempPath = null;
    }
  }

  Future<void> _savePermanentSignature() async {
    if (evaluation!.signatureTempPath != null && await File(evaluation!.signatureTempPath!).exists()) {
      final signaturePath = await _imageService.savePermanentFromPath(type: ImageTypes.signature, tempImagePath: evaluation!.signatureTempPath!);
      _evaluation!.signatureLocalPath = signaturePath;
      _evaluation!.signatureTempPath = null;
    }
  }

  Future<void> downloadPhotos() async {
    final photos = evaluation!.photos;

    final futures = photos.where((photo) => photo.cloudPath != null && photo.localPath == null).map((photo) async {
      final imageData = await _evaluationService.downloadImage(
        photo.cloudPath!,
      );

      final localPath = await _imageService.savePermanentFromBytes(
        type: ImageTypes.photo,
        filename: path.basename(photo.cloudPath!),
        imageBytes: imageData,
      );

      photo.localPath = localPath;
      photo.tempPath = null;

      await _evaluationService.updatePhotoWithLocalPath(
        evaluation!.id!,
        photo,
      );
    });

    await Future.wait(futures);

    notifyListeners();
  }

  void setEvaluation(EvaluationModel? evaluation, SourceTypes source) {
    _selectedPhotoIndex = 0;

    _schedule = null;
    _evaluation = evaluation;
    shadow = evaluation?.copyWith();
    _source = source;
    if (_schedule != null && _evaluation != null) {
      _evaluation!.visitscheduleid = _schedule!.id;
    } else {
      _evaluation!.visitscheduleid = null;
    }
    notifyListeners();
  }

  int? _selectedPhotoIndex;
  int? get selectedPhotoIndex => _selectedPhotoIndex;
  void setSelectedPhotoIndex(int? index) {
    _selectedPhotoIndex = index;
  }

  VisitScheduleModel? _schedule;
  VisitScheduleModel? get schedule => _schedule;
  void setSchedule(VisitScheduleModel? schedule) {
    _schedule = schedule;
    if (_schedule != null && _evaluation != null) {
      _evaluation!.visitscheduleid = _schedule!.id;
    } else {
      _evaluation!.visitscheduleid = null;
    }
    notifyListeners();
  }

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  Future<void> save() async {
    _isSaving = true;
    notifyListeners();

    try {
      if (evaluation!.signatureTempPath != null) {
        await _savePermanentSignature();
      }

      for (var photo in evaluation!.photos) {
        if (photo.tempPath != null) {
          await _savePermanentPhoto(photo);
        }
      }

      await _evaluationService.save(evaluation!.copyWith(), schedule?.id);

      if (_schedule != null) {
        await _visitScheduleService.updateVisibility(
          _schedule!.id,
          false,
        );
      }
    } catch (e, s) {
      _uiMessage = 'Erro ao salvar avaliação';
      log(e.toString(), stackTrace: s);
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  String? _uiMessage;

  String? consumeMessage() {
    final message = _uiMessage;
    _uiMessage = null;
    return message;
  }

  void addPhoto(EvaluationPhotoModel photo) {
    _evaluation!.photos.add(photo);
    notifyListeners();
  }

  void removePhoto(EvaluationPhotoModel photo) {
    _evaluation!.photos.remove(photo);
    notifyListeners();
  }

  void setCoalescentNextChange(int index, DateTime? nextChange) {
    _evaluation!.coalescents[index].nextChange = nextChange;
    notifyListeners();
  }

  void setIgnoreCoalescentNextChange(int index, bool ignore) {
    _evaluation!.coalescents[index].ignoreNextChange = ignore;
    _evaluation!.coalescents[index].nextChange = null;
    notifyListeners();
  }

  void updateTemperature(int temperature) {
    _evaluation!.temperature = temperature;
  }

  void updatePresure(double? pressure) {
    _evaluation!.pressure = pressure;
  }

  void updateHorimeter(int horimeter) {
    _evaluation!.horimeter = horimeter;
  }

  void updateGreasing(int? greasing) {
    _evaluation!.greasing = greasing;
  }

  void updateAirFilter(int airFilter) {
    _evaluation!.airFilter = airFilter;
  }

  void updateOilFilter(int oilFilter) {
    _evaluation!.oilFilter = oilFilter;
  }

  void updateSeparator(int separator) {
    _evaluation!.separator = separator;
  }

  void updateOil(int oil) {
    _evaluation!.oil = oil;
  }

  void updateNeedProposal(bool needProposal) {
    _evaluation!.needProposal = needProposal;
    notifyListeners();
  }

  void updateResponsible(String responsible) {
    _evaluation!.responsible = responsible;
  }

  void updateAdvice(String advice) {
    _evaluation!.advice = advice;
  }

  void updateOilType(OilTypes oilType) {
    _evaluation!.oilType = oilType;
    notifyListeners();
  }

  void updateCallType(CallTypes callType) {
    _evaluation!.callType = callType;
    notifyListeners();
  }

  void updateCompressor(PersonCompressorModel? compressor) {
    _evaluation!.compressor = compressor;
    _evaluation!.customer = compressor?.person;
    _evaluation!.coalescents.clear();
    if (compressor != null) {
      for (var coalescent in evaluation!.compressor!.coalescents) {
        _evaluation!.coalescents.add(EvaluationCoalescentModel(coalescent: coalescent));
      }
    }
    notifyListeners();
  }

  void addTechnician(EvaluationTechnicianModel technician) {
    _evaluation!.technicians.add(technician);
    notifyListeners();
  }

  void removeTechnician(EvaluationTechnicianModel technician) {
    _evaluation!.technicians.remove(technician);
    notifyListeners();
  }

  void addPerformedService(EvaluationPerformedServiceModel performedService) {
    _evaluation!.performedServices.add(performedService);
    notifyListeners();
  }

  void removePerformedService(EvaluationPerformedServiceModel performedService) {
    _evaluation!.performedServices.remove(performedService);
    notifyListeners();
  }

  void updatePerformedServiceQuantity(int index, int quantity) {
    _evaluation!.performedServices[index].quantity = quantity;
    notifyListeners();
  }

  void addReplacedProduct(EvaluationReplacedProductModel replacedProduct) {
    _evaluation!.replacedProducts.add(replacedProduct);
    notifyListeners();
  }

  void removeReplacedProduct(EvaluationReplacedProductModel replacedProduct) {
    _evaluation!.replacedProducts.remove(replacedProduct);
    notifyListeners();
  }

  void updateReplacedProductQuantity(int index, int quantity) {
    _evaluation!.replacedProducts[index].quantity = quantity;
    notifyListeners();
  }

  void addCoalescent(EvaluationCoalescentModel coalescent) {
    _evaluation!.coalescents.add(coalescent);
    notifyListeners();
  }

  void removeCoalescent(EvaluationCoalescentModel coalescent) {
    _evaluation!.coalescents.remove(coalescent);
    notifyListeners();
  }

  void clean() {
    _evaluation = shadow!.copyWith();
    _evaluation = null;
    _schedule = null;
    _source = null;
    _selectedPhotoIndex = null;
    _isSaving = false;
    _uiMessage = null;
    shadow = null;
  }

  static const int _retentionDays = 30;
  Future<int> periodicClean() async {
    int count = 0;
    var allEvaluations = await _evaluationService.getAll();
    for (var evaluation in allEvaluations) {
      if (evaluation.creationDate!.isBefore(DateTime.now().subtract(Duration(days: _retentionDays)))) {
        await _evaluationService.delete(evaluation.id);
        await _evaluationService.deleteSignature(signaturePath: evaluation.signatureLocalPath);
        await _evaluationService.deletePhotos(photos: evaluation.photos);
        count += 1;
      }
    }

    var allSchedules = await _visitScheduleService.getAll();
    for (var schedule in allSchedules) {
      final limit = DateTime.now().subtract(Duration(days: _retentionDays));
      if (schedule.creationDate.isBefore(limit) && !schedule.visible) {
        await _visitScheduleService.delete(schedule.id);
        count += 1;
      }
    }

    return count;
  }
}
