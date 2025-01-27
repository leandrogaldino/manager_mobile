import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/services/person_service.dart';

class TechnicianController {
  final PersonService _personService;

  TechnicianController({required PersonService personService}) : _personService = personService;
//TODO: Ordem A a Z
  Future<List<PersonModel>> getTechnicians() async {
    var persons = await _personService.getAll();
    var technicians = persons.where((person) => person.isTechnician && person.statusId == 0).toList();
    return technicians;
  }
}
