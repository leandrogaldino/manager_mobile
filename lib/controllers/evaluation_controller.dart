import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:manager_mobile/core/enums/call_types.dart';
import 'package:manager_mobile/models/evaluation_performed_service_model.dart';
import 'package:manager_mobile/models/personcompressor_model.dart';
import 'package:manager_mobile/models/evaluation_coalescent_model.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/evaluation_photo_model.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/visitschedule_model.dart';
import 'package:manager_mobile/core/enums/source_types.dart';
import 'package:manager_mobile/core/enums/oil_types.dart';
import 'package:manager_mobile/services/data_service.dart';
import 'package:manager_mobile/services/evaluation_service.dart';

import 'package:manager_mobile/services/visit_schedule_service.dart';

class EvaluationController extends ChangeNotifier {
  final EvaluationService _evaluationService;
  final VisitScheduleService _visitScheduleService;
  final DataService _dataService;

  EvaluationController({
    required EvaluationService evaluationService,
    required VisitScheduleService visitScheduleService,
    required DataService dataService,
  })  : _evaluationService = evaluationService,
        _visitScheduleService = visitScheduleService,
        _dataService = dataService;

  EvaluationModel? _evaluation;
  EvaluationModel? get evaluation => _evaluation;
  SourceTypes? _source;
  SourceTypes? get source => _source;
  void setEvaluation(EvaluationModel? evaluation, SourceTypes source) {
    _signatureBytes = null;
    _selectedPhotoIndex = 0;
    _photosBytes.clear();
    _schedule = null;
    _evaluation = evaluation;
    _source = source;
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
    notifyListeners();
  }

  Future<void> updateImagesBytes() async {
    final File? signatureFile = _evaluation!.signaturePath != null ? File(_evaluation!.signaturePath!) : null;
    _signatureBytes = signatureFile != null ? await signatureFile.readAsBytes() : null;
    _signatureBytes = signatureBytes;
    _photosBytes.clear();
    for (var photo in _evaluation!.photos) {
      final File photoFile = File(photo.path);
      final Uint8List photoBytes = await photoFile.readAsBytes();
      _photosBytes.add(photoBytes);
    }

    notifyListeners();
  }

  Future<void> save() async {
    await _saveSignature(signatureBytes: _signatureBytes!);
    await _savePhotos(photosBytes: _photosBytes);
    await _evaluationService.save(evaluation!, schedule?.id);

    if (_schedule != null) await _visitScheduleService.updateVisibility(_schedule!.id, false);
    notifyListeners();
  }

  Future<void> _saveSignature({required Uint8List signatureBytes}) async {
    _evaluation!.signaturePath = await _evaluationService.saveSignature(signatureBytes: signatureBytes, asTemporary: false);
  }

  Future<void> saveTempSignature({required Uint8List signatureBytes}) async {
    _evaluation!.signaturePath = await _evaluationService.saveSignature(signatureBytes: signatureBytes, asTemporary: true);
    notifyListeners();
  }

  Future<void> _savePhotos({required List<Uint8List> photosBytes}) async {
    _evaluation!.photos.clear();
    for (var photoBytes in _photosBytes) {
      EvaluationPhotoModel photo = await _evaluationService.savePhoto(photoBytes: photoBytes);
      _evaluation!.photos.add(photo);
    }
  }

  Uint8List? _signatureBytes;
  Uint8List? get signatureBytes => _signatureBytes;

  //void updateSignaturePath(String signaturePath) {
  //_evaluation!.signaturePath = signaturePath;
  //notifyListeners();
  //}

  final List<Uint8List> _photosBytes = [];

  List<Uint8List> get photosBytes => _photosBytes;

  void addPhoto(EvaluationPhotoModel photo) {
    _evaluation!.photos.add(photo);
    notifyListeners();
  }

  void removePhoto(EvaluationPhotoModel photo) {
    _evaluation!.photos.remove(photo);
    notifyListeners();
  }

  void setCoalescentNextChange(int index, DateTime? nextChange) {
    _evaluation!.coalescents[index] = _evaluation!.coalescents[index].copyWith(nextChange: nextChange);
    notifyListeners();
  }

  void updateNeedProposal(bool needProposal) {
    _evaluation!.needProposal = needProposal;
    notifyListeners();
  }

  void updateResponsible(String responsible) {
    _evaluation!.responsible = responsible;
    notifyListeners();
  }

  void updateAdvice(String advice) {
    _evaluation!.advice = advice;
    notifyListeners();
  }

  void updateOil(int oil) {
    _evaluation!.oil = oil;
    notifyListeners();
  }

  void updateSeparator(int separator) {
    _evaluation!.separator = separator;
    notifyListeners();
  }

  void updateOilFilter(int oilFilter) {
    _evaluation!.oilFilter = oilFilter;
    notifyListeners();
  }

  void updateAirFilter(int airFilter) {
    _evaluation!.airFilter = airFilter;
    notifyListeners();
  }

  void updateOilType(OilTypes oilType) {
    _evaluation!.oilType = oilType;
    notifyListeners();
  }

  void updateUnit(String unit) {
    _evaluation!.unitName = unit;
    notifyListeners();
  }

  void updateTemperature(int temperature) {
    _evaluation!.temperature = temperature;
    notifyListeners();
  }

  void updatePresure(double pressure) {
    _evaluation!.pressure = pressure;
    notifyListeners();
  }

  void updateCallType(CallTypes callType) {
    _evaluation!.callType = callType;
    notifyListeners();
  }

  void updateHorimeter(int horimeter) {
    _evaluation!.horimeter = horimeter;
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

  void addCoalescent(EvaluationCoalescentModel coalescent) {
    _evaluation!.coalescents.add(coalescent);
    notifyListeners();
  }

  void removeCoalescent(EvaluationCoalescentModel coalescent) {
    _evaluation!.coalescents.remove(coalescent);
    notifyListeners();
  }

  Future<int> clean() async {
    int count = 0;
    var allEvaluations = await _evaluationService.getAll();
    for (var evaluation in allEvaluations) {
      if (evaluation.creationDate!.isBefore(DateTime.now().subtract(Duration(days: 120)))) {
        await _evaluationService.delete(evaluation.id);
        count += 1;
      }
    }

    var allSchedules = await _visitScheduleService.getAll();
    for (var schedule in allSchedules) {
      if (schedule.creationDate.isBefore(DateTime.now().subtract(Duration(days: 120)))) {
        await _visitScheduleService.delete(schedule.id);
        count += 1;
      }
    }

    return count;
  }

  Future<void> refreshData() async {
    await _dataService.fetchEvaluations();
    await _dataService.fetchVisitSchedules();
    notifyListeners();
  }

  void removePerformedServiceAt(int index) {
    _evaluation!.performedServices.removeAt(index);
    notifyListeners();
  }

  void updatePerformedServiceQuantity(int index, int quantity) {
    _evaluation!.performedServices[index].quantity = quantity;
    notifyListeners();
  }
}
