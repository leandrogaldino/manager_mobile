import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/evaluation_coalescent_model.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/evaluation_source.dart';
import 'package:manager_mobile/pages/evaluation/enums/oil_types.dart';
import 'package:manager_mobile/services/evaluation_service.dart';
import 'package:manager_mobile/services/person_service.dart';
import 'package:path_provider/path_provider.dart';

class EvaluationController extends ChangeNotifier {
  final EvaluationService evaluationService;
  final PersonService personService;
  EvaluationController({required this.evaluationService, required this.personService});

  Future<void> save() async {
    await saveSignature(signatureBytes: _signatureBytes!, asTemporary: false);
    await evaluationService.save(evaluation!);
    notifyListeners();
  }

  Future<void> deleteTempFiles() async {
    final Directory tempDir = await getTemporaryDirectory();
    String path = _evaluation!.signaturePath ?? '';
    if (path.startsWith(tempDir.path)) {
      File file = File(path);
      bool fileExists = await file.exists();
      if (fileExists) {
        await file.delete();
      }
    }

    for (var photo in _evaluation!.photoPaths) {
      path = photo.path;
      if (path.startsWith(tempDir.path)) {
        File file = File(path);
        bool fileExists = await file.exists();
        if (fileExists) {
          await file.delete();
        }
      }
    }
  }

  Future<void> saveSignature({required Uint8List signatureBytes, required bool asTemporary}) async {
    _evaluation!.signaturePath = await evaluationService.saveSignature(signatureBytes: signatureBytes, asTemporary: asTemporary);
    notifyListeners();
  }

  Uint8List? _signatureBytes;
  Uint8List? get signatureBytes => _signatureBytes;

  Future<void> updateImagesBytes() async {
    final File? signatureFile = _evaluation!.signaturePath != null ? File(_evaluation!.signaturePath!) : null;
    _signatureBytes = signatureFile != null ? await signatureFile.readAsBytes() : null;
    _signatureBytes = signatureBytes;
    notifyListeners();
  }

  void updateSignaturePath(String signaturePath) {
    _evaluation!.signaturePath = signaturePath;
    notifyListeners();
  }

  EvaluationModel? _evaluation;
  EvaluationModel? get evaluation => _evaluation;

  EvaluationSource? _source;

  EvaluationSource? get source => _source;

  void setEvaluation(EvaluationModel? evaluation, EvaluationSource source) {
    _evaluation = evaluation;
    _source = source;
    _signatureBytes = null;
    notifyListeners();
  }

  void setCoalescentNextChange(int index, DateTime? nextChange) {
    _evaluation!.coalescents[index] = _evaluation!.coalescents[index].copyWith(nextChange: nextChange);
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

  void updateHorimeter(int horimeter) {
    _evaluation!.horimeter = horimeter;
    notifyListeners();
  }

  void updateCustomer(PersonModel? customer) {
    _evaluation!.customer = customer;
    notifyListeners();
  }

  void updateCompressor(CompressorModel? compressor) {
    _evaluation!.compressor = compressor;
    _evaluation!.coalescents.clear();
    if (compressor != null) {
      for (var coalescent in evaluation!.compressor!.coalescents) {
        _evaluation!.coalescents.add(EvaluationCoalescentModel(id: 0, coalescent: coalescent));
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

  void addCoalescent(EvaluationCoalescentModel coalescent) {
    _evaluation!.coalescents.add(coalescent);
    notifyListeners();
  }

  void removeCoalescent(EvaluationCoalescentModel coalescent) {
    _evaluation!.coalescents.remove(coalescent);
    notifyListeners();
  }
}
