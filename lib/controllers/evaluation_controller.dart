import 'package:flutter/material.dart';
import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/evaluation_model.dart';
import 'package:manager_mobile/models/evaluation_technician_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/pages/evaluation/enums/oil_types.dart';
import 'package:manager_mobile/services/person_service.dart';

class EvaluationController extends ChangeNotifier {
  final PersonService personService;
  EvaluationController({required this.personService});

  EvaluationModel? _evaluation;
  EvaluationModel? get evaluation => _evaluation;

  void setEvaluation(EvaluationModel? evaluation) {
    _evaluation = evaluation;
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

  List<PersonModel> _customers = [];
  List<PersonModel> get customers => _customers;

  Future<void> fetchCustomers() async {
    _customers = await personService.getAll();
    _customers = _customers.where((person) => person.isCustomer && person.statusId == 0).toList();
  }
}
