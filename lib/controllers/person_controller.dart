import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/services/person_service.dart';

class PersonController {
  PersonController({required this.personService});
  final PersonService personService;

//TODO: Necessário ter metodos no PersonRepository e no PersonService que traga do banco de dados somente os clientes e os técnicos. Após isso, refatorar os dois métodos abaixo.

  List<PersonModel> _customers = [];
  List<PersonModel> get customers => _customers;
  Future<void> fetchCustomers() async {
    _customers = await personService.getAll();
    _customers = _customers.where((person) => person.isCustomer && person.statusId == 0).toList();
  }

  List<PersonModel> _technicians = [];
  List<PersonModel> get technicians => _technicians;
  Future<void> fetchTechnicians() async {
    _technicians = await personService.getAll();
    _technicians = _technicians.where((person) => person.isTechnician && person.statusId == 0).toList();
    technicians.sort((a, b) => a.shortName.compareTo(b.shortName));
  }
}
