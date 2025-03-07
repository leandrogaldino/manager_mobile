import 'dart:developer';

import 'package:manager_mobile/models/compressor_model.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/services/compressor_service.dart';
import 'package:manager_mobile/services/person_service.dart';

class PersonController {
  PersonController({required this.personService, required this.compressorService});
  final PersonService personService;
  final CompressorService compressorService;

  List<PersonModel> _customers = [];
  List<PersonModel> get customers => _customers;
  Future<void> fetchCustomers() async {
    _customers = await personService.getCustomers();
    _customers = _customers.where((person) => person.statusId == 0).toList();

    List<CompressorModel> compressors = await compressorService.getAll();

    log(compressors.length.toString());
  }

  List<PersonModel> _technicians = [];
  List<PersonModel> get technicians => _technicians;
  Future<void> fetchTechnicians() async {
    _technicians = await personService.getTechnicians();
    _technicians = _technicians.where((person) => person.statusId == 0).toList();
    technicians.sort((a, b) => a.shortName.compareTo(b.shortName));
  }
}
