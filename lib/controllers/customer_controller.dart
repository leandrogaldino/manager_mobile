import 'package:manager_mobile/models/person_model.dart';
import 'package:manager_mobile/services/person_service.dart';

class CustomerController {
  CustomerController({required this.personService});

  final PersonService personService;

  List<PersonModel> _customers = [];

  List<PersonModel> get customers => _customers;

  Future<void> fetchCustomers() async {
    _customers = await personService.getAll();
    _customers = _customers.where((person) => person.isCustomer && person.statusId == 0).toList();
  }
}
