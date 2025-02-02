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

  void addTechnician(EvaluationTechnicianModel technician) {
    if (_evaluation != null) _evaluation!.technicians.add(technician);
    notifyListeners();
  }

  void removeTechnician(EvaluationTechnicianModel technician) {
    if (_evaluation != null) _evaluation!.technicians.remove(technician);
    notifyListeners();
  }

  OilTypes _selectedOilType = OilTypes.semiSynthetic;
  OilTypes get selectedOilType => _selectedOilType;

  void setOilType(OilTypes oilType) {
    _selectedOilType = oilType;
    notifyListeners();
  }

  List<PersonModel> _customers = [];
  List<PersonModel> get customers => _customers;

  Future<void> fetchCustomers() async {
    _customers = await personService.getAll();
    _customers = _customers.where((person) => person.isCustomer && person.statusId == 0).toList();
    notifyListeners();
  }

  PersonModel? _selectedCustomer;
  PersonModel? get selectedCustomer => _selectedCustomer;
  void setSelectedCustomer(PersonModel? customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  CompressorModel? _selectedCompressor;
  CompressorModel? get selectedCompressor => _selectedCompressor;
  void setSelectedCompressor(CompressorModel? compressor) {
    _selectedCompressor = compressor;
    notifyListeners();
  }
}
