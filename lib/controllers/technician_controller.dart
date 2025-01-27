import 'package:flutter/material.dart';
import 'package:manager_mobile/core/app_preferences.dart';
import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/services/person_service.dart';

class TechnicianController extends ChangeNotifier {
  final PersonService _personService;
  final AppPreferences _appPreferences;
  TechnicianController({
    required PersonService personService,
    required AppPreferences appPreferences,
  })  : _personService = personService,
        _appPreferences = appPreferences;

  int _loggedTechnicianId = 0;

  int get loggedTechnicianId => _loggedTechnicianId;

  Future<void> setLoggedTechnicianId(int id) async {
    await _appPreferences.setLoggedTechnicianId(id);
    _loggedTechnicianId = id;
    notifyListeners();
  }

  Future<int> getLoggedTechnicianId() async {
    _loggedTechnicianId = await _appPreferences.getLoggedTechnicianId;
    notifyListeners();
    return _loggedTechnicianId;
  }

  Future<List<PersonModel>> getTechnicians() async {
    var persons = await _personService.getAll();
    var technicians = persons.where((person) => person.isTechnician && person.statusId == 0).toList();
    technicians.sort((a, b) => a.shortName.compareTo(b.shortName));
    var logged = await _appPreferences.getLoggedTechnicianId;
    if (logged > 0) {
      _loggedTechnicianId = logged;
      var index = technicians.indexWhere((technician) => technician.id == logged);
      if (index != -1) {
        var item = technicians.removeAt(index);
        technicians.insert(0, item);
      }
    }
    return technicians;
  }
}
